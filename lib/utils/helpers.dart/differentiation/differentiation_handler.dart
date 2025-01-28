import 'package:electro_magnetism_solver/utils/helpers.dart/helpers/quot_prod_helper.dart';
import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/utils/formatters/simplification.dart';
import 'package:electro_magnetism_solver/utils/helpers.dart/differentiation/differentiation_handler_2.dart';

class DiffHandler {
  dynamic diffHandler(String chgFlux) {
      //DiffHandler handles whether the equation falls
  //under either the product or quotient rule.

  Simplification simplifyHandler = Simplification();
  QuotProdRule quotProdRule = QuotProdRule();
  DiffHandler2 diffHandler2 = DiffHandler2();

    bool arithCheck = arithOper1.any((element) => chgFlux.contains(element));

    if (!arithCheck) {
      var result = diffHandler2.diffHandler2(chgFlux);
      return simplifyHandler.simplifyEnd(result);
    }
    var result = quotProdRule.quotProdRule(chgFlux);
    return simplifyHandler.simplifyEnd(result);
  }
}
