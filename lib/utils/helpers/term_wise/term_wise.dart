import 'package:electro_magnetism_solver/utils/handlers/simplify/simplify.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_arithmetic.dart';

class TermWise {
  bool purelyNumerical(String eqn) {
    return RegExp(r'^\d+$').hasMatch(eqn);
  }

  dynamic termWise(String? wholeEquation) {
    Map<String, List<String>> groupedTerms = {};

    /*If empty equation */
    if (wholeEquation == null || wholeEquation.isEmpty) {
      return {};
    }

    ExtractArithmetic extractArithmetic = ExtractArithmetic();
    List<String> lstSplit = extractArithmetic.extractArithmetic2(wholeEquation);
    for (String term in lstSplit) {
      term = term.trim();
      /*If empty equation, start next iteration.*/
      if (term.isEmpty) continue;

      /* Since purley numerical, no point to do anything about it. */
      if (purelyNumerical(term) == true) {
        groupedTerms.putIfAbsent(term, () => []).add(term);
        continue;
      }

      /* 
      Not null means, there is a inner term. Like, 5t(5t+3),
      5t+3 is the inner term. So if there is an inner term,
      we must attempt to simplify that term first, before 
      continuing with our main simplification.
      */
      String? innerTerms = extractArithmetic.extractGroupedTerm(term);
      if (innerTerms != null && innerTerms != 't') {
        SimplifyHandler simplifyHandler = SimplifyHandler();
        dynamic simplifiedTerm = simplifyHandler.simplifyHandler(innerTerms);
        term = term.replaceAll(innerTerms, simplifiedTerm);
      }

      /*
      Essentially, this part, we are trying to create a dictionary, that will
      store all the like terms together.
      
      Example:
      {x: [3x, +4x], 
      sin(t): [-5sin(t), +7sin(t)],
      cos(t)sin(t): [+2cos(t)sin(t)]}
      */
      RegExp regex = RegExp(r'^([+\-]?\d*\.*\d*)([a-zA-Z()^0-9]+.*)$');
      Match? match = regex.firstMatch(term);
      if (match != null) {
        String key =
            match.group(2)!; // Variable part (e.g., sin(t), cos(t)sin(t))
        String coefficient = (match.group(1) == null || match.group(1)!.isEmpty)
            ? "1"
            : match.group(1)!;

        /*
        If we don't have this bool check, then we'll remove away cos, sin,
        ln's brackets. 
        */
        if (!RegExp(r'(sin|cos|ln)').hasMatch(key)) {
          key = key.replaceAll(RegExp(r'[()]'), '');
        }
        groupedTerms.putIfAbsent(key, () => []).add('$coefficient$key');
      }
    }
    return groupedTerms;
  }
}
