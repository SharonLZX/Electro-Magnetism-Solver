import '../../core/constants.dart';

class SubscriptManager {
  List<String> subscriptFormatting(List<String> result) {
    List<String> formattedResult = [];
    // Replace variables with subscripts (e.g., c1 -> c₁)
    String indvstep = "";

    for (String indvStep in result) {
      indvStep = indvStep.replaceAllMapped(
        RegExp(r'([a-zA-Z])(\d)(?!\d)'),
        (match) => '${match[1]}${convertToSubscript(match[2]!)}',
        );

      // Replace superscripts (e.g., ^2 -> ²)
      indvstep = indvStep.replaceAllMapped(
        RegExp(r'\^(\d)'),
        (match) => convertToSuperscript(match[1]!),
      );

      formattedResult.add(indvstep);
    }

    return formattedResult;
  }

  // Helper function to convert numbers to subscript
  String convertToSubscript(String inpSub) {
    return inpSub.split('').map((char){
      int index = int.parse(char);
      return subscriptDigits[index];
    }).join();
  }

  // Helper function to convert numbers to superscript
  String convertToSuperscript(String inpSup) {
    return inpSup.split('').map((char){
      int index = int.parse(char);
      return superscriptDigits[index];
    }).join();
  }
}
