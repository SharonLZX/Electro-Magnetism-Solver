import 'package:flutter/material.dart';

class SolveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SolveButton({super.key, required this.onPressed});

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
                Icon(Icons.calculate_sharp),
                SizedBox(width: 8),
                Text("Solve")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
