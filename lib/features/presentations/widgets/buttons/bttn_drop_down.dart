import 'package:flutter/material.dart';
import 'package:electro_magnetism_solver/core/constants/constants.dart';

class CustomDropDown extends StatefulWidget {
  final String selectedFormula;
  final ValueChanged<String?> onChanged;

  const CustomDropDown(
      {super.key, 
      required this.onChanged, 
      required this.selectedFormula});
      
  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedFormula,
      onChanged: widget.onChanged,
      items: formulaList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
