library vvalidator;

import 'src/validators/bool_vvalidator.dart';
import 'src/validators/number_vvalidator.dart';
import 'src/validators/string_vvalidator.dart';

// ideas: put a transform function to transform the value before validate,
// this function will be passed in the required or optional function

class V {
  static StringVValidator string({String? invalidTypeMessage}) {
    return StringVValidator(invalidTypeMessage: invalidTypeMessage);
  }

  static NumberVValidator number({String? invalidTypeMessage}) {
    return NumberVValidator(invalidTypeMessage: invalidTypeMessage);
  }

  static BoolVValidator bool({String? invalidTypeMessage}) {
    return BoolVValidator(invalidTypeMessage: invalidTypeMessage);
  }
}

class Qualquercoisa {
  Qualquercoisa() {}
}
