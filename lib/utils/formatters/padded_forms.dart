import 'package:flutter/material.dart';

Widget paddedForm(Widget Function(int, String, String) formFactory, int id, String hint, String label) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: formFactory(id, hint, label),
  );
}