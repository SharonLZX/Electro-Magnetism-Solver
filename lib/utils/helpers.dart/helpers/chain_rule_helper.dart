class ChainRuleHandler {
  dynamic extractSub(String variable) {
    final RegExp regExp = RegExp(r'\((.*?)\)');
    Match? match = regExp.firstMatch(variable);
    if (match != null) {
      String? content = match.group(1);
      if (content != null) {
        if (content.length == 1) {
          return false; //Length only 1, sin(x)
        }
        //Length more than 1, sin(x^2)
        //And we return the variable with it's (x^2) to just x to become
        //sin(x)
        var newVariable = variable.replaceFirst(match.group(1).toString(), 'x');
        return [match.group(1), newVariable];
      }
      return null; //Equation with brackets e.g. 5x or 5x^2
    }
  }
}