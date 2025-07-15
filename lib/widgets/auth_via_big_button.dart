import 'package:flutter/material.dart';

class AuthViaBigButton extends StatelessWidget {
  String path;
  String name;
  AuthViaBigButton({super.key, required this.path, required this.name});

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(path),
                const SizedBox(width: 30),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
