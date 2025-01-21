class Differentiation {
  List<String> arith = ["+", "-"];
  List<String> eqnSplitted = [];

  DiffRule diffRule = DiffRule();

  void diffHandler(String eqn) {
    bool arithCheck = arith.any((arith) => eqn.contains(arith));

    if (eqn.contains('+')){
      eqnSplitted = eqn.split('+');
      eqnSplitted.removeWhere((element) => element == '+');
      print(differentiate(eqnSplitted).join('+'));
    }

    if (eqn.contains('-')){
      eqnSplitted = eqn.split('-');
      eqnSplitted.removeWhere((element) => element == '-');
      print(differentiate(eqnSplitted).join('-'));
    }

    if (!arithCheck){
      eqnSplitted.add(eqn);
      print(differentiate(eqnSplitted));
    }

    return;
  }

  dynamic differentiate(List<String> equations){
    List<String> eSplitted = []; // Works the same as eqnSplitted.
    List<String> finalResult = [];
    List<String> pairs = [];
    List<String> arith_2 = ["*", "/"];
    for (String eqn in equations){
      bool arithCheck = arith_2.any((arith_2) => eqn.contains(arith_2));
      if (!arithCheck){
        finalResult.add(diffRule.ruleHandler(eqn));
      }else{
        if (eqn.contains('/')){
          eSplitted=eqn.split('/');
          eSplitted.removeWhere((element)=>element=='/');
        }else{
          eSplitted = eqn.split('*');
          eSplitted.removeWhere((element) => element == '*');
        }
        finalResult.add(eSplitted[1]);
        finalResult.add(diffRule.ruleHandler(eSplitted[0]));
        finalResult.add(eSplitted[0]);
        finalResult.add(diffRule.ruleHandler(eSplitted[1]));
        for (int i = 0; i < finalResult.length; i += 2) {
            pairs.add(finalResult[i] + finalResult[i + 1]);
        }
        if (eqn.contains('/')){
          return("[${pairs.join('-')}]/${eSplitted[1]}^2");
        }else{
          return(pairs.join('+'));
        }
      }
    }
    return finalResult;
  }

  void quotientRule(List<String> eqn){
   print(eqn);
  }
}

class DiffRule{
  String ruleHandler(String eqn){
    if (eqn.contains("^")){
      List<int> pow_lst = [];

      pow_lst = powRule(eqn);
      if (pow_lst[1] == 0){
        eqn = "0";
      }else if (pow_lst[1] == 1){
        eqn = "2x";
      }else{
        eqn = "${pow_lst[0]}x^${pow_lst[1]}";
      }
    }

    if (eqn.contains("sin")){
      eqn = sinRule(); //I am assuming sin/cos/ln is followed by (x) so thats why I'm predefining.
    }else if (eqn.contains("cos")){
      eqn = cosRule();
    }

    if (eqn.contains("ln")){
      eqn = lnRule();
    }
    return eqn;
  }

  List<int> powRule(String eqn){
    int pow = 0;
    int pow_minus_1 = 0;
    List<int> pow_lst = [];

    RegExp regExp = RegExp(r'\^(\d+)');
    Match? match = regExp.firstMatch(eqn);

    if(match!=null){
      pow = int.parse(match.group(1)!);
      pow_minus_1 = pow-1;

      pow_lst.add(pow);
      pow_lst.add(pow_minus_1);
    }else{
      pow_lst.add(0);
    }
    return pow_lst;
  }

  String cosRule(){
    return ("-sin(x)");
  }

  String sinRule(){
    return ("cos(x)");
  }

  String lnRule(){
    return ("1/(x)");
  }
}

void main() {
  Differentiation diff = Differentiation();
  diff.diffHandler("x^2/cos(x)"); 
}