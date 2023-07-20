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

  StringVValidator numberString({String? message}) {
    _rules.add(() {
      if (!RegExp(r"^[0-9]+$").hasMatch(_value)) {
        return message ?? "Campo inválido";
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

  StringVValidator refine(String Function(String) refineFunction) {
    _rules.add(() {
      _value = refineFunction(_value);
      return null;
    });

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

  String? Function(String?) require(
      {String? message, String Function(String?)? transform}) {
    _rules.add(() {
      if (_value.isEmpty) {
        return message ?? "Cannot be empty";
      }
      return null;
    });

    return (val) {
      if (val is! String) return _invalidTypeMessage;

      if (transform != null) {
        _value = transform(val);
      } else {
        _value = val;
      }

      for (var i = _rules.length - 1; i > 0; i--) {
        var error = _rules[i]();
        if (error != null) return error;
      }

      return null;
    };
  }

  String? Function(String?) optional(
      {String? message, String Function(String?)? transform}) {
    return (val) {
      if (val is String && val.isEmpty) return null;

      if (val is! String) return _invalidTypeMessage;

      if (transform != null) {
        _value = transform(val);
      } else {
        _value = val;
      }

      for (var i = _rules.length - 1; i > 0; i--) {
        var error = _rules[i]();
        if (error != null) return error;
      }

      return null;
    };
  }
}
