import 'package:electro_magnetism_solver/calculations/differentiation.dart';

class DiffHandler {
  dynamic diffHandler(List<String> equations) {
    List<String> eqnSplited = []; // Same functionality as 'eqnSplitted'
    List<String> finalResult = [];
    List<String> pairs = [];
    List<String> arith2 = ["/", "*"];

    Differentiate differentiate = Differentiate();

    for (String eqn in equations) {
      bool arithCheck = arith2.any((arith2) => eqn.contains(arith2));
      if (!arithCheck) {
        finalResult.add(differentiate.differentiate(eqn));
      } else {
        // When tried to loop over arith2 (like in calculate), it doesn't work.
        if (eqn.contains('/')) {
          eqnSplited = eqn.split('/');
          eqnSplited.removeWhere((element) => element == '/');
        } else {
          eqnSplited = eqn.split('*');
          eqnSplited.removeWhere((element) => element == '*');
        }

        finalResult.add(eqnSplited[1]);
        finalResult.add(differentiate.differentiate(eqnSplited[0]));
        finalResult.add(eqnSplited[0]);
        finalResult.add(differentiate.differentiate(eqnSplited[1]));
        for (int i = 0; i < finalResult.length; i += 2) {
          pairs.add(finalResult[i] + finalResult[i + 1]);
        }
        if (eqn.contains('/')) {
          return ("[${pairs.join('-')}]/${eqnSplited[1]}^2");
        } else {
          return (pairs.join('+'));
        }
      }
    }
    return finalResult;
  }
}
