class PowerRule {
  String? powerRule(String? function) {
    /*
    Perform power rule on function.
    */
    RegExp regex = RegExp(r'^(-?\d*\.?\d*)t\^(-?\d+)');
    if (function != null) {
      var match = regex.firstMatch(function);
      if (match != null) {
        int coefficient = int.parse(match.group(1)!);
        int exponent = int.parse(match.group(2)!);
        int newExpo = (exponent) - 1;
        int newCoef = coefficient * exponent;

        return "{$newCoef}t^$newExpo";
      }
      return null;
    }
    return null;
  }
}
