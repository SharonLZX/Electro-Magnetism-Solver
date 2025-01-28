class CoefficientHandler {
  List<String>? extractCoefficient(String expression) {
    String coefficient = "";
    String variable = "";

    final regex = RegExp(r'([-+]?\d+)\s*([a-zA-Z]+\(x\)|x)');
    final match = regex.firstMatch(expression);

    if (match != null) {
      coefficient = match.group(1) ?? '';
      variable = match.group(2) ?? '';
      return [coefficient, variable];
    } else {
      return null;
    }
  }
}