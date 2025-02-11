import 'package:electro_magnetism_solver/utils/handlers/multiplication/implicit_exponent.dart';

class ExtractParents {
  String extractParents(String? multiplier, String argument) {
    /* 
  Every argument here will definitely involve a bracket, 
  i.e multiplier(argument) 5x. So we remove the bracket
  inorder to access the argument.
  */

    List<String?> lstResult = [];
    List<String> lstArguments = [];
    RegExp regExpBrac = RegExp(r'[\[\](){}]');
    argument = argument.replaceAll(regExpBrac, '');

    /*
  Now we need to check whether the argument contains a
  + or - and split accrodingly.
  */
    RegExp regExp = RegExp(r'[+\-*/]');
    if (regExp.hasMatch(argument)) {
      lstArguments = argument.split(regExp);
    } else {
      lstArguments = [argument];
    }

    /*
  Now we're ready to expand the multiplier and argument.
  */
    ImplicitExponent implicitExponent = ImplicitExponent();
    for (String args in lstArguments) {
      lstResult.add(implicitExponent.implicitExponent(multiplier, args));
    }
    /*
  Only work for argument that contain the same arithmetic,
  meaning, arg: 3(t+...+...) will work, but 3(t+...-...)
  won't work, because we're assuming with.join('+')/.join('-')
  that all the symbols are of the same kind.
  */
    if (argument.contains('+')) {
      return lstResult.join('+');
    }
    return lstResult.join('-');
  }
}
