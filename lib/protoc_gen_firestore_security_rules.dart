import 'dart:convert';
import 'dart:io';

import 'package:dart_casing/dart_casing.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protoc_gen_firestore_security_rules/src/proto/descriptor.pb.dart';
import 'package:protoc_gen_firestore_security_rules/src/proto/firestore_extensions.pb.dart';
import 'package:protoc_gen_firestore_security_rules/src/proto/plugin.pb.dart';

class IndentedBuffer extends StringBuffer {
  String indentation;
  IndentedBuffer({this.indentation = '  '});

  int _indent = 0;
  void indent([int amount = 1]) {
    _indent += amount;
  }

  void unindent([int amount = -1]) => indent(amount);

  /// Writes an indented line
  void writeIndented(Object obj, {bool newLine = true}) {
    for (final line in LineSplitter.split(obj.toString())) {
      write(indentation * _indent);
      if (newLine) {
        writeln(line);
      } else {
        write(line);
      }
    }
  }
}

String toStringList(List<String> list) {
  return list.map((e) => '"$e"').toList().toString();
}

enum RuleLangType {
  bool,
  bytes,
  duration,
  float,
  int,
  latlng,
  list,
  map,
  number,
  path,
  set,
  string,
  timestamp;

  static RuleLangType from(FieldDescriptorProto field) {
    if (field.label == FieldDescriptorProto_Label.LABEL_REPEATED) {
      return list;
    }
    return switch (field.type) {
      FieldDescriptorProto_Type.TYPE_DOUBLE => float,
      FieldDescriptorProto_Type.TYPE_FLOAT => float,
      FieldDescriptorProto_Type.TYPE_INT64 => int,
      FieldDescriptorProto_Type.TYPE_UINT64 => int,
      FieldDescriptorProto_Type.TYPE_INT32 => int,
      FieldDescriptorProto_Type.TYPE_FIXED64 => int,
      FieldDescriptorProto_Type.TYPE_FIXED32 => int,
      FieldDescriptorProto_Type.TYPE_BOOL => bool,
      FieldDescriptorProto_Type.TYPE_STRING => string,
      FieldDescriptorProto_Type.TYPE_GROUP => throw UnimplementedError("huh"),
      FieldDescriptorProto_Type.TYPE_MESSAGE => map,
      FieldDescriptorProto_Type.TYPE_BYTES => bytes,
      FieldDescriptorProto_Type.TYPE_UINT32 => int,
      FieldDescriptorProto_Type.TYPE_ENUM => string,
      FieldDescriptorProto_Type.TYPE_SFIXED32 => int,
      FieldDescriptorProto_Type.TYPE_SFIXED64 => int,
      FieldDescriptorProto_Type.TYPE_SINT32 => int,
      FieldDescriptorProto_Type.TYPE_SINT64 => int,
      _ => throw UnimplementedError("Unknown type for field: $field"),
    };
  }
}

class Path {
  final String path;
  final List<String> args;
  const Path({required this.path, required this.args});
}

extension on FirestoreMessageOptions {
  Path path(String name) {
    final idName = Casing.camelCase('${name}Id');
    if (hasCollection()) {
      return Path(path: '$collection/\$($idName)', args: [idName]);
    }
    if (hasDocument()) return Path(path: document, args: []);
    throw StateError("Options must have path set to get the path");
  }
}

class Context {
  final DescriptorProto descriptor;
  final FirestoreMessageOptions? options;
  final Context? parent;

  const Context(this.descriptor, {this.options, this.parent});
  Context withOptions(FirestoreMessageOptions options) {
    return Context(descriptor, parent: parent, options: options);
  }

  // String docId() {
  //   return switch (options?.whichPath()) {
  //     FirestoreMessageOptions_Path.collection =>
  //       Casing.camelCase(descriptor.name),
  //     FirestoreMessageOptions_Path.document => options!.document,
  //     _ => throw StateError("No docID"),
  //   };
  // }

  Path fullPath() {
    if (options == null) {
      throw StateError("Can't get path without firebase message options");
    }
    final path = options!.path(descriptor.name);
    if (parent == null) {
      return Path(
        path: '/databases/\$(database)/documents${path.path}',
        args: ['database', ...path.args],
      );
    } else {
      final parentPath = parent!.fullPath();
      return Path(
        path: parentPath.path + path.path,
        args: parentPath.args + path.args,
      );
    }
  }

  String messagePath() {
    return (parent?.messagePath() ?? '') + descriptor.name;
  }

  String validatorName() {
    return 'is${messagePath()}Message';
  }
}

class SecurityRulesGenerator {
  static void run() async {
    final registry = ExtensionRegistry();
    Firestore_extensions.registerAllExtensions(registry);
    final request = await stdin
        .map((bytes) => CodeGeneratorRequest.fromBuffer(bytes, registry))
        .single;
    SecurityRulesGenerator(request);
  }

  final messageRegistry = <String, DescriptorProto>{};
  final functionsBuffer = IndentedBuffer();
  final matchBuffer = IndentedBuffer();

