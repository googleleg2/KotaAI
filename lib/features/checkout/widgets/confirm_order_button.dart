import 'package:flutter/material.dart';

class ConfirmOrderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ConfirmOrderButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text(
          "CONFIRM ORDER",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}