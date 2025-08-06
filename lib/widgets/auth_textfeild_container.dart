import 'package:flutter/material.dart';

class AuthTextfeildContainer extends StatefulWidget {
  final TextEditingController? controller;
  final IconData icon;
  final String hintText;
  final bool isPassword;

  const AuthTextfeildContainer({
    super.key,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<AuthTextfeildContainer> createState() => _AuthTextfeildContainerState();
}

class _AuthTextfeildContainerState extends State<AuthTextfeildContainer> {
  bool _obscureText = true;

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
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(widget.icon),
                suffixIcon:
                    widget.isPassword
                        ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                        : null,
                hintText: widget.hintText,
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
