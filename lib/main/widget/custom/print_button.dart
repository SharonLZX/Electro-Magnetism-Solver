import 'package:flutter/material.dart';

class PrintButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PrintButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 213, 198, 129),
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      onPressed: onPressed,
      child: const Text('P R I N T'),
    );
  }
}
