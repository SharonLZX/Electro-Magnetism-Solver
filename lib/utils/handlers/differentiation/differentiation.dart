import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/utils/helpers/differentiation/strat_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/differentiation/strat_two.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/split_function.dart';

class Differentiation {
  List<String?> differentiate(String wholeFunction) {
    List<String?> lstResult = [];

    SplitFunction splitFunc = SplitFunction();
    List<String> lstFunc = splitFunc.splitFunction(wholeFunction);

    for (String indvFunc in lstFunc) {
      bool hasBrackets = hasParentheses.hasMatch(indvFunc);
      bool isTrig = isTrigFunction.hasMatch(indvFunc);
      if (!hasBrackets) {
        /* 
        Question type: 
          n, nt, nt^n
        Strategy (1):
          We will change all to follow nt^n format
          before using POWER rule.
        */
        StrategyOne strategyOne = StrategyOne();
        String? result = strategyOne.strategyOne(indvFunc);
        lstResult.add(result);
      }else if (!isTrig && !indvFunc.contains('/')) {
        /* 
        Question type:
          n(t), n(t+...)
        Strategy (2):
          Immediately product rule, regardless how
          simple it is. We can handle the simplify-ing
          later.
        */
        StrategyTwo strategyTwo = StrategyTwo();
        String? result = strategyTwo.strategyTwo(indvFunc);
        lstResult.add(result);
      }else if (isTrig){
        // sin(t), cos(t)
        return ["sin(t)"];
      }
    }
    return lstResult;
  }
}
