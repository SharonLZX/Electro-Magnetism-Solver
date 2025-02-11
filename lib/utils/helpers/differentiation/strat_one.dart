import 'package:electro_magnetism_solver/utils/helpers/differentiation_rules/power_rule.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_coefficient_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_exponent_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_exponent_zero.dart';

class StrategyOne {
  String? strategyOne(String indvFunc) {
    AddCoefficientOne addCoefficientOne = AddCoefficientOne();
    AddExponentOne addExponentOne = AddExponentOne();
    AddExponentZero addExponentZero = AddExponentZero();

    String? updInvFunc = addCoefficientOne.addCoefficientOne(indvFunc);
    updInvFunc = addExponentOne.addExponentOne(updInvFunc);
    updInvFunc = addExponentZero.addExponentZero(updInvFunc);

    PowerRule powerRule = PowerRule();
    String? result = powerRule.powerRule(updInvFunc);
    if (result != null){
      return result;
    }else{
      return null;
    }
  }
}
