import 'package:electro_magnetism_solver/utils/handlers/differentiation/differentiation.dart';
import 'package:flutter/material.dart';

// apply the product rule to expressions that contain brackets

class StrategyTwo {
  String? strategyTwo(String indvFunc) {
    RegExp regex = RegExp(r'^([^()]+)?\(([^()]+)\)$');
    var match = regex.firstMatch(indvFunc);
    if (match != null) {
      String outside = match.group(1) ?? "";
      String inside = match.group(2)!;

      Differentiation differentiation = Differentiation();
      String outsideDiff = differentiation.differentiate(outside).join('+');
      String insideDiff = differentiation.differentiate(inside).join('+');
      debugPrint(outside);
      debugPrint(inside);
      debugPrint(outsideDiff);
      debugPrint(insideDiff);
      return "$outside$insideDiff + $inside$outsideDiff";
    }
    return null;
  }
}
