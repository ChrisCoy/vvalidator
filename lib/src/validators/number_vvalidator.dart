class NumberVValidator {
  final List<String? Function()> _rules = [];
  late String _invalidTypeMessage;
  late num _value;

  NumberVValidator({String? invalidTypeMessage}) {
    _invalidTypeMessage = invalidTypeMessage ?? "Invalid type";
  }

  NumberVValidator min(int min, {String? message}) {
    _rules.add(() {
      if (_value < min) {
        return message ?? "Minimum value is $min";
      }
      return null;
    });

    return this;
  }

  NumberVValidator max(int max, {String? message}) {
    _rules.add(() {
      if (_value > max) {
        return message ?? "Maximum value is $max";
      }
      return null;
    });

    return this;
  }

  NumberVValidator positive({String? message}) {
    _rules.add(() {
      if (_value < 0) {
        return message ?? "Has to be positive";
      }
      return null;
    });

    return this;
  }

  NumberVValidator negative({String? message}) {
    _rules.add(() {
      if (_value > 0) {
        return message ?? "Has to be negative";
      }
      return null;
    });

    return this;
  }

  NumberVValidator integer({String? message}) {
    _rules.add(() {
      if (_value % 1 != 0) {
        return message ?? "Has to be an integer";
      }
      return null;
    });

    return this;
  }

  NumberVValidator even({String? message}) {
    _rules.add(() {
      if (_value % 2 != 0) {
        return message ?? "Has to be even";
      }
      return null;
    });

    return this;
  }

  NumberVValidator odd({String? message}) {
    _rules.add(() {
      if (_value % 2 == 0) {
        return message ?? "Has to be odd";
      }
      return null;
    });

    return this;
  }

  NumberVValidator refine(String? Function(num) refineFunction) {
    _rules.add(() => refineFunction(_value));

    return this;
  }

  String? Function(dynamic) require(
      {String? message, num Function(dynamic)? transform}) {
    _rules.add(() {
      return null;
    });

    return (val) {
      if (transform != null) {
        try {
          _value = transform(val);
        } catch (e) {
          return _invalidTypeMessage;
        }
      } else {
        if (val == null) return message ?? "Value must be a number";
        if (val is! num) return _invalidTypeMessage;
        if (val.isNaN) return message ?? "Value must be a number";

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
      {String? message, num Function(dynamic)? transform}) {
    return (val) {
      if (transform != null) {
        try {
          _value = transform(val);
        } catch (e) {
          return _invalidTypeMessage;
        }
      } else {
        if (val == null) return null;
        if (val is! num) return _invalidTypeMessage;
        if (val.isNaN) return message ?? "Value must be a number";
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
