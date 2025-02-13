class DiffHandler {
  // DiffHandler handles whether the equation falls under either the
  // product rule or quotient rule.
  List<String> arithOper1 = ["/", "*"];
  Simplification simplifyHandler = Simplification();

  dynamic diffHandler(String chgFlux) {
    bool arithCheck = arithOper1.any((arith) => chgFlux.contains(arith));
    if (!arithCheck) {
      var result = diffHandler2(chgFlux);
      return simplifyHandler.simplifyEnd(result);
    }
    var result = quotProdRule(chgFlux);
    return simplifyHandler.simplifyEnd(result);
  }

  String quotProdRule(String chgFlux) {
    List<String> pairs = [];
    List<String> finalResult = [];
    List<String> splitEquation = [];

    if (chgFlux.contains(arithOper1[0])) {
      splitEquation = chgFlux.split('/');
      splitEquation.removeWhere((element) => element == '/');
    } else {
      splitEquation = chgFlux.split('*');
      splitEquation.removeWhere((element) => element == '*');
    }

    finalResult.add(splitEquation[1]);
    finalResult.add(diffHandler2(splitEquation[0]));
    finalResult.add(splitEquation[0]);
    finalResult.add(diffHandler2(splitEquation[1]));

    for (int i = 0; i < finalResult.length; i += 2) {
      pairs.add("${finalResult[i]}*${finalResult[i + 1]}");
    }

    if (chgFlux.contains('/')) {
      return ("[${pairs.join('-')}]/${splitEquation[1]}^2");
    }
    return (pairs.join('+'));
  }

  dynamic diffHandler2(String equation) {
    // DiffHandler2 handles whether the equation contains either
    // + or - .

    List<String?> result = [];
    List<String> splitEquation = [];
    List<String> arithOper2 = ["-", "+"];

    Differentiate differentiate = Differentiate();
    Simplification simplifyHandler = Simplification();

    bool arithCheck = arithOper2.any((arith) => equation.contains(arith));
    if (!arithCheck) {
      String? res = differentiate.differentiate(equation);
      return simplifyHandler.simplify(res);
    }

    if (equation.contains("-")) {
      splitEquation = equation.split('-');
      splitEquation.removeWhere((element) => element == '-');
    } else {
      splitEquation = equation.split('+');
      splitEquation.removeWhere((element) => element == '+');
    }

    for (var func in splitEquation) {
      String? res = differentiate.differentiate(func);
      result.add(simplifyHandler.simplify(res));
    }

    if (equation.contains("-")) {
      return result.join('-');
    } else {
      return result.join('+');
    }
  }
}

