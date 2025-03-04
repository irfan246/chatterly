import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const ButtonCustom({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40),
        fixedSize: Size(280, 50),
        backgroundColor: const Color.fromARGB(255, 29, 29, 29),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
