class Expansion {
  String? expansion(List<String?> lstMultiplierArgument) {
    /*
    Multiply the coefficients, and add the exponents.
    */
    List<String> lstCoeffExponMultArg = [];
    RegExp regExp = RegExp(r'^(-?\d*)(t\^)(-?\d+)$');
    for (var func in lstMultiplierArgument) {
      if (func == null) {
        throw ArgumentError('Argument cannot be null');
      }
      Match? match = regExp.firstMatch(func);
      if (match != null) {
        /*
        Example: [5t^0, 1t^1] will show, [5, 0, 1, 1]
        */
        var matched = match.group(1);
        if (matched != null) {
          lstCoeffExponMultArg.add(matched);
        }

        matched = match.group(3);
        if (matched != null) {
          lstCoeffExponMultArg.add(matched);
        }
      }
    }

    /*
    Simply algebra here 
    (5t^0) * (1t^1) = (5*1)t^(0+1)
    */
    
    int coeffMultiplier = int.parse(lstCoeffExponMultArg[0]);
    int exponMultiplier = int.parse(lstCoeffExponMultArg[1]);
    int coeffArgument = int.parse(lstCoeffExponMultArg[2]);
    int exponArgument = int.parse(lstCoeffExponMultArg[3]);

    return ("${coeffMultiplier * coeffArgument}t^${exponMultiplier + exponArgument}");
  }
}
