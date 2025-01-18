import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTFF extends StatelessWidget {
  final String label;
  final String controllerKey;
  final RegExp regexp;
  final Map<String, TextEditingController> controllers;

  const CustomTFF({
    super.key,
    required this.label,
    required this.controllers,
    required this.controllerKey,
    required this.regexp,
  });
  
  @override
  Widget build(BuildContext context) {

    return TextFormField(
      decoration:  InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: Colors.grey),
    border: const OutlineInputBorder(
      borderSide: BorderSide(width: 1.0),
      borderRadius: BorderRadius.zero
    ),
  ),
      style: const TextStyle(color: Colors.black),
      controller: controllers[controllerKey],
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(regexp)
      ],
    );
  }
}


