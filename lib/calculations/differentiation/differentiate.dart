import 'package:electro_magnetism_solver/utils/helpers.dart/helpers/rules_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers.dart/helpers/chain_rule_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers.dart/helpers/coefficient_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers.dart/helpers/exponent_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers.dart/helpers/is_numeric_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers.dart/helpers/replace_x_helper.dart';
import 'package:flutter/material.dart';

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

    String? dervSub = ""; //Contains the derivative AFTER substituition
    
    String finalCoeff = "";
    dynamic deriveThis; //We need this to rebuild the function later on
    dynamic newVariable; //This will contain the newVariable, e.g. sin(5x) will be sin(x)
    List<String>? coeffVarList = [];

    //Check if require substituition
    var subStatus = chainHandler.extractSub(equation);
    if (subStatus != null && subStatus != false) {
      deriveThis = subStatus[0];
      newVariable = subStatus[1];
      dervSub = differentiate(deriveThis);
      requireChain = true;
    }

    if (requireChain) {
      var newEquation = equation.replaceFirst(deriveThis, 'x');
      equation = newEquation;
      coeffVarList = exponentHandler.containsExp(newEquation);
      } else {
      //Check if contains exponent
      coeffVarList = exponentHandler.containsExp(equation);
    }

    if (coeffVarList != null) {
      containExpo = true;
      coeffVar = coeffVarList[0];
      exponent = coeffVarList[1];
      coeffVarList =
          coefficientHandler.extractCoefficient(coeffVar); //Reuse the list
    } else {
      //Pass equation rather than coeffVar here, since
      //'equation' will contain only the coefficient &
      //variable.
      coeffVarList = coefficientHandler.extractCoefficient(equation);
    }

    //Check if contain coefficient
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
    }else if (variable.contains('cos')) {
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
      variable = replaceX.replaceX(variable, deriveThis);
    }

    if (containCoeff == false && containExpo == false) {
      coefficient = "1";
      if (containTrigo) {
        if (requireChain == true) {
          return "$dervSub$variable";
        }

        //Q-type: d/dx sin(x)
        return variable;
      }
      return "1/x";
    }

    if (containCoeff == true && containExpo == false) {
      if (containTrigo) {
        if (requireChain == true) {
          //Since there is a coefficient, we need to make
          //sure that the $dervSub multiplys with $coefficient
          if (dervSub != null) {
            //We assume the dervSub will always be <number> followed
            //by a 'x' so we removeLast() to remove the x, to get the
            //<numbers> to get the new multiplied number.

            var dervSubLst = dervSub.split('');
            for (var item in dervSubLst){
              if (item == 'x'){
                break;
              }
              finalCoeff = finalCoeff + item.toString();
            }
            var newEquation = int.parse(coefficient) * int.parse(finalCoeff);

            String dervSubStr = dervSubLst[0];
            if (dervSubStr.contains('x')) {
              return "$newEquation$variable";
            }
            return "${newEquation}x$variable";
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
}