import 'package:electro_magnetism_solver/utils/handlers/multiplication/implicit_exponent.dart';

class ExtractParents {
  String extractParents(String? multiplier, String argument) {
    /* 
    Every argument here will definitely involve a bracket, i.e. multiplier(argument),
    e.g. 5(t) or 5(t+...+...). So we remove the bracket inorder to access the argument.

    Parameters:
      @params multiplier: The multiplier of the argument.
      @type multiplier: String
      @params argument: The argument to be extracted.
      @type argument: String
    
    Return:
      @return String: The extracted argument.
    */

    // Creating the instance of the class.
    ImplicitExponent implicitExponent = ImplicitExponent();
    
    // Initialising the variables.
    List<String?> lstResult = [];
    List<String> lstArguments = [];

    RegExp regExpBrac = RegExp(r'[\[\](){}]');
    argument = argument.replaceAll(regExpBrac, ''); // Remove all brackets.

    // Now we need to check whether the argument contains a + or - and split accrodingly.
    RegExp regExp = RegExp(r'[+\-*/]');
    if (regExp.hasMatch(argument)) {
      lstArguments = argument.split(regExp);
    } else {
      lstArguments = [argument];
    }

    /*
    Now that our original expression has been cleaned (i.e. No brackets, and/or arithmetic symbols)
    we can now convert each argument into a unsimplified form:
      1. t    -> 1t^1
      2. 5    -> 5t^0
      3. 5t   -> 5t^1
      4. 5t^2 -> 5t^2
    */

    for (String args in lstArguments) {
      String? result = implicitExponent.implicitExponent(multiplier, args);
      
      // If the result is null, then we can add back the original argument.  
      if (result == null){
        lstResult.add(args); 
      }

      // Otherwise, we can add the result.
      lstResult.add(result);
    }

    // ASSUMPTION: The expression is in the form of addition/or subtraction. Any combination of both,
    // will show an error.
    if (argument.contains('+')) {
      return lstResult.join('+');
    }else if (argument.contains('-')){
      return lstResult.join('-');
    }
    return lstResult.join('');
  }
}
