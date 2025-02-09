
class Substituition {
  Map<String, List<String>> substitued(Map<String, List<String>> mapTermWise) {
    bool purelyNumerical(String eqn) {
      if (eqn.contains("+")) {
        eqn = eqn.replaceAll('+', '');
      } else if (eqn.contains("-")) {
        eqn = eqn.replaceAll('-', '');
      }
      return RegExp(r'^\d+$').hasMatch(eqn);
    }

    mapTermWise.forEach((key, valueList) {
      for (int i = 0; i < valueList.length; i++) {
        if (purelyNumerical(valueList[i]) == true) {
          // Numerical, don't need change anything.
          continue;
        } else {
          valueList[i] = valueList[i].replaceAll(key, 't');
        }
      }
    });

    return mapTermWise;
  }
}
