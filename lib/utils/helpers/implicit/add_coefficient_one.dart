import 'package:flutter/material.dart';

class AddCoefficientOne {
  bool purelyNumerical(String eqn) {
    return RegExp(r'^\d+$').hasMatch(eqn);
  }

  String? addCoefficientOne(String? eqn) {
    // Add '1' if doesn't contain any coefficient, unless numerical.
    if (eqn == null) {
      throw ArgumentError('Argument cannot be null');
    }

    if (!purelyNumerical(eqn)) {
      /* 
      Only time we will need to put 1 is when,
      there is nothing infront of t. 
      */
      RegExp regExp = RegExp(r'^\bt\b');
      if (regExp.hasMatch(eqn)) {
        return "1$eqn";
      }
    }
    return eqn;
  }
}
