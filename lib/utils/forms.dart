import 'package:flutter/material.dart';
import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/custom_textformfield.dart';

class WidgetFactory {
  final Map<String, TextEditingController> controllers;
  WidgetFactory(this.controllers);

  Widget customForm(int id, String hintText, String controllerKey){
    return CustomTFF(
      label: hintText,
      controllers: controllers,
      controllerKey: controllerKey,
      regexp: regexList[id]
    );
  }
}




