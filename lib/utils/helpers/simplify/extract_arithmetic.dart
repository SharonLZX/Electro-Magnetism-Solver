import 'package:flutter/material.dart';

class ExtractArithmetic {
  List<String?> extractArithmetic(String func) {
    // Splits function at points where there are brackets, + or -.
    RegExp regExp = RegExp(r'([a-zA-Z0-9]+|[+\-*/^=])|\([^)]*\)');
    Iterable<Match> matches = regExp.allMatches(func);
    matches.map((match){
      return match.group(0);
    });
    return matches.map((match) {
      return match.group(0);
    }).toList();
  }

  List<String> extractArithmetic2(String func) {
    /*
    Splits function at points where there are brackets, +, -, *, /, or ^.
    But not if they are within brackets.
    */

    RegExp regExp = RegExp(r'([+\-]?\d*\.*\d*[a-zA-Z]*(?:\([^\(\)]+\))?)');
    Iterable<Match> matches = regExp.allMatches(func);
    return matches
        .map((match) => match.group(0)!.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  String? extractGroupedTerm(String func) {
    /*
    This is where we extract the unsimplified equation within two brackets.
    Example, 3t(3t+6t). We want to extract 3t+6t here.
    */
    RegExp regExp = RegExp(r'\(([^()]*)\)');
    Match? match = regExp.firstMatch(func);
    return match != null ? match.group(1):null;
  }
}
