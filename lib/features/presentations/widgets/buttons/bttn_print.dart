import 'package:flutter/material.dart';

class PrintButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PrintButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          color: const Color.fromARGB(255, 207, 207, 207),
          child: SizedBox(
            width: (screenWidth-100) / 4, 
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.print),
                SizedBox(width: 8), 
                Text("Display")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
