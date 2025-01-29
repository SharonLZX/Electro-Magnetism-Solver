import 'package:electro_magnetism_solver/calculations/differentiation/differentiate.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify_helper.dart';

class DiffHandler2 {
  dynamic diffHandler2(String equation) {
    // DiffHandler2 handles whether the equation contains either
    // + or - .

    List<String?> result = [];
    List<String> splitEquation = [];
    List<String> arithOper2 = ["-", "+"];

    Differentiate differentiate = Differentiate();
    Simplification simplifyHandler = Simplification();

    bool arithCheck = arithOper2.any((arith) => equation.contains(arith));
    if (!arithCheck) {
      String? res = differentiate.differentiate(equation);
      return simplifyHandler.simplify(res);
    }

    if (equation.contains("-")) {
      splitEquation = equation.split('-');
      splitEquation.removeWhere((element) => element == '-');
    } else {
      splitEquation = equation.split('+');
      splitEquation.removeWhere((element) => element == '+');
    }

    for (var func in splitEquation) {
      String? res = differentiate.differentiate(func);
      result.add(simplifyHandler.simplify(res));
    }

    if (equation.contains("-")) {
      return result.join('-');
    } else {
      return result.join('+');
    }
  }
}
