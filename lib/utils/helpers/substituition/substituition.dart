class Substituition {
  bool purelyNumerical(String eqn) {
    /*
    To check if the given equation is purely numerical.

    Parameters:
      @params eqn: The equation to be checked.
      @type eqn: String
    
    Return:
      @return bool: The boolean value of the check.
      @type bool
    */
    return RegExp(r'^\d+(\.\d+)?$').hasMatch(eqn);
  }

  Map<String, List<String>> substitued(Map<String, List<String>> mapTermWise) {
    /*
    Essentially, this part, we trying to change all the variables 
    in the dictionary's value (list) into t.
    
    mapTermWise: {sin(t): [5sin(t), +6sin(t)], t: [+3t]}
    mapTermWise: {sin(t): [5t, +6t], t: [+3t]}

    Parameters:
      @params mapTermWise: The dictionary of like terms.
      @type mapTermWise: Map<String, List<String>>
    
    Return:
      @return mapTermWise: The dictionary of like terms with substituted variables.
      @type mapTermWise: Map<String, List<String>>
    */

    // Initialising the variables.
    String term = '';

    // Iterate over the dictionary.
    mapTermWise.forEach((key, valueList) {
      // Iterate over the list
      for (int i = 0; i < valueList.length; i++) {
        term = valueList[i];

        // Remove extra + or - from the term to prevent errors.
        if (term.contains('+')) {
          valueList[i] = term.replaceAll('+', '');
        }

        if (term.contains('-')) {
          valueList[i] = term.replaceAll('-', '');
        }

        // Check if the term is purely numerical.
        if (purelyNumerical(valueList[i]) == false) {
          valueList[i] = valueList[i].replaceAll(key, 't');
        }
      }
    });
    return mapTermWise;
  }
}
