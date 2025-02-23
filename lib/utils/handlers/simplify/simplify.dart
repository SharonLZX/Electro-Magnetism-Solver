import 'package:electro_magnetism_solver/utils/handlers/expansion/expansion.dart';
import 'package:electro_magnetism_solver/utils/helpers/substituition/substituition.dart';
import 'package:electro_magnetism_solver/utils/helpers/term_wise/term_wise.dart';
import 'package:flutter/material.dart';

class SimplifyHandler {
  dynamic simplifyHandler(String chgFlux) {
    debugPrint("chgFlux: $chgFlux");

    TermWise termWise = TermWise();
    Map<String, List<String>> mapTermWise = termWise.termWise(chgFlux);
    debugPrint("mapTermWise: $mapTermWise");

    Substituition substituition = Substituition();
    Map<String, List<String>> cleanMap = substituition.substitued(mapTermWise);
    debugPrint("cleanMap: $cleanMap");

    List<String> lstSubstitute = [];
    Expansion expansion = Expansion();
    cleanMap.forEach((key, valueList) {
      String newFunction = valueList.join("+");
      debugPrint("newFunction: $newFunction");

      String result = expansion.expansion(newFunction);
      debugPrint("result: $result");

      result = expansion.combineLikeTerms(result);
      debugPrint("result: $result");
      
      lstSubstitute.add(result.replaceAll('t', key));
      debugPrint("lstSubstitute: $lstSubstitute");
    });
    debugPrint("lstSubstitute.join('+'): ${lstSubstitute.join('+')}");
    return lstSubstitute.join('+');
  }
}
