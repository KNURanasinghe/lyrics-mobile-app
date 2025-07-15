import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  const AuthButton({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 348,
          height: 55,
          decoration: ShapeDecoration(
            color: const Color(0xFFB71C1C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
