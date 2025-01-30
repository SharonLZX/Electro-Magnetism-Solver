import 'package:flutter/material.dart';

class LegendBuilder {
  Widget axisBuilder() {
    return Text("Axis Legend",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget axisLegend(int axis) {
    List<Color> colorLst = [
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 0, 255, 0),
      Color.fromARGB(255, 0, 0, 255),
    ];

    List<String> axisStr = ['X', 'Y', 'Z'];

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 20,
            height: 20,
            color: colorLst[axis], // X axis color
          ),
        ),
        Text("${axisStr[axis]} axis", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
