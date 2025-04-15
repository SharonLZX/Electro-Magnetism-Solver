class Simplification {
  String simplify(String function) {
    List<String?> extArithLst = [];
    List<String?> resLst = [];

    List<String?> naughtyLst = []; //Probably needs a better name, LOL
    List<int> indexLst = []; //Store the index of all naughty boys
    List<String?> finalResLst = [];

    bool specialCase = false;
    int intCompare = 0;

    extArithLst = extArith(function);

    for (int i = 0; i < extArithLst.length; i++) {
      String? func = extArithLst[i];
      if (func == null) {
        break; // Break out of loop if null encountered.
      }

      if (func.contains('(')) {
        if (i == 1) {
          specialCase = true;
        }

        /* This list can help us to remove the arg from func later. Since we 
         * use i-1, if the question is "(5t)+3" then the code will fail, since
         * [0]-1 is -1 and there is nothing. */

        /* Pass func that require expansion,
         * extArithLst[i-1]: multiplier,
         * func: variable / argument */

        /* resLst: Will contain only the expanded variables.
         * 
         * Example: 5(t+3)
         * resLst: [5t+3]
         * */

        resLst.add(extParent(extArithLst[i - 1], func));
      } else {
        /* Constant, arithmetics, and single var (i.e. t) will appear 
         * here need to sort it out to only store items (t and constants)
         * excluding arithmetics. We can do this by checking if the 
         * element before or after is a arithmetic. We need this 2 if else 
         * because we need to look at i+1 but if we don't have the < less 
         * than check, we will run overindex at the last index
         * 
         * naughtyLst cannot add multiplier so we use [i+1] to check if it is.
         * naughtyLst contains all the san-san one.
         * */

        if (i + 1 < extArithLst.length) {
          // Ensure index is in bounds
          if (extArithLst[i + 1]?.contains('(') == false) {
            naughtyLst.add(func);
            indexLst.add(i);
          }
        } else {
          // When i + 1 == result.length, check result[i]
          if (func.contains('(') == false) {
            naughtyLst.add(func);
            indexLst.add(i);
          }
        }
      }
    }

    /* intCompare: Essentially, we want to compare the index of 
     * where the original position of the 'non-expandable' items 
     * are such as single 't' or '+' or '-'. versus the list (resLst)
     * of the EXPANDED variables. But this is a problem because
     * let's say 5(t+t), rather than 2 index, it becomes one.
     * So we have indexLst & naughtyLst which is based pre-expansion
     * and resLst which is post-expansion. Which has two different length.
     * So in order to counter that, we need to compare the indexes.
     * 
     * ONLY FOR CERTAIN SPECIAL SCENARIO WHERE specialCase IS true:
     * 
     * PROBLEM 1: But in the scenario where the expansion is in the beginning
     * like 5(5+5t)+t+5(5+5t), the intCompare must start from a 1 rather than a 
     * 0, because it will place both of the 5(5+5t) together at the front, before
     * reaching index 2 since lists start from zero. 
     * 
     * But that is only for this scenario.
     * So when shall we use intCompare as 0? when shall we use as 1?
     * 
     * SOLUTION 1: We can remain the intCompare as 0, but take indexLst,
     * and minus 1 throughout. We can do that if we detect that if-else
     * func.contains('(') statement is for index 1, since index zero isn't.
     * allowed as we've to look i-1, which is -1. Will die.
     */

    if (specialCase) {
      for (var i = 0; i < indexLst.length; i++) {
        indexLst[i] -= 1;
      }
    }

    /* We iterate over indexLst, and compare the index
     * with a value initailly 0 (intCompare).
     */

    while (resLst.isNotEmpty && naughtyLst.isNotEmpty) {
      if (indexLst[0] > intCompare) {
        /* Since idx is larger than intCompare, 
         * it means that the index of resLst 
         * should come in here. */
        finalResLst.add(resLst[0]);
        resLst.removeAt(0);
      } else if (indexLst[0] == intCompare) {
        /* So since the idx is same as intCompare, 
         * we must use the string from naughtyLst.
         * If it is equal, means that the value, has no
         * change from it original position! */
        finalResLst.add(naughtyLst[0]);
        naughtyLst.removeAt(0);
        indexLst.removeAt(0);
      }
      intCompare = intCompare + 1;
    }

    /* In the case where the last number in indexLst 
     * has been evaluated but there are still strings 
     * in naughtyLst. We will just append them at 
     * the back of finalRes. */

    if (resLst.isNotEmpty) {
      for (var remain in resLst) {
        finalResLst.add(remain);
      }
    }

    if (naughtyLst.isNotEmpty) {
      for (var remain in naughtyLst) {
        finalResLst.add(remain);
      }
    }

    // In the case
    return finalResLst.join('');
  }

  // Short form for extract arithmetic
  List<String?> extArith(String func) {
    // func: WHOLE ENTIRE question
    // Purpose: Split string at points where there is a bracket, or + or -
    RegExp regExp = RegExp(r'([a-zA-Z0-9]+|[+\-*/^=])|\([^)]*\)');
    Iterable<Match> matches = regExp.allMatches(func);
    return matches.map((match) {
      return match.group(0);
    }).toList();
  }

  String extParent(String? mul, String arg) {
    Expansion expHelp = Expansion();
    List<String?> lstRes = [];
    List<String> lstArgs = []; // Hold args

    /* Every func here will involve a bracket (i.e. mul(arg))
     * We remove brackets cause arg still contains brackets */
    RegExp regExpBrac = RegExp(r'[\[\](){}]');
    arg = arg.replaceAll(regExpBrac, '');

    /* Now we need to check whether the arg contains a + or -,
     * and split accordingly. So if have +, split('+') if have
     * - split('-') */
    RegExp regExp = RegExp(r'[+\-*/]');
    if (regExp.hasMatch(arg)) {
      lstArgs = arg.split(regExp);
    } else {
      lstArgs = [arg];
    }

    // Now we're ready to expand the mul and args.
    for (String args in lstArgs) {
      lstRes.add(expHelp.expandHandler(mul, args));
    }

    /* Only work for arguments that contain the same arith
     * meaning, arg: 3(t+...+..) will work, but arg: 
     * 3(t+...-...) won't work because we're assuming with
     * .join('+') that all the arithmetic are +(s).
     * 
     * ANOTHER PROBLEM: mul: -5(5-5t) doesn't work too.
     * */

    if (arg.contains('+')) {
      return lstRes.join('+');
    }
    return lstRes.join('-');
  }
}