class Differentiate {
  String? differentiate(String equation) {
    CoefficientHandler coefficientHandler = CoefficientHandler();
    ExponentHandler exponentHandler = ExponentHandler();
    DiffRulesHandler diffRulesHandler = DiffRulesHandler();
    SubstituitionHandler subHandler = SubstituitionHandler();

    //Identify coefficient, variable and/or exponent
    //Based on what's available, return the proper format
    String coefficient = "";
    String variable = "";
    String exponent = "";
    String der_expo = ""; //'exponent' minus 1

    String coeffVar = ""; //Contains the coeff and var
    bool containCoeff = false; //Assume all equations !contain exponents
    bool containExpo = false;
    bool containTrigo = false;
    bool requireSubst = false;

    String? dervSub = ""; //Contains the derivative AFTER substituition
    String result = ""; //Contains result to send back to handler2
    
    String finalCoeff = "";
    var deriveThis; //We need this to rebuild the function later on
    var newVariable; //This will contain the newVariable, e.g. sin(5x) will be sin(x)
    List<String>? coeffVarList = [];

    //Check if require substituition
    var subStatus = subHandler.extractSub(equation);
    if (subStatus != null && subStatus != false) {
      deriveThis = subStatus[0];
      newVariable = subStatus[1];
      dervSub = differentiate(deriveThis);
      requireSubst = true;
    }

    if (requireSubst) {
      var newEquation = equation.replaceFirst(deriveThis, 'x');
      equation = newEquation;
      coeffVarList = exponentHandler.containsExp(newEquation);
      } else {
      //Check if contains exponent
      coeffVarList = exponentHandler.containsExp(equation);
    }

    if (coeffVarList != null) {
      containExpo = true;
      coeffVar = coeffVarList[0];
      exponent = coeffVarList[1];
      coeffVarList =
          coefficientHandler.extractCoefficient(coeffVar); //Reuse the list
    } else {
      //Pass equation rather than coeffVar here, since
      //'equation' will contain only the coefficient &
      //variable.
      coeffVarList = coefficientHandler.extractCoefficient(equation);
    }

    //Check if contain coefficient
    if (coeffVarList != null) {
      containCoeff = true;
      coefficient = coeffVarList[0];
      if (requireSubst == true) {
        variable = newVariable;
      } else {
        variable = coeffVarList[1];
      }
    } else if (containExpo) {
      //No coefficient with exponent (e.g. x^2)
      variable = coeffVar;
    } else {
      if (requireSubst == true) {
        variable = newVariable;
      } else {
        //No coefficient, no exponent (e.g. cos(x), x)
        //No substituition required too
        variable = equation;
      }
    }

    if (containExpo) {
      List<int> expoLst = diffRulesHandler.powerRule(exponent);
      exponent = expoLst[0].toString();
      der_expo = expoLst[1].toString();
    }

    if (variable.contains('sin')) {
      containTrigo = true;
      variable = diffRulesHandler.sinRule(); //Simply overwrite the variable.
    }

    if (variable.contains('cos')) {
      containTrigo = true;
      variable = diffRulesHandler.cosRule();
    }

    if (variable.contains('ln')) {
      variable = diffRulesHandler.lnRule();
    }

    IsNumeric isNum = IsNumeric();
    ReplaceX replaceX = ReplaceX();

    if (isNum.isNum(variable)) {
      //Q-type: d/dx 5
      return "0";
    }

    if (requireSubst == true) {
      variable = replaceX.replaceX(variable, deriveThis);
    }

    if (containCoeff == false && containExpo == false) {
      coefficient = "1";
      if (containTrigo) {
        if (requireSubst == true) {
          return "$dervSub$variable";
        }

        //Q-type: d/dx sin(x)
        return "$variable";
      }
      return "1/x";
    }

    if (containCoeff == true && containExpo == false) {
      if (containTrigo) {
        if (requireSubst == true) {
          //Since there is a coefficient, we need to make
          //sure that the $dervSub multiplys with $coefficient
          if (dervSub != null) {
            //We assume the dervSub will always be <number> followed
            //by a 'x' so we removeLast() to remove the x, to get the
            //<numbers> to get the new multiplied number.

            var dervSubLst = dervSub.split('');
            for (var item in dervSubLst){
              if (item == 'x'){
                break;
              }
              finalCoeff = finalCoeff + item.toString();
            }
            var newEquation = int.parse(coefficient) * int.parse(finalCoeff);

            String dervSub_str = dervSubLst[0];
            if (dervSub_str.contains('x')) {
              return "$newEquation$variable";
            }
            return "${newEquation}x$variable";
          }
        }
        //Q-type: d/dx 5sin(x)
        return "$coefficient$variable";
      }
      //Q-type: d/dx 5x
      return "$coefficient";
    }

    if (containCoeff == false && containExpo == true) {
      if (der_expo == "0") {
        //Q-type: d/dx x^1
        return "0";
      }

      if (der_expo == "1") {
        //Q-type: d/dx x^0
        return "$exponent$variable";
      }

      //Q-type: d/dx x^2
      return "$exponent$variable^$der_expo";
    }

    int newCoeff = int.parse(exponent) * int.parse(coefficient);
    if (der_expo == "0") {
      //Q-type: d/dx 5x^1
      return "0";
    }

    //Q-type: d/dx 5x^0
    if (der_expo == "1") {
      return "$newCoeff$variable";
    }

    //Q-typy: d/dx 5x^2
    return "$newCoeff$variable^$der_expo";
  }
}

class ReplaceX {
  String replaceX(String variable, String deriveThis) {
    var newEquation = variable.replaceFirst('x', deriveThis);
    return newEquation;
  }
}

class IsNumeric {
  bool isNum(String str) {
    return int.tryParse(str) != null;
  }
}

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

class SubstituitionHandler {
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

class Simplification {
  dynamic simplify(String? result) {
    if (result != null && result.contains('-')) {
      result = result.replaceFirst('-', '');
      result = "-$result";
    }
    return result;
  }
  
  dynamic simplifyEnd(String result){
    result = result.replaceFirst('+-', '-');
    return result;
  }
}

void main() {
  DiffHandler diffHandler = DiffHandler();
  List<String> lstEquations = [
    "5",
    "5x",
    "x^2",
    "x^3",
    "5x^2",
    "5x^3",
    "cos(x)",
    "5cos(x)", 
    "5cos(x)^2",
    "5cos(x)^3",
    "5x^2+5cos(x)",
    "5x^3+5cos(x)^2",
    "5x^3*5cos(x)",
    "5x^3/5cos(x)",
    "cos(2x)",
    "cos(x^2)",
    "cos(x^3)",
    "cos(3x^2)",
    "5cos(3x^2)",
    "5cos(9x^9)"
  ];

  for (var eqn in lstEquations) {
    print("Question: ${eqn}");
    String result = diffHandler.diffHandler(eqn);
    print("Answer: $result");
    print("===");
  }
}