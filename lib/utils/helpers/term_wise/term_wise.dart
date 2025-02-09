import 'package:electro_magnetism_solver/utils/handlers/simplify/simplify.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_arithmetic.dart';
import 'package:flutter/material.dart';

class TermWise {
  bool purelyNumerical(String eqn) {
    return RegExp(r'^\d+(\.\d+)?$').hasMatch(eqn); // Supports decimals too
  }

  dynamic termWise(String? wholeEquation) {
    Map<String, List<String>> groupedTerms = {};

    /* If empty equation */
    if (wholeEquation == null || wholeEquation.isEmpty) {
      return {};
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

      /* Regex to extract coefficient and variable part */
RegExp regex = RegExp(r'^([+\-]?\d*\.?\d*)([a-zA-Z](?:[a-zA-Z]|\([^\(\)]+\))*(?:\^\d+)?)$');      Match? match = regex.firstMatch(term);

      if (match != null) {
        String key = match.group(2)!;
        String coefficient = match.group(1)!.isEmpty ? "1" : match.group(1)!;

        /* Keep parentheses for functions like sin(t), cos(t), ln(t) */
        if (!RegExp(r'(sin|cos|ln)').hasMatch(key)) {
          key = key.replaceAll(RegExp(r'[()]'), '');
        }

        groupedTerms.putIfAbsent(key, () => []).add('$coefficient$key');
      }
    }

    debugPrint("groupedTerms: $groupedTerms");
    return groupedTerms;
  }
}