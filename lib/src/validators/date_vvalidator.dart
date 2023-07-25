class DateVValidator {
  final List<String? Function()> _rules = [];
  late String _invalidTypeMessage;
  late DateTime _value;

  DateVValidator({String? invalidTypeMessage}) {
    _invalidTypeMessage = invalidTypeMessage ?? "Invalid type";
  }

  DateVValidator before(DateTime date, {String? message}) {
    _rules.add(() {
      if (!_value.isBefore(date)) {
        return message ?? "Date must be before ${date.toIso8601String()}";
      }
      return null;
    });

    return this;
  }

  DateVValidator after(DateTime date, {String? message}) {
    _rules.add(() {
      if (!_value.isAfter(date)) {
        return message ?? "Date must be after ${date.toIso8601String()}";
      }
      return null;
    });

    return this;
  }

  DateVValidator between(DateTime min, DateTime max, {String? message}) {
    _rules.add(() {
      if (!_value.isAfter(min) || !_value.isBefore(max)) {
        return message ??
            "Date must be between ${min.toIso8601String()} and ${max.toIso8601String()}";
      }
      return null;
    });

    return this;
  }

  DateVValidator notBetween(DateTime min, DateTime max, {String? message}) {
    _rules.add(() {
      if (_value.isAfter(min) && _value.isBefore(max)) {
        return message ??
            "Date must not be between ${min.toIso8601String()} and ${max.toIso8601String()}";
      }
      return null;
    });

    return this;
  }

  DateVValidator equal(DateTime date, {String? message}) {
    _rules.add(() {
      if (!_value.isAtSameMomentAs(date)) {
        return message ?? "Date must be equal to ${date.toIso8601String()}";
      }
      return null;
    });

    return this;
  }

  DateVValidator notEqual(DateTime date, {String? message}) {
    _rules.add(() {
      if (_value.isAtSameMomentAs(date)) {
        return message ?? "Date must not be equal to ${date.toIso8601String()}";
      }
      return null;
    });

    return this;
  }

  DateVValidator today({String? message}) {
    _rules.add(() {
      DateTime now = DateTime.now();
      if (!(_value.year == now.year &&
          _value.month == now.month &&
          _value.day == now.day)) {
        return message ?? "Date must be today";
      }
      return null;
    });

    return this;
  }

  DateVValidator refine(String? Function(DateTime) refineFunction) {
    _rules.add(() => refineFunction(_value));

    return this;
  }

  String? Function(dynamic) require(
      {String? message, DateTime Function(dynamic)? transform}) {
    return (val) {
      if (transform != null) {
        try {
          _value = transform(val);
        } catch (e) {
          return _invalidTypeMessage;
        }
      } else {
        if (val == null) return _invalidTypeMessage;
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
      {String? message, DateTime Function(dynamic)? transform}) {
    return (val) {
      if (transform != null) {
        try {
          _value = transform(val);
        } catch (e) {
          return _invalidTypeMessage;
        }
      } else {
        if (val == null) return null;
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
