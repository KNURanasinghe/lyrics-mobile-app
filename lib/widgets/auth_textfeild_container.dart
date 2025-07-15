import 'package:flutter/material.dart';

class AuthTextfeildContainer extends StatelessWidget {
  IconData icon; // Default icon
  String hintText; // Default hint text
  AuthTextfeildContainer({
    super.key,
    required this.icon,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: 0.50,
          child: Container(
            width: 348,
            height: 62,
            decoration: ShapeDecoration(
              color: const Color(0xFFD9D9D9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(icon),
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
