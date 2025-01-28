class ExponentHandler {
  List<String>? containsExp(equation) {
    List<String> splitEquation = [];
    String coeffVar = "";
    String exponent = "";

    if (equation.contains("^")) {
      // ERROR: cos(x^2) will also return TRUE
      splitEquation = equation.split("^");
      splitEquation.removeWhere((element) => element == "^");
      coeffVar = splitEquation[0];
      exponent = splitEquation[1];
      return [coeffVar, exponent];
    }
    return null;
  }
}