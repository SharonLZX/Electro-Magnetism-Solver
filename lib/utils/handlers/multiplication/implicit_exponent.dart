import 'package:electro_magnetism_solver/utils/handlers/multiplication/multiplication.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_coefficient_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_exponent_one.dart';
import 'package:electro_magnetism_solver/utils/helpers/implicit/add_exponent_zero.dart';
import 'package:electro_magnetism_solver/utils/helpers/trigo/contain_trigo.dart';

class ImplicitExponent {
  String? implicitExponent(String? multiplier, String argument) {
    /*
    Now that we're expanding the multiplier and argument,
    each bracket can contain one of these 4 kinds of equation,

    1) Constant (i.e. 5x^0=5, etc.)
    2) Coeff w variable (i.e. 5x^1=5x, etc.)
    3) Variable w exponent (i.e. x^2, etc.)
    4) Coeff w variable & exponent (i.e. 5x^2, etc.) 
    5) trigo variations

    That means that if we do not do proper planning, we will
    have to take into account a lot of variations. So, we need
    to take a smarter approach.

    SOLUTION:
    All equations will include a variable, either to the power
    of zero or 1, as well as a coefficient of 1 is required.
    */

    // Creating the instance of the class.
    ContainTrigo containTrigo = ContainTrigo();
    Expansion expansion = Expansion();
    AddCoefficientOne addCoefficientOne = AddCoefficientOne();
    AddExponentOne addExponentOne = AddExponentOne();
    AddExponentZero addExponentZero = AddExponentZero();

    // Initialising the variables.
    List<String?> lstMultiplierArgument = [];

    // Check if multiplier is null, if so, return null.
    if (multiplier == null) {
      return null;
    }

    // Check if multiplier or argument contain trigo, if so, return null.
    if (containTrigo.containTrigo(multiplier) ||
        containTrigo.containTrigo(argument)) {
      return null;
    }

    // Add multiplier and argument to the list.
    lstMultiplierArgument.add(multiplier);
    lstMultiplierArgument.add(argument);

    // Iterate over the list and change the multiplier and argument.
    for (int i = 0; i < 2; i++) {
      var updatedEqn =
          addCoefficientOne.addCoefficientOne(lstMultiplierArgument[i]);
      updatedEqn = addExponentOne.addExponentOne(updatedEqn);
      updatedEqn = addExponentZero.addExponentZero(updatedEqn);

      lstMultiplierArgument[i] = updatedEqn;
    }

    // Return expression of the multiplier performing an expansion over the argument
    return expansion.expansion(lstMultiplierArgument);
  }
}
