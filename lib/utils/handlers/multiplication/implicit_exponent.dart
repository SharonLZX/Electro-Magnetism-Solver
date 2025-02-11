import 'package:electro_magnetism_solver/utils/handlers/multiplication/multiplication.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_coefficient_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_exponent_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_exponent_zero.dart';

class ImplicitExponent {
  String? implicitExponent(String? multiplier, String argument) {
    /*
    Now that we're expanding the multiplier and argument,
    each bracket can contain one of these 4 kinds of equation,

    1) Constant (i.e. 5, etc.)
    2) Coeff w variable (i.e. 5x, etc.)
    3) Variable w exponent (i.e. x^2, etc.)
    4) Coeff w variable & exponent (i.e. 5x^2, etc.) 

    That means that if we do not do proper planning, we will
    have to take into account 4*3*2*1 variations. So, we need
    to take a smarter approach.

    SOLUTION:
    All equations will include a variable, either to the power
    of zero or 1, as well as a coefficient of 1 is required.
    */

    List<String?> lstMultiplierArgument = [];
    lstMultiplierArgument.add(multiplier);
    lstMultiplierArgument.add(argument);

    AddCoefficientOne addCoefficientOne = AddCoefficientOne();
    AddExponentOne addExponentOne = AddExponentOne();
    AddExponentZero addExponentZero = AddExponentZero();
    for (int i = 0; i < 2; i++) {
      /*
      Take every variable and go for a sanity-check, before
      updating the list. 
      */
      var updatedEqn =
          addCoefficientOne.addCoefficientOne(lstMultiplierArgument[i]);
      updatedEqn = addExponentOne.addExponentOne(updatedEqn);
      updatedEqn = addExponentZero.addExponentZero(updatedEqn);
      lstMultiplierArgument[i] = updatedEqn;
    }

    Expansion expansion = Expansion();
    return expansion.expansion(lstMultiplierArgument);
  }
}
