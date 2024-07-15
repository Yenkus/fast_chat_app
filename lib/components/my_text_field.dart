import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final bool? obscureText;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  const MyTextField(
      {super.key,
      required this.textEditingController,
      this.obscureText = false,
      required this.hintText,
      this.focusNode,
      this.textCapitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      controller: textEditingController,
      obscureText: obscureText!,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
