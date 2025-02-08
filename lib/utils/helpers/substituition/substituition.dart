class Substituition {
  Map<String, List<String>> substitued(Map<String, List<String>> mapTermWise) {
    mapTermWise.forEach((key, valueList) {
      for (int i = 0; i < valueList.length; i++) {
        valueList[i] = valueList[i].replaceAll(key, 't');
      }
    });
    return mapTermWise;
  }
}
