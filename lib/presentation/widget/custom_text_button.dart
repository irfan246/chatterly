import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onTap;
  const CustomTextButton(
      {super.key,
      required this.text,
      required this.buttonText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            color: const Color.fromARGB(255, 47, 47, 47),
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: const Color.fromARGB(255, 29, 29, 29),
            ),
          ),
        ),
      ],
    );
  }
}
