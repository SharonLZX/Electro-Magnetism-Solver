import '../../core/constants/constants.dart';

class SubscriptManager {
  List<String> subscriptFormatting(List<String> result) {
    List<String> formattedResult = [];
    
    for (String individualStep in result) {
      individualStep = individualStep.replaceAllMapped(
        RegExp(r'([a-zA-Z])(\d)(?!\d)'),
        (match) => '${match[1]}${convertToSubscript(match[2]!)}',
        );

      individualStep = individualStep.replaceAllMapped(
        RegExp(r'\^(\d)'),
        (match) => convertToSuperscript(match[1]!),
      );

      formattedResult.add(individualStep);
    }

    return formattedResult;
  }

  String convertToSubscript(String inpSub) {
    return inpSub.split('').map((char){
      int index = int.parse(char);
      return subscriptDigits[index];
    }).join();
  }

  String convertToSuperscript(String inpSup) {
    return inpSup.split('').map((char){
      int index = int.parse(char);
      return superscriptDigits[index];
    }).join();
  }
}
