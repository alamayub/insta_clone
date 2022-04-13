import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hint;
  final TextInputType textInputType;

  const TextInputField({
    Key? key,
    required this.textEditingController,
    this.isPass = false,
    required this.hint,
    required this.textInputType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hint,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16)
      ),
      keyboardType: textInputType,
      obscureText: isPass,
    );
  }
}
