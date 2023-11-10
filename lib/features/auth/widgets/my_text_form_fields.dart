import 'package:flutter/material.dart';

class MyTextFormFields extends StatefulWidget {
  const MyTextFormFields({
    super.key,
    required this.obscureText,
    required this.label,
    required this.controller,
    required this.validator,
  });

  final bool obscureText;
  final String label;
  final TextEditingController controller;
  final Function validator;

  @override
  State<MyTextFormFields> createState() => MyTextFormFieldsState();
}

class MyTextFormFieldsState extends State<MyTextFormFields> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myTheme = Theme.of(context);
    return SizedBox(
      width: size.width * 0.85,
      child: TextFormField(
        validator: (value) => widget.validator(value),
        controller: widget.controller,
        style: TextStyle(color: myTheme.colorScheme.onSurface),
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          filled: true,
          label: Text(widget.label),
          fillColor: myTheme.scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