class Expansion {
  String? expandHandler(String? mul, String args) {
    /* Now that we're expanding mul, and args, 
     * Each bracket can contain one of these three types,
     * 1) constant, 2) coeff with variable, 
     * and 3) coeff with variable with exponent only
     * 
     * Let's make some adjustments to make our life easier
     * 1) <NO COEFF> If x or x^2 then become 1x or 1x^2 
     * 2) <NO EXPONENT> If x then become x^1
     * 3) <CONSTANT> If 5 then become 5x^0
     * 
     * PROBLEM: Since arg & mul can be 1 of the 4 variations,
     * constant, coefficient and constant, constant and exp
     * coefficient and constant and expo. Then there will be 
     * 4 x 3 x 2 x 1 variation = 24 kinds. So we need to use
     * the above 3 methods, to simplify it down to 3 kinds.
     * 
     * After these three formatting, will ensure all of the 
     * mul and args will be the same type. 
     * 
     * FOR IMPROVEMENT:
     * 5(t)+t+5(t)+t+5(t)+t - will not work
     * 
     * */

    // Add them into a list here, so we can iterate over.
    List<String?> lstMulArgs = [];
    lstMulArgs.add(mul);
    lstMulArgs.add(args);

    // 2 because lstMulArgs will always be 2 size.
    for (int i = 0; i < 2; i++) {
      /* Iterate and update over lstMulArgs
       * newValue: essentially stores the arg/mul
       * as it goes through a zheng-rong.*/
      var newValue = addCoeffOne(lstMulArgs[i]);
      newValue = addPowOne(newValue); // Add exponent one
      newValue = addPowZer(newValue);
      /* Overwrite previous (old) with new.
       * [5, 5]
       * [5t^0, 5]
       * [5t^0, 5t^0]*/
      lstMulArgs[i] = newValue;
    }

    /* After done with formatting, it's time to multiply
     * the coefficient and add the exponent. Cause we haven't
     * actually done any shit. */
    return expand(lstMulArgs);
  }

