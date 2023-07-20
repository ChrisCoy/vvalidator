import 'package:vvalidator/src/flutter/field_vv.dart';

class SchemaVV {
  Map<String, FieldVV> fields = {};
  Map<String, String> errors = {};

  bool validate() {
    errors = {};
    for (String key in fields.keys) {
      var field = fields[key]!;
      var error = field.validator(field.controller.text);
      if (error != null) {
        errors[key] = error;
      }
    }
    return errors.isEmpty;
  }

  void clear() {
    errors = {};
    for (String key in fields.keys) {
      var field = fields[key]!;
      field.controller.clear();
    }
  }

  void reset() {
    errors = {};
    for (String key in fields.keys) {
      var field = fields[key]!;
      field.controller.text = field.initialValue ?? '';
    }
  }

  void setValues(Map<String, dynamic> values) {
    for (String key in fields.keys) {
      var field = fields[key]!;
      if (values.containsKey(key)) {
        field.controller.text = values[key];
      }
    }
  }
}
