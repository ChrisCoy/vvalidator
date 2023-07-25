import 'package:flutter/widgets.dart';

class FieldVV {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String? Function(dynamic) validator;
  String? initialValue;

  TextEditingController get controller => _controller;
  FocusNode get focusNode => _focusNode;

  String? get value => _controller.text;

  FieldVV(
      {required this.validator,
      TextEditingController? controller,
      FocusNode? focusNode})
      : _controller = controller ?? TextEditingController(),
        _focusNode = focusNode ?? FocusNode();

  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
  }

  void focus() {
    _focusNode.requestFocus();
  }

  void unfocus() {
    _focusNode.unfocus();
  }
}
