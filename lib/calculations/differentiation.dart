import 'package:electro_magnetism_solver/utils/helpers.dart/coefficient_handler.dart';
import 'package:flutter/material.dart';

class Differentiate {
  String differentiate(String equation) {
    CoefficientHandler coefficientHandler = CoefficientHandler();

    List<String> updatedEquation = [];
    List<String>? coefficientList = [];
    String pow = "";
    String base = "";
    String newPow = "";
    String derivative = "";
    String variable = "";
    String newCoefficient = "";
    bool trigoFunc = false;

    if (equation.contains("^")) {
      updatedEquation = powerRule(equation);

      base = updatedEquation[0];
      pow = updatedEquation[1];
      newPow = updatedEquation[2];

      debugPrint(base);
      debugPrint(pow);
      debugPrint(newPow);

      if (pow == "0") {
        return "0";
      }

      if (newPow == "0") {
        return "1";
      }

      if (newPow == "1") {
        newPow = "";
      }
    } else {
      base = equation;
    }

    coefficientList = coefficientHandler.extractCoefficient(base);
    if (coefficientList == null) {
      variable = base;
    } else {
      if (equation.contains("^")) {
        newCoefficient =
            (int.parse(pow) * int.parse(coefficientList[0])).toString();
      } else {
        newCoefficient = coefficientList[0];
      }
      variable = coefficientList[1];
    }

    debugPrint(newCoefficient);

    if (variable.contains("sin")) {
      derivative = sinRule();
      trigoFunc = true;
    } else if (variable.contains("cos")) {
      derivative = cosRule();
      derivative = "-$derivative";
      trigoFunc = true;
    } else if (base.contains("ln")) {
      derivative = lnRule();
    } else {
      derivative = variable;
    }

    if (newPow == "" && equation.contains("^")) {
      return '$newCoefficient$derivative';
    } else if (newPow == "" && !equation.contains("^") && !trigoFunc) {
      return newCoefficient;
    } else if (!equation.contains("^") && trigoFunc) {
      return '$newCoefficient$derivative';
    } else {
      return '$newCoefficient$derivative^$newPow';
    }
  }

  List<String> powerRule(String equation) {
    List<String> splitEquation = equation.split("^");
    splitEquation.removeWhere((element) => element == "^");
    String base = splitEquation[0];
    String power = splitEquation[1];
    String newPower = (int.parse(power) - 1).toString();
    return [base, power, newPower];
  }

  String cosRule() {
    return ("sin(x)");
  }

  String sinRule() {
    return ("cos(x)");
  }

  String lnRule() {
    return ("1/(x)");
  }
}
