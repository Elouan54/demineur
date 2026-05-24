import 'package:flutter/material.dart';

class XPButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const XPButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE4E4E4),
          border: Border.all(color: Colors.black),
          boxShadow: const [
            BoxShadow(color: Colors.white, offset: Offset(-2, -2)),
            BoxShadow(color: Colors.grey, offset: Offset(2, 2)),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
