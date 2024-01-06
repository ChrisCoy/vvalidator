// TODO - move all generic method to a separate class wich will be extended by all other validators
import 'package:vvalidator/vvalidator.dart';

class StringVValidator {
  final _emailRegexp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final List<String? Function()> _rules = [];
  late String _invalidTypeMessage;
  late String _value;

  StringVValidator({String? invalidTypeMessage}) {
    _invalidTypeMessage = invalidTypeMessage ?? "Invalid type";
  }

  StringVValidator email({String? message, int? min = 0, int? max = -1}) {
    _rules.add(() {
      if (!_emailRegexp.hasMatch(_value)) {
        return message ?? "Invalid Email";
      }
      return null;
    });

    return this;
  }

  StringVValidator regExp(RegExp regExp, {String? message}) {
    _rules.add(() {
      if (!regExp.hasMatch(_value)) {
        return message ?? "Value does not match the pattern";
      }
      return null;
    });

    return this;
  }

  StringVValidator url({String? message}) {
    _rules.add(() {
      if (!Uri.parse(_value).isAbsolute) {
        return message ?? "Invalid URL";
      }

      return null;
    });

    return this;
  }

  StringVValidator dateString({String? message}) {
    _rules.add(() {
      try {
        DateTime.parse(_value);
      } catch (e) {
        return message ?? "Invalid date";
      }

      return null;
    });

    return this;
  }

  StringVValidator minLen(int min, {String? message}) {
    _rules.add(() {
      if (_value.length < min) {
        return message ?? "Has to be at least $min characters long";
      }
      return null;
    });

    return this;
  }

  StringVValidator maxLen(int max, {String? message}) {
    _rules.add(() {
      if (_value.length > max) {
        return message ?? "Has to be at most $max characters long";
      }
      return null;
    });

    return this;
  }

  StringVValidator onlyLetters({String? message}) {
    _rules.add(() {
      if (!RegExp(r"^[a-zA-Z]+$").hasMatch(_value)) {
        return message ?? "Can only contain letters";
      }
      return null;
    });

    return this;
  }

  StringVValidator onlyNumbers({String? message}) {
    _rules.add(() {
      if (!RegExp(r"^[0-9]+$").hasMatch(_value)) {
        return message ?? "Can only contain numbers";
      }
      return null;
    });

    return this;
  }

  StringVValidator onlyLettersAndNumbers({String? message}) {
    _rules.add(() {
      if (!RegExp(r"^[a-zA-Z0-9]+$").hasMatch(_value)) {
        return message ?? "Can only contain letters and numbers";
      }
      return null;
    });

    return this;
  }

  StringVValidator refine(String? Function(String) refineFunction) {
    _rules.add(() => refineFunction(_value));

    return this;
  }

  StringVValidator mustBeEqualTo(
      {FieldVV? field, String? value, String? message}) {
    if (field != null && value != null) {
      throw Exception("You can only pass field or value, not both");
    }

    if (field != null) {
      _rules.add(() {
        if (_value != field.value) {
          return "Doesn't match to ${field.value}";
        }
        return null;
      });
    } else if (value != null) {
      _rules.add(() {
        if (_value != value) {
          return "Doesn't match to $value";
        }
        return null;
      });
    }

    return this;
  }

  StringVValidator anyOf(List<String> values, {String? message}) {
    _rules.add(() {
      if (!values.contains(_value)) {
        return message ?? "Has to be one of $values";
      }
      return null;
    });

    return this;
  }

  String? Function(dynamic) require(
      {String? message, String Function(dynamic)? transform}) {
    return (val) {
      if (transform != null) {
        try {
          _value = transform(val);
        } catch (e) {
          return _invalidTypeMessage;
        }
      } else {
        if (val == null) return _invalidTypeMessage;
        if (val is! String) return _invalidTypeMessage;
        if (val.isEmpty) return message ?? "Cannot be empty";
        _value = val;
      }

      for (var i = _rules.length - 1; i >= 0; i--) {
        var error = _rules[i]();
        if (error != null) return error;
      }

      return null;
    };
  }

  String? Function(dynamic) optional(
      {String? message, String Function(dynamic)? transform}) {
    return (val) {
      if (transform != null) {
        try {
          _value = transform(val);
        } catch (e) {
          return _invalidTypeMessage;
        }
      } else {
        if (val == null) return null;
        if (val is! String) return _invalidTypeMessage;
        if (val.isEmpty) return null;
        _value = val;
      }

      for (var i = _rules.length - 1; i >= 0; i--) {
        var error = _rules[i]();
        if (error != null) return error;
      }

      return null;
    };
  }
}
