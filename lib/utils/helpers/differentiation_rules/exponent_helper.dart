class ExponentHandler {
  List<String>? containsExp(equation) {
    List<String> splitEquation = [];
    String coeffVar = "";
    String exponent = "";

    if (equation.contains("^")) {

      //Example: equation = 5sin(x)^2
      //splitEquation: [5sin(x), ^, 2]
      //splitEquation: [5sin(x), 2]

      //coeffVar: short form for coefficient and variable
      //exponent: short form for exponent
      splitEquation = equation.split("^");
      splitEquation.removeWhere((element) => element == "^");
      coeffVar = splitEquation[0];
      exponent = splitEquation[1];
      return [coeffVar, exponent];
    }
    return null;
  }
}