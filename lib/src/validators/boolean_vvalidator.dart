class BooleanVValidator {
  final List<String? Function()> _rules = [];
  late String _invalidTypeMessage;
  late bool _value;

  BooleanVValidator({String? invalidTypeMessage}) {
    _invalidTypeMessage = invalidTypeMessage ?? "Invalid type";
  }

  BooleanVValidator isTrue({String? message}) {
    _rules.add(() {
      if (!_value) {
        return message ?? "Value must be true";
      }
      return null;
    });

    return this;
  }

  BooleanVValidator isFalse({String? message}) {
    _rules.add(() {
      if (_value) {
        return message ?? "Value must be false";
      }
      return null;
    });

    return this;
  }

  BooleanVValidator refine(String? Function(bool) refineFunction) {
    _rules.add(() => refineFunction(_value));

    return this;
  }

  String? Function(dynamic) require({String? message}) {
    return (val) {
      if (val == null) return message ?? "Value must be a boolean";
      _value = val;
      for (var i = _rules.length - 1; i >= 0; i--) {
        var error = _rules[i]();
        if (error != null) return error;
      }
      return null;
    };
  }

  String? Function(dynamic) optional(
      {String? message, String Function(String?)? transform}) {
    return (val) {
      if (val == null) return null;
      _value = val;
      for (var i = _rules.length - 1; i >= 0; i--) {
        var error = _rules[i]();
        if (error != null) return error;
      }
      return null;
    };
  }
}
