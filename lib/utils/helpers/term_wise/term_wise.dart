import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/utils/handlers/simplify/simplify.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_arithmetic.dart';
import 'package:flutter/material.dart';

class TermWise {
  bool purelyNumerical(String eqn) {
    /*
    The reason for this is because if the constant, is
    behind a variable (i.e. 5t+5), 'term' becomes, '+5'
    which isn't 'purely' numerical. So we must remove it.
    */
    if (eqn.contains('+')) {
      eqn = eqn.replaceAll('+', '');
    }

    if (eqn.contains('-')) {
      eqn = eqn.replaceAll('-', '');
    }

    return RegExp(r'^\d+(\.\d+)?$').hasMatch(eqn); // Supports decimals too
  }

  dynamic removeBetween(String input) {
    /*
    In this function, we need to be able to do 
    a few things. Identify whether or not the 
    input brackets, if yes, are trigo present,
    and if yes again, then are there multipliers
    (i.e. 5(sin(t)))
    */
    if (!input.contains('sin') && !input.contains('cos')) {
      if (input.contains('(') && input.contains(')')) {
        String pattern = RegExp.escape('(') +
            r'[^' +
            RegExp.escape(')') +
            r']*' +
            RegExp.escape(')');
        return input.replaceAll(RegExp(pattern), '');
      }
      return false;
    }

    /*
    Contains trigo
    I've tried a number of regex(s) to sort whether
    there exists a bracket outside the sin or cos but
    to no avail. So we'll simply use a work-around, by
    completely removing everything in between sin(...)
    and cos(...) (i.e. 5t(5cos(t)) -> 5t(5) ).
    
    This works because we only need to check whether
    there are any existing brackets left
    */
    String tempInput =
        input.replaceAllMapped(RegExp(r'(sin|cos)\([^()]*\)'), (match) => '');
    if (tempInput.contains('(') || tempInput.contains(')')) {
      // Contains extra brackets, so we remove everything again.
      return tempInput.replaceAllMapped(RegExp(r'\([^()]*\)'), (match) => '');
    }
    return false;
  }

  dynamic termWise(String? wholeEquation) {
    if (wholeEquation == null || wholeEquation.isEmpty) {
      return {}; // Ignore empty numbers
    }

    Map<String, List<String>> groupedTerms = {};
    List<String> lstSplit = wholeEquation.split(splitArithmetics);
    for (String term in lstSplit) {
      term = term.trim();
      if (term.isEmpty) continue; // Skip empty terms
      if (purelyNumerical(term)) {
        groupedTerms.putIfAbsent(term, () => []).add(term); // Skip numbers
        continue;
      }

      // Handle inner grouped terms first
      ExtractArithmetic extractArithmetic = ExtractArithmetic();
      String? innerTerms = extractArithmetic.extractGroupedTerm(term);
      if (innerTerms != null && innerTerms != 't') {
        SimplifyHandler simplifyHandler = SimplifyHandler();
        dynamic simplifiedTerm = simplifyHandler.simplifyHandler(innerTerms);
        term = term.replaceAll(innerTerms, simplifiedTerm);
      }

      // Regex to extract coefficient and variable part
      Match match;
      RegExp regex = extractCoeffVariable;
      dynamic newTerm = removeBetween(term);
      if (newTerm == false) {
        match = regex.firstMatch(term) as Match; // If brackets not removed
      } else {
        match = regex.firstMatch(newTerm) as Match; // If brackets were removed
      }
      String key = match.group(2)!;

      // Ensure parentheses are preserved when part of an expression
      if (!RegExp(r'^(sin|cos|ln)\(.*\)$').hasMatch(key) &&
          !key.contains('(')) {
        key = key.replaceAll(RegExp(r'[()]'),
            ''); // Remove only if it's NOT enclosing an expression
      }
      groupedTerms.putIfAbsent(key, () => []).add(term);
    }

    return groupedTerms;
  }
}
