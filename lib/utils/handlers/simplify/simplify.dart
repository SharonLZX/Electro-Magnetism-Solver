import 'package:electro_magnetism_solver/utils/handlers/expansion/expansion.dart';
import 'package:electro_magnetism_solver/utils/helpers/substituition/substituition.dart';
import 'package:electro_magnetism_solver/utils/helpers/term_wise/term_wise.dart';

class SimplifyHandler {
  dynamic simplifyHandler(String chgFlux) {
    /*
    To handle the simplification of the given expression chgFlux.
      1) TermWise: To get the like terms of the expression mapped into a dictionary.
      2) Substituition: To substitute all the like terms with a constant.
      3) Expansion: To expand the expression using the substituted expression and combine them.

    Parameters:
      @params chgFlux: The expression to be simplified.
      @type chgFlux: String

    Return:
      @return lstSubstitute: The simplified expression.
      @type lstSubstitute: List<String>
    */

    // Creating the instances of the classes.
    TermWise termWise = TermWise();
    Expansion expansion = Expansion();
    Substituition substituition = Substituition();

    // Initialising the variables.
    String result = '';
    String joinValue = '';
    List<String> lstSubstitute = [];
    Map<String, List<String>> mapTermWise = {};
    Map<String, List<String>> postSubstituteMap = {};

    // Getting the like terms of the expression.
    mapTermWise = termWise.termWise(chgFlux);

    // Substituting the like terms with a constant.
    postSubstituteMap = substituition.substitued(mapTermWise);

    // 1) Iterating over like terms (value pair) and expanding them.
    // 2) Combining the like terms.
    // 3) Substituting constant with the key pair.
    // 4) Storing into a list pair.
    postSubstituteMap.forEach((key, valueList) {
      joinValue = valueList.join('+');

      result = expansion.expansion(joinValue);
      result = expansion.combineLikeTerms(result);
      result = result.replaceAll('t', key);
      
      lstSubstitute.add(result);
    });

    return lstSubstitute.join('+'); // ASSUMPTION: The expression is in the form of addition.
  }
}
