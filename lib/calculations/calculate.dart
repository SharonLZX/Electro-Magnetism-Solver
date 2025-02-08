import 'package:electro_magnetism_solver/calculations/simplification.dart';
import 'package:electro_magnetism_solver/utils/handlers/differentiation/differentiation_handler.dart';
import 'package:electro_magnetism_solver/utils/helpers/substituition/substituition.dart';
import 'package:electro_magnetism_solver/utils/helpers/term_wise/term_wise.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/calculations/integration.dart';
import 'package:electro_magnetism_solver/utils/helpers/formatters/exp_to_latex.dart';

class Calculate {
  Integration integrationHandler = Integration();
  Parser parser = Parser();
  ExpToLatex expToLatex = ExpToLatex();

  String plane_1 = "";
  String plane_2 = "";

  String planeFormatting(String plane) {
    List<String> planeLst = plane.split('');
    plane_1 = planeLst[0];
    plane_2 = planeLst[1];
    return "d${plane_1}d$plane_2";
  }

  List<String> magFlxIntgSymb(B, bd, S, sd, areaElm) {
    List<String> result = ["Formula: Φm = ∫∫B·dS"];
    result.add('∫∫($B)($bd)·($areaElm)($sd)');
    if (!dependent(B)) {
      result.add('∫($B∫d$plane_1)d$plane_2');
      result.add('∫($B·$plane_1)d$plane_2');
      result.add('$plane_1${B}d$plane_2');
      result.add('$plane_1${integrationHandler.integrationManager(B)}');
      return result;
    }

    if (bd != sd) {
      result.add('0 (BD and SD are orthogonal)');
      return result;
    }

    result.add('∫∫$B$areaElm');
    if (!xyzPlane.any(B.contains)) {
      result.add('$B∫∫$areaElm');
      return result;
    }

    B = integrationHandler.integrationManager(B);
    result.add('$B${plane_1.replaceAll('d', '')}');
    result.add('$B$S');
    return result;
  }

  bool dependent(String B) {
    if (['x', 'y', 'z']
        .any((axis) => B.contains(axis) && plane_1.contains(axis))) {
      return true;
    }
    return false;
  }

  dynamic induceEMFLoop(String chgFlux) {
    // Induced EMF in a loop is given by E = -dΦB/dt

    // Splits the terms,
    TermWise termWise = TermWise();
    Map<String, List<String>> mapTermWise = termWise.termWise(chgFlux);

    // Substitution complex terms like 5sin(t^3) to 5t
    Substituition substituition = Substituition();
    mapTermWise = substituition.substitued(mapTermWise);

    String result;
    List<String> lstSubstitute = [];
    Simplification simplification = Simplification();
    mapTermWise.forEach((key, valueList) {
      result = simplification.simplify(valueList.join(''));
      result = simplification.combineLikeTerms(result);
      lstSubstitute.add(result.replaceAll('t', key));
    });

    // Insert a * if there is a product rule.
    for (int i = 0; i < lstSubstitute.length; i++) {
      if (lstSubstitute[i].contains(')(')) {
        lstSubstitute[i] = lstSubstitute[i].replaceAll(')(', ')*(');
      }
    }

    // TODO: Assuming all plus, which is wrong.
    String postSubstitution = lstSubstitute.join('+');
    debugPrint(lstSubstitute.toString());
    return postSubstitution;

    DiffHandler diffHandler = DiffHandler();
    return diffHandler.diffHandler(postSubstitution);
  }
}
