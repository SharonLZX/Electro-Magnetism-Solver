
import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:flutter/material.dart';

class Differentiate {
  String differentiate(String eqn) {
    var resultOfSplit = splitCoefficient(eqn);
    var coeff = resultOfSplit[0];
    eqn = resultOfSplit[1];
    debugPrint(coeff);
    debugPrint(eqn);
    if (eqn.contains("^")) {
      List<int> powLst = [];
      powLst = powerRule(eqn);
      debugPrint(powLst.toString());
      if (powLst[1] == 0){
        eqn = "0";
      }else if (powLst[1] == 1){
        eqn = "${(int.parse(coeff)*2)}x";
      }else{
        eqn = "${int.parse(coeff)*powLst[0]}x^${powLst[1]}";
      }
    }else{
      if (eqn == ""){
        // Special case: dy/dx constant
        eqn = "0";
      }else{
        eqn = coeff;
      }
      
    }

    if (eqn.contains("sin")){
      eqn = sinRule();
    }else if (eqn.contains("cos")){
      eqn = cosRule();
    }

    if (eqn.contains("ln")){
      eqn = lnRule();
    }

    return eqn;
  }

  List<String> splitCoefficient(String eqn){
    final regex = coefficientRegEx;
    final match = regex.firstMatch(eqn);
    if (match != null){
      String coefficient = match.group(1) ?? '1';
      String variable = match.group(2) ?? '';
      if (coefficient == '+' || coefficient == '-'){
        coefficient += '1';
      }
      return [coefficient, variable];
    }
    return [eqn, ''];
  }

  List<int> powerRule(String eqn) {
    int exponent = 0;
    int expMinus1 = 0;
    List<int> expLst = [];

    RegExp regExp = RegExp(r'\^(\d+)');
    Match? match = regExp.firstMatch(eqn);

    if (match == null) {
      expLst.add(0);
      return expLst;
    }

    exponent = int.parse(match.group(1)!);
    expMinus1 = exponent - 1;
    expLst.add(exponent);
    expLst.add(expMinus1);
    return expLst;
  }

  String cosRule() {
    return ("-sin(x)");
  }

  String sinRule() {
    return ("cos(x)");
  }

  String lnRule() {
    return ("1/(x)");
  }
}
