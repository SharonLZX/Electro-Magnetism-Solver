import 'package:flutter/material.dart';

class ChkboxChainrule extends StatefulWidget {
  final ValueChanged<bool?> onChecked;
  final bool value;
  final TextEditingController
      textController; // Controller for the TextFormField
  final String labelText; // Label for the TextFormField

  const ChkboxChainrule({
    super.key,
    required this.onChecked,
    required this.value,
    required this.textController,
    this.labelText = 'Enter text',
  });

  @override
  State<ChkboxChainrule> createState() => _ChkboxChainruleState();
}

class _ChkboxChainruleState extends State<ChkboxChainrule> {
  late double _fieldWidth; // Field width variable

  @override
  void initState() {
    super.initState();
    _fieldWidth = 50.0; // Initialize the width
    widget.textController.addListener(() {
      setState(() {
        _fieldWidth = (widget.textController.text.length * 10)
            .clamp(50.0, MediaQuery.of(context).size.width) as double;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text('Use Substituition Rule'),
          Checkbox(
            value: widget.value,
            onChanged: widget.onChecked,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Visibility(
              visible: widget.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Let "),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _fieldWidth,
                    child: TextFormField(
                      controller: widget.textController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const Text(" be U")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
