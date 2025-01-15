import 'package:electro_magnetism_solver/integration_rules.dart';

class CalcManager {
  IntegrationRules integrationHandler = IntegrationRules();

  String plane1 = "";
  String plane2 = "";

  String calcPlane(String p) {
    return planeSelection(p);
  }

  String planeSelection(String plane) {
    List<String> planelist = plane.split('');
    plane1 = planelist[0];
    plane2 = planelist[1];
    String areaElement = "d${plane1}d$plane2";
    return areaElement;
  }

  List<String> magFlxIntgSymb(B, bd, S, sd, areaElm) {
    List<String> result = ["Formula: Φm = ∫∫B·dS"];

    result.add('∫∫($B)($bd)·($areaElm)($sd)');
    if (dependent(B)) {
      if (bd == sd) {
        result.add('∫∫$B$areaElm');
        if (!B.contains("(x)") && !B.contains("(y)") && !B.contains('(z)')) {
          result.add('$B∫∫$areaElm');
        } else {
          B = integrationHandler.integrationManager(B);
          result.add('$B${plane2.replaceAll('d', '')}');
          result.add('$B$S');
        }
      } else {
        result.add('0 (BD and SD are orthogonal)');
      }
    } else {
      result.add('∫($B∫d$plane1)d$plane2');
      result.add('∫($B·$plane1)d$plane2');
      result.add('$plane1∫${B}d$plane2');
      result.add('$plane1·${integrationHandler.integrationManager(B)}');
    }
    return result;
  }

  bool dependent(B) {
    if ((B.contains('x') && plane1.contains('x')) |
        (B.contains('y') && plane1.contains('y')) |
        (B.contains('z') && plane1.contains('z'))) {
      return true;
    }
    return false;
  }

  String mulSymb(term_1, term_2) {
    // Not used in main.dart
    if (term_1.trim() == "0" || term_2.trim() == "0") {
      return "0";
    } else if (term_1.trim() == "1") {
      return term_2.trim();
    } else {
      return term_1.trim();
    }
  }

  double inducedEMFLoop(chgFlux, chgTime) {
    return chgFlux != 0 ? -(chgFlux / chgTime) : 0.0;
  }
}
