class CalcManager{
  String calcPlane(String p){
    return planeSelection(p);
  }

  String planeSelection(String plane) {
    List<String> planelist = plane.split('');
    String plane1 = planelist[0];
    String plane2 = planelist[1];
    String areaElement = "d$plane1 d$plane2";
    return areaElement;
  }

  List<String> magFlxIntgSymb(B, bd, S, sd, areaElm){
    List<String> result = ["Formula: Φm = ∫∫ B · dS"];
    
    result.add('∫∫ (($B)($bd)) · (($areaElm)($sd))');
    if(bd == sd){
      result.add('∫∫ ($B) ($areaElm)');
      result.add('($B) ∫∫ ($areaElm)');
      result.add('($B) * ($S)');
    } else {
      result.add('0 (BD and SD are orthogonal)');
    }
    return result;
  }

  String mulSymb(term_1, term_2){
    // Not used in main.dart
    if (term_1.trim() == "0"|| term_2.trim() == "0"){
      return "0";
    }else if (term_1.trim() == "1"){
      return term_2.trim();
    }else{
      return term_1.trim();
    }
  }

  double inducedEMFLoop(chgFlux, chgTime){
    return chgFlux != 0 ? -(chgFlux/chgTime) : 0.0;
  }
}