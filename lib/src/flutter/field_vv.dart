import 'package:flutter/widgets.dart';

class FieldVV {
  TextEditingController controller = TextEditingController();
  String? Function(dynamic) validator;
  String? initialValue;

  FieldVV({required this.controller, required this.validator}) {
    controller.text = initialValue ?? '';
  }
}
