import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetFactory {
  final Map<String, TextEditingController> controllers;

  // Constructor to initialize controllers
  WidgetFactory(this.controllers);

  // Function to create a number input form
  Widget numberForm(String label, String controllerKey) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controllers[controllerKey],
      keyboardType: TextInputType.number,
    );
  }

  // Function to create a default input form
  Widget defaultForm(String label, String controllerKey) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controllers[controllerKey],
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'^[a-zA-Z0-9()+\-*/\s^]*$|^[a-zA-Z]+\(.*\)$'),
        ),
      ],
    );
  }

  // Function to create a direction input form
  Widget directionForm(String label, String controllerKey) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controllers[controllerKey],
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^(a|ax|ay|az)$')),
      ],
    );
  }

  // Function for users to choose plane
  Widget planeForm(String label, String controllerKey) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controllers[controllerKey],
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^(x|y|z|xy|yx|xz|zx|yz|zy)$')),
      ],
    );
  }
}
