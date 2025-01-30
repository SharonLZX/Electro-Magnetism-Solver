import 'package:flutter/material.dart';

class ZoomBuilder extends StatefulWidget {
  final double zoomLevel;
  final ValueChanged<double> onChanged;

  const ZoomBuilder(
      {super.key, required this.zoomLevel, required this.onChanged});

  @override
  State<ZoomBuilder> createState() => _ZoomBuilderState();
}

class _ZoomBuilderState extends State<ZoomBuilder> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Zoom Level: ${widget.zoomLevel.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white)),
        Slider(
          value: widget.zoomLevel * -1,
          min: -2.5, // Minimum zoom level (zoom out)
          max: -0.5, // Maximum zoom level (zoom in)
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
