import 'package:vvalidator/src/flutter/field_vv.dart';

import 'errors_vv.dart';

class SchemaVV {
  late Map<String, FieldVV> fields;
  late Map<String, String> errors = {};
  late Map<String, String? Function(Map<String, FieldVV>)> _rules = {};

  FieldVV? get(key) => fields[key];

  // TODO - implement copyWith
  SchemaVV(this.fields);

  void addField(String key, FieldVV field) {
    fields[key] = field;
  }

  // TODO - add type
  refine(
      {required String field,
      required String? Function(Map<String, FieldVV>) rule}) {
    _rules[field] = rule;

    return this;
  }

  void removeField(String key) {
    fields.remove(key);
  }

  bool _validate() {
    errors = {};
    for (String key in fields.keys) {
      var field = fields[key]!;
      var error = field.validator(field.controller.text);
      if (error != null) {
        errors[key] = error;
      }
    }

    for (String key in _rules.keys) {
      var rule = _rules[key]!;
      var error = rule(fields);
      if (error != null) {
        errors[key] = error;
      }
    }

    if (errors.isEmpty) return true;

    fields[errors.keys.elementAt(0)]?.focus();

    return false;
  }

  void throwIfInvalid() {
    errors = {};
    for (String key in fields.keys) {
      var field = fields[key]!;
      var error = field.validator(field.controller.text);
      if (error != null) {
        throw ErrorVV(error, field: key, fieldController: field.controller);
      }
    }

    for (String key in _rules.keys) {
      var rule = _rules[key]!;
      var error = rule(fields);
      if (error != null) {
        throw ErrorVV(error,
            field: key, fieldController: fields[key]?.controller);
      }
    }
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
