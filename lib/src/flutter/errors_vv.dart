import 'package:flutter/widgets.dart';

// TODO - create betters errorsx, iex: ErrorVV, ErrorVValidator, ErrorSchemaVV
class ErrorVV extends Error {
  String? reason;
  final String? field;
  final TextEditingController? fieldController;
  final FocusNode? fieldFocus;
  ErrorVV(this.reason, {this.field, this.fieldController, this.fieldFocus});
}