  SecurityRulesGenerator(CodeGeneratorRequest request) {
    fillBuffers(request);

    final fullContents = IndentedBuffer();
    fullContents.writeln("rules_version = '2';");
    fullContents.writeln();
    fullContents.writeIndented(functionsBuffer);
    // fullContents.writeln();
    fullContents.writeIndented('service cloud.firestore {');
    fullContents.indent();
    fullContents.writeIndented('function authed() {');
    fullContents.writeIndented('  return request.auth != null');
    fullContents.writeIndented('}');
    fullContents.writeIndented('match /databases/{database}/documents {');
    fullContents.indent();
    fullContents.writeIndented(matchBuffer);
    fullContents.unindent();
    fullContents.writeIndented('}');
    fullContents.unindent();
    fullContents.writeIndented('}');

    final file = CodeGeneratorResponse_File()
      ..name = 'firestore.rules'
      ..content = fullContents.toString();
    final response = CodeGeneratorResponse()..file.add(file);
    stdout.add(response.writeToBuffer());
  }

  fillBuffers(CodeGeneratorRequest request) {
    for (final fileDescriptor in request.protoFile) {
      for (final messageType in fileDescriptor.messageType) {
        handleMessage(Context(messageType));
      }
    }
  }

  void handleMessage(Context context) {
    final descriptor = context.descriptor;
    messageRegistry[descriptor.name] = descriptor;
    final firestoreOptions = descriptor.options.getExtension(
      Firestore_extensions.firestoreMessageOptions,
    ) as FirestoreMessageOptions;
    if (firestoreOptions.whichPath() != FirestoreMessageOptions_Path.notSet) {
      handleFirestoreMessage(context.withOptions(firestoreOptions));
    }
  }

  void handleFirestoreMessage(Context context) {
    // Write isMessage function
    writeMessageValidator(context);

    // Writing match section
    final name = Casing.camelCase(context.descriptor.name);
    final options = context.options!;
    switch (options.whichPath()) {
      case FirestoreMessageOptions_Path.collection:
        matchBuffer.writeIndented('match ${options.collection}/{${name}Id} {');
      case FirestoreMessageOptions_Path.document:
        matchBuffer.writeIndented('match ${options.document} {');
      default:
    }

    matchBuffer.indent();
    writeAllows(context);

    for (final nested in context.descriptor.nestedType) {
      handleMessage(Context(nested, parent: context));
    }

    if (options.exists) {
      final path = context.fullPath();
      functionsBuffer.writeIndented(
        'function exists${context.messagePath()}(${path.args.join(', ')}) {',
      );
      functionsBuffer.writeIndented('  return exists(${path.path});');
      functionsBuffer.writeIndented('}');
      functionsBuffer.writeln();
    }

    for (final field in context.descriptor.field) {
      final fieldOptions = field.options.getExtension(
        Firestore_extensions.firestoreFieldOptions,
      ) as FirestoreFieldOptions;
      final path = context.fullPath();
      final fieldName = Casing.pascalCase(field.jsonName);
      if (fieldOptions.getter) {
        functionsBuffer.writeIndented(
          'function get${context.messagePath()}$fieldName(${path.args.join(', ')}) {',
        );
        functionsBuffer.writeIndented('  let resource = get(${path.path});');
        functionsBuffer.writeIndented('  if (resource == null) return null;');
        functionsBuffer
            .writeIndented('  return resource.data.${field.jsonName};');
        functionsBuffer.writeIndented('}');
        functionsBuffer.writeln();
      }
    }

    matchBuffer.unindent();

    matchBuffer.writeIndented('}');
  }

  void writeMessageValidator(Context context) {
    final fieldNames = context.descriptor.field.map((f) => f.jsonName).toList();
    functionsBuffer.writeIndented(
      'function ${context.validatorName()}(data) {',
    );
    functionsBuffer.indent();

    functionsBuffer.writeIndented(
      'return data.keys().hasOnly(${toStringList(fieldNames)})',
      newLine: false,
    );

    functionsBuffer.indent();
    for (final field in context.descriptor.field) {
      functionsBuffer.writeln(' &&');
      functionsBuffer.writeIndented(
        "((!data.keys().hasAny(['${field.jsonName}'])) || (data.${field.jsonName} is ${RuleLangType.from(field).name}))",
        newLine: false,
      );
    }
    functionsBuffer.writeln(';');
    functionsBuffer.unindent();

    functionsBuffer.unindent();
    functionsBuffer.writeIndented('}');
    functionsBuffer.writeln();
  }

  void writeAllows(Context context) {
    final options = context.options;
    if (options == null) return;
    final allowGet = options.get.isNotEmpty ? options.get : 'false';
    final allowList = options.list.isNotEmpty ? options.list : 'false';
    var allowCreate = '${context.validatorName()}(request.resource.data)';
    if (options.create_5.isNotEmpty) allowCreate += ' && ${options.create_5}';
    final allowDelete = options.delete.isNotEmpty ? options.delete : 'false';
    var allowUpdate = '${context.validatorName()}(request.resource.data)';
    if (options.update.isNotEmpty) allowUpdate += ' && ${options.update}';

    matchBuffer.writeIndented('allow get: if $allowGet;');
    matchBuffer.writeIndented('allow list: if $allowList;');
    matchBuffer.writeIndented('allow create: if $allowCreate;');
    matchBuffer.writeIndented('allow delete: if $allowDelete;');
    matchBuffer.writeIndented('allow update: if $allowUpdate;');
  }
}
