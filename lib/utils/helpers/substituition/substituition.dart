import 'package:flutter/material.dart';

class Substituition {
  Map<String, List<String>> substitued(Map<String, List<String>> mapTermWise) {
    bool purelyNumerical(String eqn) {
      /*
      This part is important only in some instances,
      because I found that constants that are splitted in
      termWise sometimes have an additional '+' attached.
      So we need to include this check to remove the + or -.
      */
      if (eqn.contains("+")) {
        eqn = eqn.replaceAll('+', '');
      } else if (eqn.contains("-")) {
        eqn = eqn.replaceAll('-', '');
      }

      /* Returns a true if the equation is purely numerical. */
      return RegExp(r'^\d+$').hasMatch(eqn);
    }

    /*
    Essentially, this part, we trying to change all the variables 
    in the dictionary's value (list) into t.
    
    mapTermWise: {sin(t): [5sin(t), +6sin(t)], t: [+3t]}
    mapTermWise: {sin(t): [5t, +6t], t: [+3t]}
    */
    mapTermWise.forEach((key, valueList) {
      for (int i = 0; i < valueList.length; i++) {
        if (purelyNumerical(valueList[i]) == true) {
          continue;
        } else {
          valueList[i] = valueList[i].replaceAll(key, 't');
        }
      }
    });
    return mapTermWise;
  }
}
