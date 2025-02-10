import 'package:electro_magnetism_solver/utils/handlers/simplify/simplify.dart';
import 'package:electro_magnetism_solver/utils/helpers/expandable/expandable.dart';
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

  dynamic termWise(String? wholeEquation) {
    Map<String, List<String>> groupedTerms = {};

    /* If empty equation */
    if (wholeEquation == null || wholeEquation.isEmpty) {
      return {};
    }

    String removeBetween(
      /*
      Remove inbetween bracket to prevent 3t(3t)
      from being read as 3t(3t) rather just read as
      3t
      */
      String input,
    ) {
      if (!input.contains('(') || !input.contains(')')) {
        return input; // Return unchanged if the delimiters are missing
      }

      String pattern = RegExp.escape('(') +
          r'[^' +
          RegExp.escape(')') +
          r']*' +
          RegExp.escape(')');
      return input.replaceAll(RegExp(pattern), '');
    }

    ExtractArithmetic extractArithmetic = ExtractArithmetic();
    //List<String> lstSplit = extractArithmetic.extractArithmetic2(wholeEquation);

    RegExp regExp = RegExp(r'(?=[+\-](?![^\(\)]*\)))');
    List<String> lstSplit = wholeEquation.split(regExp);
    for (String term in lstSplit) {
      term = term.trim();

      /* Skip empty terms */
      if (term.isEmpty) continue;

      /* If purely numerical, no need to process further */
      if (purelyNumerical(term)) {
        groupedTerms.putIfAbsent(term, () => []).add(term);
        continue;
      }

      /* Handle inner grouped terms first */
      String? innerTerms = extractArithmetic.extractGroupedTerm(term);
      if (innerTerms != null && innerTerms != 't') {
        SimplifyHandler simplifyHandler = SimplifyHandler();
        dynamic simplifiedTerm = simplifyHandler.simplifyHandler(innerTerms);
        term = term.replaceAll(innerTerms, simplifiedTerm);
      }

      //Expandable expandable = Expandable();
      /* Regex to extract coefficient and variable part */
      RegExp regex = RegExp(
          r'^([+\-]?\d*\.?\d*)([a-zA-Z](?:[a-zA-Z]|\([^\(\)]+\))*(?:\^\d+)?)$');

      String newTerm = removeBetween(term);
      Match? match = regex.firstMatch(term);

      if (match != null) {
        String key = match.group(2)!;
        String coefficient = match.group(1)!.isEmpty ? "1" : match.group(1)!;

        /* Ensure parentheses are preserved when part of an expression */
        if (!RegExp(r'^(sin|cos|ln)\(.*\)$').hasMatch(key) &&
            !key.contains('(')) {
          key = key.replaceAll(RegExp(r'[()]'),
              ''); // Remove only if it's NOT enclosing an expression
        }
        groupedTerms.putIfAbsent(key, () => []).add('$coefficient$key');
      }
    }

    return groupedTerms;
  }
}
