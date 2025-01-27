import 'package:electro_magnetism_solver/calculations/differentiation.dart';

class DiffHandler {
  dynamic diffHandler(String chgFlux) {
    List<String> pairs = [];
    List<String> finalResult = [];
    List<String> splitEquation = [];
    List<String> arithOper1 = ["/", "*"];

    bool arithCheck = arithOper1.any((arith) => chgFlux.contains(arith));
    if (!arithCheck) {
      //If there are no arithmetic operators
      return diffHandler2(chgFlux);
    } else {
      if (chgFlux.contains(arithOper1[0])) {
        //Quotient rule
        splitEquation = chgFlux.split('/');
        splitEquation.removeWhere((element) => element == '/');
      } else {
        //Product rule
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
      } else {
        return (pairs.join('+'));
      }
    }
  }

  //Dynamic because can return either string or List<String>
  dynamic diffHandler2(String equation) {
    List<String> splitEquation = [];
    List<String> arithOper2 = ["-", "+"];
    List<String> result = [];
    Differentiate differentiate = Differentiate();

    bool arithCheck = arithOper2.any((arith) => equation.contains(arith));
    if (!arithCheck) {
      //If there are no arithmetic operators
      return differentiate.differentiate(equation);
    }

    if (equation.contains("-")) {
      splitEquation = equation.split('-');
      splitEquation.removeWhere((element) => element == '-');
    } else {
      splitEquation = equation.split('+');
      splitEquation.removeWhere((element) => element == '+');
    }
    for (var func in splitEquation) {
      result.add(differentiate.differentiate(func));
    }
    if (equation.contains("-")) {
      return result.join('-');
    } else {
      return result.join('+');
    }
  }
}
