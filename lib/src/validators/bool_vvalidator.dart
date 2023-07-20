class BoolVValidator {
  final _emailRegexp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final List<String? Function()> _rules = [];
  late String _invalidTypeMessage;
  late bool _value;

  BoolVValidator({String? invalidTypeMessage}) {
    _invalidTypeMessage = invalidTypeMessage ?? "Invalid type";
  }

  BoolVValidator isTrue({String? message}) {
    _rules.add(() {
      if (!_value) {
        return message ?? "Value must be true";
      }
      return null;
    });

    return this;
  }

  BoolVValidator isFalse({String? message}) {
    _rules.add(() {
      if (_value) {
        return message ?? "Value must be false";
      }
      return null;
    });

    return this;
  }

  BoolVValidator refine(bool Function(bool) refineFunction) {
    _rules.add(() {
      _value = refineFunction(_value);
      return null;
    });

    return this;
  }

  String? Function(bool?) require({String? message}) {
    return (val) {
      if (val == null) return message ?? "Value must be a boolean";
      _value = val;
      for (var i = _rules.length - 1; i > 0; i--) {
        var error = _rules[i]();
        if (error != null) return error;
      }
      return null;
    };
  }

  String? Function(bool?) optional(
      {String? message, String Function(String?)? transform}) {
    return (val) {
      if (val == null) return null;
      _value = val;
      for (var i = _rules.length - 1; i > 0; i--) {
        var error = _rules[i]();
        if (error != null) return error;
      }
      return null;
    };
  }
}
