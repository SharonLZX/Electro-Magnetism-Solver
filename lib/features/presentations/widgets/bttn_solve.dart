import 'package:flutter/material.dart';

class SolveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SolveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 174, 213, 129),
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      onPressed: onPressed,
      child: const Text('S O L V E'),
    );
  }
}
