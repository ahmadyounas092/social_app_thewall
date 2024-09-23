import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  String hintText;
  bool obsecureText;

  MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obsecureText,});

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obsecureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary)
        ),
        fillColor: Theme.of(context).colorScheme.primary,
        filled: true,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}
