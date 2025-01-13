import 'constants.dart';

class SubscriptManager {
  List<String> subscriptFormatting(List<String> result) {
    List<String> formattedResult = [];
    // Replace variables with subscripts (e.g., c1 -> c₁)

    for (String indvStep in result) {
      indvStep = indvStep.replaceAllMapped(
        RegExp(r'([a-zA-Z])(\d+)'),
        (match) => '${match[1]}${convertToSubscript(match[2]!)}',
      );

      // Replace superscripts (e.g., ^2 -> ²)
      indvStep = indvStep.replaceAllMapped(
        RegExp(r'\^(\d)'),
        (match) => convertToSuperscript(match[1]!),
      );

      formattedResult.add(indvStep);
    }

    return formattedResult;
  }

  // Helper function to convert numbers to subscript
  String convertToSubscript(String number) {
    return number.split('').map((digit) => subscriptDigits[int.parse(digit)]).join('');
  }

  // Helper function to convert numbers to superscript
  String convertToSuperscript(String number) {
    return number.split('').map((digit) => superscriptDigits[int.parse(digit)]).join('');
  }
}
