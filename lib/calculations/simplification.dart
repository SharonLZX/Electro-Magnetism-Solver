import 'package:electro_magnetism_solver/utils/helpers/implicit/add_coefficient_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_exponent_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_exponent_zero.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_arithmetic.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_parents.dart';
import 'package:flutter/material.dart';

class Simplification {
  String simplify(String function) {
    ExtractParents extractParents = ExtractParents();
    ExtractArithmetic extractArithmetic = ExtractArithmetic();

    List<int> lstIndex = [];
    List<String?> lstConst = [];
    List<String?> lstResult = [];
    List<String?> lstExtArith = [];

    bool expandPosiOne = false;
    lstExtArith = extractArithmetic.extractArithmetic(function);
    for (int i = 0; i < lstExtArith.length; i++) {
      String? function = lstExtArith[i];
      if (function == null) {
        break;
      }
      if (function.contains('(')) {
        if (i == 1) {
          expandPosiOne = true;
        }
        /*
        Since we're using i-1, if equation has a case of
        the (argument)multiplier, the code will fail (e.g 
        (5t)3, etc.).
        */

        lstResult
            .add(extractParents.extractParents(lstExtArith[i - 1], function));
      } else {
        /*
        Constants, arithmetics, and single variables (i.e. t)
        will appear here, therefore we need to sort out to store
        only relevant items ('t' & constants), excluding arithmetics.
        
        We can do this by checking if the before and after the
        index is a arithmetic.
        */
        if ((i + 1) < lstExtArith.length) {
          //If there are index infront of current i.
          if (lstExtArith[i + 1]?.contains('(') == false) {
            lstConst.add(function);
            lstIndex.add(i);
          }
        } else {
          if (function.contains('(') == false) {
            lstConst.add(function);
            lstIndex.add(i);
          }
        }
      }
    }
    /*
    PROBLEM:
    Since we have a list of the constants (lstConst), and
    the index of their ORIGINAL position (lstIndex). We should
    be able to simply use the post-expanded result (lstResult)
    and get the final result. But here's the problem, since
    the multiplier and argument has merge, we don't know what
    the NEW index is - Remember we only have the ORIGINAL 
    position of the constants.

    SOLUTION:
    So one quick workaround is that we compare the index of
    the ORIGINAL position (lstIndex) with a abitrary counter 
    (intCounter). Initially 'intCounter' will start off at 0
    and we will compare whether the index of 'lstIndex' is
    larger or smaller than. With that, we can identify whether
    it is supposed to be the 'lstResult' turn, or 'lstConst'.
    */

    /*
    PROBLEM:
    expandPosiOne is an additional workaround against the
    above problem. 
    
    Look at the equation: 5(5+5t^2)+t+t(5t),
    Notice how the middle t, is at index 2? 
    If we didn't had this check at expandPosiOne, the final
    output we'll get is 25t^0+25t^25t^2+t+ . Since, we start
    the intCounter at 0, it requires two counts to reach 2.
    Therefore, all of lstResult will be placed one after another.

    SOLUTION:
    So we can either start the intCounter at 1, OR we can
    simply minus everyone in the 'lstIndex' by 1.
    */
    if (expandPosiOne) {
      for (var i = 0; i < lstIndex.length; i++) {
        lstIndex[i] -= 1;
      }
    }

    int intCounter = 0; // Abitrary counter
    List<String?> lstFinalResult = []; // Store final results
    while (lstResult.isNotEmpty && lstConst.isNotEmpty) {
      if (lstIndex[0] > intCounter) {
        /*
        Since index is > than intCounter, that means
        that the index of result (lstResult) must come in here.
        That means that an expansion took place here.
        */
        lstFinalResult.add(lstResult[0]);
        lstResult.removeAt(0);
      } else if (lstIndex[0] == intCounter) {
        /*
        Since index is same as intCounter, we must use the
        constants from 'lstConst'.
        */
        lstFinalResult.add(lstConst[0]);
        lstConst.removeAt(0);
        lstIndex.removeAt(0);
      }
      intCounter += 1;
    }

    /*
    In the scenario where either lists is empty, and the other
    still has functions within. We can assume that the rest
    of the functions must go at the back of the 'lstFinalRes
    */
    if (lstResult.isNotEmpty) {
      for (var remaining in lstResult) {
        lstFinalResult.add(remaining);
      }
    }

    if (lstConst.isNotEmpty) {
      for (var remaining in lstConst) {
        lstFinalResult.add(remaining);
      }
    }

    return lstFinalResult.join('');
  }

  String combineLikeTerms(String function) {
    /*
    Essentially we will combine all the values with same exponent together.
    We will use the help of a dictionary.
    */

    // Splits where there is an arithmetic
    bool boolContainAdd = false;
    List<String> lstFunction = [];
    if (function.contains('+')) {
      boolContainAdd = true;
      lstFunction = function.split('+');
    } else {
      lstFunction = function.split('-');
    }

    /* 
    In the case where the user puts '5(t^2+3)+t(t)+3t', where the last 3t,
    is also considered a constant and will not be 3t^1. So let's call a 
    friend.
    */
    AddCoefficientOne addCoefficientOne = AddCoefficientOne();
    AddExponentOne addExponentOne = AddExponentOne();
    AddExponentZero addExponentZero = AddExponentZero();
    for (int i = 0; i < lstFunction.length; i++) {
      String? updatedFunc = addCoefficientOne.addCoefficientOne(lstFunction[i]);
      updatedFunc = addExponentOne.addExponentOne(updatedFunc);
      updatedFunc = addExponentZero.addExponentZero(updatedFunc);
      if (updatedFunc != null) {
        lstFunction[i] = updatedFunc;
      }
    }

    // Add them into a dictionary, those with same exponent will go together
    Map<int, List<int>> groupedTerms = {};
    for (String? term in lstFunction) {
      if (term != null && term.isNotEmpty) {
        List<String> parts = term.split("t^");
        int coefficient = int.parse(parts[0]);
        int exponent = int.parse(parts[1]);
        groupedTerms.putIfAbsent(exponent, () => []);
        groupedTerms[exponent]!.add(coefficient);
      }
    }

    // Sum of all the list<int> together
    Map<int, int> updatedTerms = {};
    groupedTerms.forEach((exponent, coefficients) {
      if (coefficients.length > 1) {
        updatedTerms[exponent] = coefficients.reduce((a, b) => a + b);
      } else {
        updatedTerms[exponent] = coefficients[0];
      }
    });

    // Convert dict<int, int> to <int>t^<int>, and remove redundant exponents
    List<String> formattedTerms = updatedTerms.entries.map((entry) {
      if (entry.key == 0) {
        return "${entry.value}";
      } else if (entry.key == 1) {
        return "${entry.value}t";
      }
      return "${entry.value}t^${entry.key}";
    }).toList();

    // Join the terms with " + "
    if (boolContainAdd) {
      return formattedTerms.join('+');
    }
    return formattedTerms.join('-');
  }
}
