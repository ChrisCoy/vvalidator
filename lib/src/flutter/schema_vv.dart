import 'package:flutter/widgets.dart';
import 'package:vvalidator/src/flutter/field_vv.dart';

import 'errors_vv.dart';

abstract class SchemaVV {
  // these two fields needs to be private to avoid direct access, therefore avoid losing formKey
  Map<String, String> _errors = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> get errors => _errors;

  GlobalKey<FormState> get formKey => _formKey;

  SchemaVV({required bool fillInitial}) {
    print("lol");
    if (!fillInitial) {
      return;
    }

    // var emailField = fields["email"];
    // print("lol hahaha " + (emailField?.initial ?? ""));

    // print("lol2");

    // bool wasEverythingAttached(){}

    void fill() async {
      // workaround to put the initial value in the field
      await Future.delayed(const Duration(milliseconds: 0));
      Map<String, FieldVV> fields = getFields();
      var entries = fields.entries;

      for (var entry in entries) {
        if (entry.value.initial != null) {
          print("lol4");
          entry.value.controller.text = entry.value.initial!;
        }
      }
    }

    fill();

    // fill() async {
    //   await Future.delayed(const Duration(milliseconds: 1000));

    //   print("lol3");

    //   var entries = fields.entries;

    //   if (emailField != null) {
    //     emailField.controller.text = emailField.initial ?? '';
    //   }

    //   // for (var entry in entries) {
    //   //   if (entry.value.initial != null) {
    //   //     print("lol4");
    //   //     entry.value.controller.text = entry.value.initial!;
    //   //   }
    //   // }
    // }

    // fill();
  }

  // this need to be protected because it only can be called in the child class
  @protected
  void refineField(FieldVV field, String? Function(String?) rule) {
    var oldValidator = field.validator;

    field.validator = (v) {
      var error = rule(v);

      if (error != null) {
        return error;
      }

      return oldValidator(v);
    };
  }

  Map<String, FieldVV> getFields();

  bool validate() {
    Map<String, FieldVV> fields = getFields();
    var entries = fields.entries;

    for (var entry in entries) {
      var field = entry.value;
      var error = field.validator(field.controller.text);
      if (error != null) {
        errors[entry.key] = error;
      }
    }

    if (errors.isEmpty) {
      return true;
    }

    return false;
  }

  bool flutterValidate() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    return true;
  }

  // TODO - correct reset to bool types or others
  void reset() {
    Map<String, FieldVV> fields = getFields();
    var entries = fields.entries;

    for (var entry in entries) {
      var field = entry.value;
      field.controller.text = field.initial ?? '';
    }
  }

  void setValues(Map<String, String> values) {
    Map<String, FieldVV> fields = getFields();
    var entries = fields.entries;

    for (var entry in entries) {
      var field = entry.value;
      if (values.containsKey(entry.key) && values[entry.key] != null) {
        field.controller.text = values[entry.key]!;
      }
    }
  }

  String getValue(String key) {
    Map<String, FieldVV> fields = getFields();
    var entries = fields.entries;

    for (var entry in entries) {
      if (entry.key == key) {
        return entry.value.controller.text;
      }
    }

    throw ErrorVV("Field $key not found");
  }

  void clearErrors() {
    _errors = {};
  }
}
