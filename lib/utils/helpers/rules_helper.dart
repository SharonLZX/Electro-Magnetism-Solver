class DiffRulesHandler {
  List<int> powerRule(String exponent) {
    int expo = int.parse(exponent);
    return [expo, expo - 1];
  }

  String cosRule() {
    return ("-sin(x)");
  }

  String sinRule() {
    return ("cos(x)");
  }

  String lnRule() {
    return ("1/(x)");
  }
}