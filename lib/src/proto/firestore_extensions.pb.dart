///
//  Generated code. Do not modify.
//  source: firestore_extensions.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

enum FirestoreMessageOptions_Path {
  collection, 
  document, 
  notSet
}

class FirestoreMessageOptions extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, FirestoreMessageOptions_Path> _FirestoreMessageOptions_PathByTag = {
    1 : FirestoreMessageOptions_Path.collection,
    2 : FirestoreMessageOptions_Path.document,
    0 : FirestoreMessageOptions_Path.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FirestoreMessageOptions', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'collection')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'document')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'get')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'list')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'create')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'delete')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'update')
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'exists')
    ..hasRequiredFields = false
  ;

  FirestoreMessageOptions._() : super();
  factory FirestoreMessageOptions({
    $core.String? collection,
    $core.String? document,
    $core.String? get,
    $core.String? list,
    $core.String? create_5,
    $core.String? delete,
    $core.String? update,
    $core.bool? exists,
  }) {
    final _result = create();
    if (collection != null) {
      _result.collection = collection;
    }
    if (document != null) {
      _result.document = document;
    }
    if (get != null) {
      _result.get = get;
    }
    if (list != null) {
      _result.list = list;
    }
    if (create_5 != null) {
      _result.create_5 = create_5;
    }
    if (delete != null) {
      _result.delete = delete;
    }
    if (update != null) {
      _result.update = update;
    }
    if (exists != null) {
      _result.exists = exists;
    }
    return _result;
  }
  factory FirestoreMessageOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FirestoreMessageOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FirestoreMessageOptions clone() => FirestoreMessageOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FirestoreMessageOptions copyWith(void Function(FirestoreMessageOptions) updates) => super.copyWith((message) => updates(message as FirestoreMessageOptions)) as FirestoreMessageOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FirestoreMessageOptions create() => FirestoreMessageOptions._();
  FirestoreMessageOptions createEmptyInstance() => create();
  static $pb.PbList<FirestoreMessageOptions> createRepeated() => $pb.PbList<FirestoreMessageOptions>();
  @$core.pragma('dart2js:noInline')
  static FirestoreMessageOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FirestoreMessageOptions>(create);
  static FirestoreMessageOptions? _defaultInstance;

  FirestoreMessageOptions_Path whichPath() => _FirestoreMessageOptions_PathByTag[$_whichOneof(0)]!;
  void clearPath() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get collection => $_getSZ(0);
  @$pb.TagNumber(1)
  set collection($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCollection() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollection() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get document => $_getSZ(1);
  @$pb.TagNumber(2)
  set document($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDocument() => $_has(1);
  @$pb.TagNumber(2)
  void clearDocument() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get get => $_getSZ(2);
  @$pb.TagNumber(3)
  set get($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGet() => $_has(2);
  @$pb.TagNumber(3)
  void clearGet() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get list => $_getSZ(3);
  @$pb.TagNumber(4)
  set list($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasList() => $_has(3);
  @$pb.TagNumber(4)
  void clearList() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get create_5 => $_getSZ(4);
  @$pb.TagNumber(5)
  set create_5($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreate_5() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreate_5() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get delete => $_getSZ(5);
  @$pb.TagNumber(6)
  set delete($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDelete() => $_has(5);
  @$pb.TagNumber(6)
  void clearDelete() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get update => $_getSZ(6);
  @$pb.TagNumber(7)
  set update($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasUpdate() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdate() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get exists => $_getBF(7);
  @$pb.TagNumber(8)
  set exists($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasExists() => $_has(7);
  @$pb.TagNumber(8)
  void clearExists() => clearField(8);
}

class FirestoreFieldOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FirestoreFieldOptions', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'getter')
    ..hasRequiredFields = false
  ;

  FirestoreFieldOptions._() : super();
  factory FirestoreFieldOptions({
    $core.bool? getter,
  }) {
    final _result = create();
    if (getter != null) {
      _result.getter = getter;
    }
    return _result;
  }
  factory FirestoreFieldOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FirestoreFieldOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FirestoreFieldOptions clone() => FirestoreFieldOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FirestoreFieldOptions copyWith(void Function(FirestoreFieldOptions) updates) => super.copyWith((message) => updates(message as FirestoreFieldOptions)) as FirestoreFieldOptions; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FirestoreFieldOptions create() => FirestoreFieldOptions._();
  FirestoreFieldOptions createEmptyInstance() => create();
  static $pb.PbList<FirestoreFieldOptions> createRepeated() => $pb.PbList<FirestoreFieldOptions>();
  @$core.pragma('dart2js:noInline')
  static FirestoreFieldOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FirestoreFieldOptions>(create);
  static FirestoreFieldOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get getter => $_getBF(0);
  @$pb.TagNumber(1)
  set getter($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGetter() => $_has(0);
  @$pb.TagNumber(1)
  void clearGetter() => clearField(1);
}

class Firestore_extensions {
  static final firestoreMessageOptions = $pb.Extension<FirestoreMessageOptions>(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'google.protobuf.MessageOptions', const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firestoreMessageOptions', 50001, $pb.PbFieldType.OM, defaultOrMaker: FirestoreMessageOptions.getDefault, subBuilder: FirestoreMessageOptions.create);
  static final firestoreFieldOptions = $pb.Extension<FirestoreFieldOptions>(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'google.protobuf.FieldOptions', const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firestoreFieldOptions', 50002, $pb.PbFieldType.OM, defaultOrMaker: FirestoreFieldOptions.getDefault, subBuilder: FirestoreFieldOptions.create);
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(firestoreMessageOptions);
    registry.add(firestoreFieldOptions);
  }
}

