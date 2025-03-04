import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  const TextFieldCustom(
      {super.key,
      required this.text,
      required this.icon,
      required this.obscureText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          fillColor: const Color.fromARGB(255, 221, 221, 221),
          filled: true,
          prefixIcon: Icon(icon),
          hintText: text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
