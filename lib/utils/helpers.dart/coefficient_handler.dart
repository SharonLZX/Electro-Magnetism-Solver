import 'package:electro_magnetism_solver/core/constants/constants.dart';

class CoefficientHandler {
  List<String>? extractCoefficient(String expression) {

    String coefficient = "";
    String variable = "";

    final regex = coefficientRegEx;
    final match = regex.firstMatch(expression);
    if (match != null) {
      coefficient = match.group(1) ?? '';
      variable = match.group(2) ?? '';
      return [coefficient, variable];
    } else{
      return null;
    }
  }
}
