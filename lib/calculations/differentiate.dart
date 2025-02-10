import 'package:electro_magnetism_solver/utils/helpers/differentiation_rules/rules_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers/differentiation_rules/chain_rule_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers/others/coefficient_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers/differentiation_rules/exponent_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers/others/is_numeric_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers/others/replace_x_helper.dart';

class Differentiate {
  String? differentiate(String equation) {
    CoefficientHandler coefficientHandler = CoefficientHandler();
    ExponentHandler exponentHandler = ExponentHandler();
    DiffRulesHandler diffRulesHandler = DiffRulesHandler();
    ChainRuleHandler chainHandler = ChainRuleHandler();

    //Identify coefficient, variable and/or exponent
    //Based on what's available, return the proper format
    String coefficient = "";
    String variable = "";
    String exponent = "";
    String derExpo = ""; //'exponent' minus 1

    String coeffVar = ""; //Contains the coeff and var
    bool containCoeff = false; //Assume all equations !contain exponents
    bool containExpo = false;
    bool containTrigo = false;
    bool requireChain = false;

    String? dervChain = ""; //Contains the derivative AFTER chain rule

    String finalCoeff = "";
    dynamic deriveThis; //We need this to rebuild the function later on
    dynamic
        newVariable; //This will contain the newVariable, e.g. sin(5x) will be sin(x)
    List<String>? coeffVarList = [];

    //Check if require chain rule (36-48)
    var chainStatus = chainHandler.extractChain(equation);

    if (chainStatus != null && chainStatus != false) {
      deriveThis = chainStatus[0]; //'x^2'
      newVariable = chainStatus[1]; //'sin(x)'
      dervChain = differentiate(
          deriveThis); // dervChain contains the derivative of 'x^2'
      requireChain = true;
    }

    if (requireChain) {
      // Replace x in sin(x) with x^2, to bring back original equation.
      var newEquation = equation.replaceFirst(deriveThis, 'x');
      equation = newEquation;

      // MISUNDERSTANDING:
      // sin(x^2) doesn't contain exponent, but sin(x)^2 does.
      coeffVarList = exponentHandler.containsExp(newEquation);
    } else {
      //Check if contains exponent
      coeffVarList = exponentHandler.containsExp(equation);
    }

    //Check if contains exponent (51-63)
    if (coeffVarList != null) {
      containExpo = true;
      coeffVar = coeffVarList[0];
      exponent = coeffVarList[1];

      //Check if coefficient exists
      coeffVarList =
          coefficientHandler.extractCoefficient(coeffVar); //Reuse the list
    } else {
      //Pass equation rather than coeffVar here, since
      //'equation' will contain only the coefficient &
      //variable.
      coeffVarList = coefficientHandler.extractCoefficient(equation);
    }

    //Check if contain coefficient (65-77)
    if (coeffVarList != null) {
      containCoeff = true;
      coefficient = coeffVarList[0];
      if (requireChain == true) {
        variable = newVariable;
      } else {
        variable = coeffVarList[1];
      }
    } else if (containExpo) {
      //No coefficient with exponent (e.g. x^2)
      variable = coeffVar;
    } else {
      if (requireChain == true) {
        variable = newVariable;
      } else {
        //No coefficient, no exponent (e.g. cos(x), x)
        //No substituition required too
        variable = equation;
      }
    }

    if (containExpo) {
      List<int> expoLst = diffRulesHandler.powerRule(exponent);
      exponent = expoLst[0].toString();
      derExpo = expoLst[1].toString();
    }

    if (variable.contains('sin')) {
      containTrigo = true;
      variable = diffRulesHandler.sinRule(); //Simply overwrite the variable.
    } else if (variable.contains('cos')) {
      containTrigo = true;
      variable = diffRulesHandler.cosRule();
    }

    if (variable.contains('ln')) {
      variable = diffRulesHandler.lnRule();
    }

    IsNumeric isNum = IsNumeric();
    ReplaceX replaceX = ReplaceX();

    if (isNum.isNum(variable)) {
      //Q-type: d/dx 5
      return "0";
    }

    if (requireChain == true) {
      variable = replaceX.replaceX(
          variable, deriveThis); //TODO: replaced already above?
    }

    if (containCoeff == false && containExpo == false) {
      coefficient = "1";
      if (containTrigo) {
        // No coefficient, no exponent, but contains trigo
        if (requireChain == true) {
          // If chain rules has been performed
          // Then we need to display the derived value first
          // e.g. sin(x^2) => 2x * cos(x^2)
          return "$dervChain$variable";
        }

        //Q-type: d/dx sin(x) or cos(x), without chain rule
        return variable;
      }

      //Q-type: d/dx ln(x)
      return "1/x";
    }

    if (containCoeff == true && containExpo == false) {
      // Q-type: 5cos(x) or 5x^2
      if (containTrigo) {
        if (requireChain == true) {
          //Since there is a coefficient, we need to make
          //sure that the $dervChain multiplys with $coefficient

          if (dervChain != null) {
            //We assume the dervChain will always be <number> followed
            //by a 'x' so we removeLast() to remove the x, to get the
            //<numbers> to get the new multiplied number.

            var dervChainLst = dervChain.split('');

            for (var item in dervChainLst) {
              if (item == 'x') {
                break;
              }
              finalCoeff = finalCoeff + item.toString();
            }
            var newEquation = int.parse(coefficient) * int.parse(finalCoeff);

            String dervChainStr = dervChainLst[0];
            if (dervChainStr.contains('x')) {
              return "$newEquation$variable";
            }

            if (dervChainLst.contains('^')) {
              return "${newEquation}x^${dervChainLst.last}$variable";
            } else {
              return "${newEquation}x$variable";
            }
          }
        }
        //Q-type: d/dx 5sin(x)
        return "$coefficient$variable";
      }
      //Q-type: d/dx 5x
      return coefficient;
    }

    if (containCoeff == false && containExpo == true) {
      if (derExpo == "0") {
        //Q-type: d/dx x^1
        return "0";
      }

      if (derExpo == "1") {
        //Q-type: d/dx x^0
        return "$exponent$variable";
      }

      //Q-type: d/dx x^2
      return "$exponent$variable^$derExpo";
    }

    if (containCoeff = true && containExpo == true) {
      int newCoeff = int.parse(exponent) * int.parse(coefficient);
        if (derExpo == "0") {
          //Q-type: d/dx 5x^1
          return "0";
        }

        //Q-type: d/dx 5x^0
        if (derExpo == "1") {
          return "$newCoeff$variable";
        }

        //Q-typy: d/dx 5x^2
        return "$newCoeff$variable^$derExpo";
      }
      if (requireChain) {
        //Q-type: d/dx 5sin(3x^3)^3
        
      } else {
        
    }
  }
}
