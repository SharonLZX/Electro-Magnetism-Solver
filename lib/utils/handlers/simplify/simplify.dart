import 'package:electro_magnetism_solver/utils/handlers/expansion/expansion.dart';
import 'package:electro_magnetism_solver/utils/helpers/substituition/substituition.dart';
import 'package:electro_magnetism_solver/utils/helpers/term_wise/term_wise.dart';

class SimplifyHandler {
  dynamic simplifyHandler(String chgFlux) {
    TermWise termWise = TermWise();
    Map<String, List<String>> mapTermWise = termWise.termWise(chgFlux);

    // Substitution complex terms like 5sin(t^3) to 5t
    Substituition substituition = Substituition();
    Map<String, List<String>> cleanMap = substituition.substitued(mapTermWise);

    String result;
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
      result = expansion.expansion(newFunction); // TODO: Assuming all plus, which is wrong.
      result = expansion.combineLikeTerms(result);

      lstSubstitute.add(result.replaceAll('t', key));
    });

    /* Insert a * if there is a product rule. */
    for (int i = 0; i < lstSubstitute.length; i++) {
      if (lstSubstitute[i].contains(')(')) {
        lstSubstitute[i] = lstSubstitute[i].replaceAll(')(', ')*(');
      }
    }

    return lstSubstitute.join('+'); // TODO: Assuming all plus, which is wrong.
  }
}
