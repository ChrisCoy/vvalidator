library vvalidator;

import 'src/validators/bool_vvalidator.dart';
import 'src/validators/number_vvalidator.dart';
import 'src/validators/string_vvalidator.dart';

export 'src/flutter/errors_vv.dart';
export 'src/flutter/field_vv.dart';
export 'src/flutter/schema_vv.dart';
export 'src/validators/bool_vvalidator.dart';
export 'src/validators/number_vvalidator.dart';
export 'src/validators/string_vvalidator.dart';

/* 
  ideas: pass a flag to optional to make it required, this is useful 
    for create a method that validate all fields even if they are optional
 */
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
