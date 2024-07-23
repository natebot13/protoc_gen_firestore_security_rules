# protoc_gen_firestore_security_rules

Define your schema with protobuf files, and let this protoc plugin generate your security rules.

Writing security rules is tedious, especially if you want to validate a specific schema, and prefer not to flip back and forth between your proto files and your rules file while developing your storage solution. Ideally, you can write your schema once, and valid rules can be generated from that schema automatically. That's what this plugin tries to achieve. It generates your full rules file, which includes functions for validating the proto schema, and also the match definitions based on some custom options. This lets you mix your schema with where you plan to store the data, making schema development fast and keeps you in one file while adding new models.

Here's an example of a proto file with rules data mixed in:

```proto
syntax = "proto3";

import "firestore_extensions.proto";

message Sample {
  option (firestore_message_options) = {
    collection : "/someproject/database/samples"
    get : "authed() && existsSampleUser(database, sampleId, "
          "request.auth.uid)"
    list : "authed()"
    create : "authed()"
    delete : "authed()"
    update : "authed()"
  };

  message User {
    option (firestore_message_options) = {
      collection : "/users"
      exists : true
      get : "authed()"
      list : "authed()"
      create : "authed()"
      delete : "authed()"
      update : "authed()"
    };
    enum Role {
      viewer = 0;
      editor = 1;
      owner = 2;
    }
    Role role = 1 [ (firestore_field_options) = {getter : true} ];
  }

  string name = 1;
  int32 version = 2;
  repeated Reading readings = 3;
}

message Reading { float value = 1; }
```

This proto file defines a collection of models, and specifies where they will be stored in firestore (via `collection` under `firestore_message_options`). The resulting `firestore.rules` file will look like this:

```javascript
rules_version = '2';

function isSampleMessage(data) {
  return data.keys().hasOnly(["name", "version", "readings"]) &&
    ((!data.keys().hasAny(['name'])) || (data.name is string)) &&
    ((!data.keys().hasAny(['version'])) || (data.version is int)) &&
    ((!data.keys().hasAny(['readings'])) || (data.readings is list));
}

function isSampleUserMessage(data) {
  return data.keys().hasOnly(["role"]) &&
    ((!data.keys().hasAny(['role'])) || (data.role is string));
}

function existsSampleUser(database, sampleId, userId) {
  return exists(/databases/$(database)/documents/someproject/database/samples/$(sampleId)/users/$(userId));
}

function getSampleUserRole(database, sampleId, userId) {
  let resource = get(/databases/$(database)/documents/someproject/database/samples/$(sampleId)/users/$(userId));
  if (resource == null) return null;
  return resource.data.role;
}

service cloud.firestore {
  function authed() {
    return request.auth != null
  }
  match /databases/{database}/documents {
    match /someproject/database/samples/{sampleId} {
      allow get: if authed() && existsSampleUser(database, sampleId, request.auth.uid);
      allow list: if authed();
      allow create: if isSampleMessage(request.resource.data) && authed();
      allow delete: if authed();
      allow update: if isSampleMessage(request.resource.data) && authed();
      match /users/{userId} {
        allow get: if authed();
        allow list: if authed();
        allow create: if isSampleUserMessage(request.resource.data) && authed();
        allow delete: if authed();
        allow update: if isSampleUserMessage(request.resource.data) && authed();
      }
    }
  }
}

```

> NOTE: This output is a work in progress. I'm still working on sub-message validation

Notice that validation function are generated checking the fields of the proto, as well as match section defining the permissions for each kind of action. Additionally, the nested message (`User`) is also generates a nested match block under a different collection.

`get$name()` and `exists$name()` methods on fields and messages can also be generated in case a rule needs to check data from other locations. I haven't figured out a good way to reference the right $name other than just knowing and hand writing the name for the to-be-generated function, but it's better than writing out the whole path by hand. Similarly, I need to rethink how to pass the right variables into those methods, since right now, you just have to assume they exist as a specific name.

Additionally, general convenience methods are generated (only `authed()` for now) that can be used to shorten repetitive common checks.

## Usage

Check `.vscode/tasks.json` for an example of how I'm running it. Basically, the plugin is compiled using `dart compile`, and then the executable is passed as a plugin to `protoc`. To use the custom options in your protos, either copy my `firestore_extensions.proto` and `descriptor.proto` to your proto folder, or point protoc to this repo's proto folder by adding a `--proto_path <path to protos>`. Just fyi, protoc supports multiple `proto_path` args (something that took me a while to learn) allowing any number of directories to be included in protobuf generation.

The output will be a `firestore.rules` file in the specified output directory.

## TODO:

- [ ] Handle sub-message and enum validation
- [ ] Add enum options (string vs int value)
- [ ] Consider adding an option to validate via field numbers instead of names for protobuf backwards compatibility behavior
- [ ] Actually check that it's outputting valid rules (haven't actually tested any rules yet :grimace:)
- [ ] Set up github actions to compile the plugin for multiple platforms
- [ ] Write a dart build_runner builder for easier generation in dart projects
- [ ] Add more common validation functions
