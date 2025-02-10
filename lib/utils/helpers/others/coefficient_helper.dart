class CoefficientHandler {
  List<String>? extractCoefficient(String expression) {
    String coefficient = "";
    String variable = "";

    final regex = RegExp(r'([-+]?\d+)\s*([a-zA-Z]+\(x\)|x)');
    final match = regex.firstMatch(expression);

    //Check if contain coefficients by splitting the expression
    //into the coefficient and variable by using regex that splits
    //the expression into two groups, first group is the coefficient
    //before a alphabet and second group is after the alphabet.
    if (match != null) {
      coefficient = match.group(1) ?? '';
      variable = match.group(2) ?? '';
      return [coefficient, variable];
    } else {
      return null;
    }
  }
}