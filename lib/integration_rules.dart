class IntegrationRules {
  List<String> funcList = []; // Contains trig + arg.

  String integrationManager(func) {
    if (func.contains("sin") || func.contains("cos")) {
      funcList = formatFunc(func);
      func = "${trigRule(funcList[0])}(${funcList[1]})";
    }

    return func;
  }

  List<String> formatFunc(func) {
    List<String> tempList = []; // Contains trig + arg.
    RegExp regExp = RegExp(r'(\w+)\((.+)\)');
    Match? match = regExp.firstMatch(func);
    if (match != null) {
      String trigFunc = match.group(1)!;
      String arg = match.group(2)!;
      tempList.add(trigFunc);
      tempList.add(arg);
    }
    return tempList;
  }

  String trigRule(func) {
    if (func.contains("sin")) {
      func = func.replaceAll("sin", "-cos");
    } else {
      func = func.replaceAll("cos", "sin");
    }
    return func;
  }
}