  String? expand(List<String?> lstMulArgs) {
    /* Multiply coefficient, add exponent
     * It's very simple here, just split each mul
     * and args into coefficient and exponent,
     * ignoring the variable (t or x). 
     */

    // A list here to store the mul & arg's coeff and exponent;
    List<String> lstCoExpMulArg = [];

    RegExp regExp = RegExp(r'^(-?\d*)(t\^)(-?\d+)$');
    for (var func in lstMulArgs) {
      if (func == null) {
        throw ArgumentError('Argument cannot be null');
      }

      Match? match = regExp.firstMatch(func);
      if (match != null) {
        /* So a equation like [5t^0, 1t^1] will show
         * [5, 0, 1, 1] */
        var _match = match.group(1);
        if (_match != null) {
          lstCoExpMulArg.add(_match);
        }

        _match = match.group(3);
        if (_match != null) {
          lstCoExpMulArg.add(_match);
        }
      }
    }

    /* Simply algebra here 
     * (5t^0) * (1t^1) = (5*1)t^(0+1)
     * */
    int coeffMul = int.parse(lstCoExpMulArg[0]);
    int exponMul = int.parse(lstCoExpMulArg[1]);
    int coeffArg = int.parse(lstCoExpMulArg[2]);
    int exponArg = int.parse(lstCoExpMulArg[3]);
    int newCoeff = coeffMul * coeffArg;
    int newExpo = exponMul + exponArg;

    return ("${newCoeff}t^${newExpo}");
  }

  String? addCoeffOne(String? eqn) {
    // Add '1' if doesn't contain any coefficient
    if (eqn == null) {
      throw ArgumentError('Argument cannot be null');
    }

    /* Only time we will need to put 1 is when,
     *  there is nothing infront of t. */
    RegExp regExp = RegExp(r'^t');
    if (regExp.hasMatch(eqn)) {
      return "1$eqn";
    }
    return eqn;
  }

  String? addPowOne(String? eqn) {
    // Add '^1' if doesn't contain any exponent
    if (eqn == null) {
      throw ArgumentError('Argument cannot be null');
    }

    RegExp regExp = RegExp(r'(?=.*t)(?!.*\^)');
    if (regExp.hasMatch(eqn)) {
      return "${eqn}^1";
    }
    return eqn;
  }

  String? addPowZer(String? eqn) {
    // Add '^0' if eqn is constant
    if (eqn == null) {
      throw ArgumentError('Argument cannot be null');
    }

    RegExp regExp = RegExp(r'^\d+$');
    if (regExp.hasMatch(eqn)) {
      // Has constant only
      return "${eqn}t^0";
    }
    return eqn;
  }
}

void main() {
  var question = "5(sin(x)+5)";
  var newQuestion = question.replaceAll('sin(x)', 't');
  bool replaceLe = question != newQuestion;

  if (replaceLe) {}

  List<String> lstQuestions = ["5t(5t)"];

  Simplification sHandler = Simplification(); //CHANGE NAME TO EXPANSION
  for (var question in lstQuestions) {
    var result = "";
    var qn = "";
    if (question.contains("sin")) {
      qn = question.replaceAll('sin(x)', 't');
    }
    bool replaceLe = question != qn;

    if (replaceLe) {
      result = sHandler.simplify(qn);
    } else {
      result = sHandler.simplify(question);
    }
    print("Question: $question");
    if (replaceLe) {
      print("Answer: ${result.replaceAll('t', 'sin(x)')}");
    } else {
      print("Answer: $result");
    }
    print("===============");
  }
}
