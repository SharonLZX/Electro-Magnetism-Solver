import 'package:electro_magnetism_solver/utils/handlers/expansion/expansion.dart';
import 'package:electro_magnetism_solver/utils/helpers/substituition/substituition.dart';
import 'package:electro_magnetism_solver/utils/helpers/term_wise/term_wise.dart';
import 'package:flutter/material.dart';

class SimplifyHandler {
  dynamic simplifyHandler(String chgFlux) {
    TermWise termWise = TermWise();
    Map<String, List<String>> mapTermWise = termWise.termWise(chgFlux);

    Substituition substituition = Substituition();
    Map<String, List<String>> cleanMap = substituition.substitued(mapTermWise);

    List<String> lstSubstitute = [];
    Expansion expansion = Expansion();
    cleanMap.forEach((key, valueList) {
      /*
      Since now all our values are t, see substitued line 26-28.
      we can run the valueList through our simplify.

      But simplifiying, we may have new like terms. So let's 
      combine them together.

      Lastly, replace all the 't' with the 'key'
      */
      String newFunction = valueList.join("+");
      debugPrint("newFunction: $newFunction");

      String result = expansion.expansion(newFunction);
      debugPrint("result: $result");

      result = expansion.combineLikeTerms(result);
      lstSubstitute.add(result.replaceAll('t', key));
    });
    return lstSubstitute.join('+');
  }
}
