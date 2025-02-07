import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/utils/handlers/differentiation/differentiation_handler_2.dart';

class QuotProdRule {
  String quotProdRule(String chgFlux) {
    DiffHandler2 diffHandler2 = DiffHandler2();


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
    finalResult.add(diffHandler2.diffHandler2(splitEquation[0]));
    finalResult.add(splitEquation[0]);
    finalResult.add(diffHandler2.diffHandler2(splitEquation[1]));

    for (int i = 0; i < finalResult.length; i += 2) {
      pairs.add("${finalResult[i]}*${finalResult[i + 1]}");
    }

    if (chgFlux.contains('/')) {
      return ("[${pairs.join('-')}]/${splitEquation[1]}^2");
    }
    return (pairs.join('+'));
  }
}