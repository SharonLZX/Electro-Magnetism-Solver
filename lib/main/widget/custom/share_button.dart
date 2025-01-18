import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ShareButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 213, 198, 129),
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      onPressed: onPressed,
      child: const Text('S H A R E'),
    );
  }
}
