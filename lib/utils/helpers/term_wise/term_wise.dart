import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_arithmetic.dart';

class TermWise {
  Map<String, List<String>> termWise(String? wholeEquation) {
    if (wholeEquation == null || wholeEquation.isEmpty) {
      return {};
    }

    ExtractArithmetic extractArithmetic = ExtractArithmetic();
    List<String> lstSplit = extractArithmetic.extractArithmetic2(wholeEquation);
    Map<String, List<String>> groupedTerms = {};

    for (String term in lstSplit) {
      term = term.trim();
      if (term.isEmpty) continue;
      RegExp regex = RegExp(r'^([+\-]?\d*\.*\d*)([a-zA-Z()^0-9]+.*)$');
      Match? match = regex.firstMatch(term);

      if (match != null) {
        String coefficient = match.group(1)!.isEmpty ? '1' : match.group(1)!;
        String key =
            match.group(2)!; // Variable part (e.g., sin(t), cos(t)sin(t))

        groupedTerms.putIfAbsent(key, () => []).add('$coefficient$key');
      }
    }
    return groupedTerms;
  }
}
