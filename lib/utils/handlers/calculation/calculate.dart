import 'package:electro_magnetism_solver/utils/handlers/differentiation/differentiation.dart';
import 'package:electro_magnetism_solver/utils/handlers/simplify/simplify.dart';
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

    /*if (!dependent(B)) {
      result.add('∫($B∫d$plane_1)d$plane_2');
      result.add('∫($B·$plane_1)d$plane_2');
      result.add('$plane_1${B}∫d$plane_2');
      result.add('$plane_1${integrationHandler.integrationManager(B)}');
      return result;
    }*/

    if (bd != sd) {
      result.add('0 (BD and SD are orthogonal)');
      return result;
    }

    result.add('∫∫$B$areaElm');
    bool BIndependent = !xyzPlane.any((v) => B.contains(v));

    if (BIndependent) {
      result.add('$B∫∫$areaElm');

      // Replace ∫∫dxdy/dydz/etc with user-defined surface area S
      result.add('$B·$S'); // visual step
      result.add('${B}$S'); // simplified final step
      return result;

      /*if (!xyzPlane.any(B.contains)) {
      result.add('$B∫∫$areaElm');
      return result;*/
    }

    B = integrationHandler.integrationManager(B);
    result.add('$B${plane_1.replaceAll('d', '')}');
    result.add('$B$S');
    return result;
  }

  /*bool dependent(String B) {
    if (['x', 'y', 'z']
        .any((axis) => B.contains(axis) && plane_1.contains(axis))) {
      return true;
    }
    return false;
  }*/

  dynamic inducedEMFLoop(String chgFlux) {
    try {
      SimplifyHandler simplifyHandler = SimplifyHandler();
      String postSubstitution = simplifyHandler.simplifyHandler(chgFlux);

      Differentiation differentiateHandler = Differentiation();
      List<String?> result =
          differentiateHandler.differentiate(postSubstitution);
      return result.join('+');
    } catch (e) {
      return "Can't compute";
    }
  }
}


/*Expansion expansion = Expansion();
    String strResult = result.join('');
    return expansion.combi›eLikeTerms(strResult);*/

