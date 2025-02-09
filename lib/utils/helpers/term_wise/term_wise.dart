import 'package:electro_magnetism_solver/utils/handlers/simplify/simplify.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_arithmetic.dart';
import 'package:flutter/material.dart';

class TermWise {
  /*
  Purpose:
  Convert "3x+4x-5sin(t)+2cos(t)sin(t)+7sin(t)" to
  {x: [3x, +4x], 
  sin(t): [-5sin(t), +7sin(t)],
  cos(t)sin(t): [+2cos(t)sin(t)]}
  */

  bool purelyNumerical(String eqn) {
    return RegExp(r'^\d+$').hasMatch(eqn);
  }

  dynamic termWise(String? wholeEquation) {
    if (wholeEquation == null || wholeEquation.isEmpty) {
      return {};
    }

    ExtractArithmetic extractArithmetic = ExtractArithmetic();
    List<String> lstSplit = extractArithmetic.extractArithmetic2(wholeEquation);
    Map<String, List<String>> groupedTerms = {};

    for (String term in lstSplit) {
      term = term.trim();
      if (term.isEmpty) continue;

      if (purelyNumerical(term) == true) {
        // Since purley numerical, no point to do anything about it.
        groupedTerms.putIfAbsent(term, () => []).add(term);
        continue;
      }

      String? innerTerms = extractArithmetic.extractGroupedTerm(term);
      if (innerTerms != null && innerTerms != 't') {
        /* 
        Not null means, there is a inner term. Like, 5t(5t+3),
        5t+3 is the inner term. But 5t(t)
        */
        SimplifyHandler simplifyHandler = SimplifyHandler();
        dynamic simplifiedTerm = simplifyHandler.simplifyHandler(innerTerms);
        term = term.replaceAll(innerTerms, simplifiedTerm);
      }

      RegExp regex = RegExp(r'^([+\-]?\d*\.*\d*)([a-zA-Z()^0-9]+.*)$');
      Match? match = regex.firstMatch(term);
      if (match != null) {
        String coefficient = (match.group(1) == null || match.group(1)!.isEmpty)
            ? "1"
            : match.group(1)!;

        String key =
            match.group(2)!; // Variable part (e.g., sin(t), cos(t)sin(t))
        
        // If we don't have this bool check, then we'll remove away cos, sin,
        // ln's brackets.
        bool containsTrigOrLn = false;
        if (RegExp(r'(sin|cos|ln)').hasMatch(key)) {
          containsTrigOrLn = true;
        }

        if (containsTrigOrLn == false) {
          key = key.replaceAll(RegExp(r'[()]'), '');
        }
        groupedTerms.putIfAbsent(key, () => []).add('$coefficient$key');
      }
    }

    debugPrint("groupedTerms: $groupedTerms");
    return groupedTerms;
  }
}
