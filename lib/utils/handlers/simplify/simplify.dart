import 'package:electro_magnetism_solver/calculations/simplification.dart';
import 'package:electro_magnetism_solver/utils/helpers/substituition/substituition.dart';
import 'package:electro_magnetism_solver/utils/helpers/term_wise/term_wise.dart';
import 'package:flutter/material.dart';

class SimplifyHandler {
  dynamic simplifyHandler(String chgFlux) {
    // Splits the terms,
    // TODO: Since we're splitting the terms, we can't yet identify
    // constants that are numerical meaning 5t(5t+6+4).

    TermWise termWise = TermWise();
    Map<String, List<String>> mapTermWise = termWise.termWise(chgFlux);

    // Substitution complex terms like 5sin(t^3) to 5t
    Substituition substituition = Substituition();
    mapTermWise = substituition.substitued(mapTermWise);

    String result;
    List<String> lstSubstitute = [];
    Simplification simplification = Simplification();
    mapTermWise.forEach((key, valueList) {
      result = simplification.simplify(valueList.join(''));
      result = simplification.combineLikeTerms(result);
      lstSubstitute.add(result.replaceAll('t', key));
    });

    // Insert a * if there is a product rule.
    for (int i = 0; i < lstSubstitute.length; i++) {
      if (lstSubstitute[i].contains(')(')) {
        lstSubstitute[i] = lstSubstitute[i].replaceAll(')(', ')*(');
      }
    }
    return lstSubstitute.join('+'); // TODO: Assuming all plus, which is wrong.
  }
}
