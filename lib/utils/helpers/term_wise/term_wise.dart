import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/utils/handlers/simplify/simplify.dart';
import 'package:electro_magnetism_solver/utils/helpers/simplify/extract_arithmetic.dart';

class TermWise {
  bool purelyNumerical(String eqn) {
    /*
    Checks if the given equation is purely numerical whilst taking into account
    cases where a equation wasn't splitted properly, and are tagged with an
    arithmetic operator.

    Parameters:
      @params eqn: The equation to be checked.
      @type eqn: String
    
    Return:
      @return: True if the equation is purely numerical, else False.
      @type: Boolean
    */
    
    // Removes arithmetic operators if exists (i.e. +5 -> 5, etc.).
    if (eqn.contains('+')) {
      eqn = eqn.replaceAll('+', '');
    }

    if (eqn.contains('-')) {
      eqn = eqn.replaceAll('-', '');
    }

    return RegExp(r'^\d+(\.\d+)?$').hasMatch(eqn);
  }

  dynamic prepareRegEx(String input) {
    /*
    Attemps to remove certain bracketed expressions while considering trigonometric functions
    with brackets. These regex expressions are here because I need to create a work-around
    to remove the brackets in the equation. The reason for this is because of the result that
    we are trying to achieve, with regards to how we determine what are like terms, taking into
    account exotic expressions e.g. 5t(5sin(t)), etc.

    Example: 


    Parameters:
      @params input: The equation to be checked for brackets.
      @type input: String
    
    Result:
      @return: The equation with the brackets removed or false if no brackets are found.
      @type Union[String, False]
    */

    String pattern = '';
    String tempInput = '';

    if (!input.contains('sin') && !input.contains('cos')) {
      // Doesn't contain trigometric functions, therefore either a constant, variable or expressions
      // with multipliers.
      if (input.contains('(') && input.contains(')')) {
        // Expression containing brackets, (e.g. 5t(5t), etc.).
        // If the input contains both ( and ), it removes everything inside and including the parentheses.
        pattern = RegExp.escape('(') +
            r'[^' +
            RegExp.escape(')') +
            r']*' +
            RegExp.escape(')');
        return input.replaceAll(RegExp(pattern), '');
      }
      // No brackets found, (e.g. 5t, 5t+5, etc.).
      return false;
    }

    // Expressions contains trigo functions.
    // Removes sin(...) & cos(...) from equation.
    tempInput =
        input.replaceAllMapped(RegExp(r'(sin|cos)\([^()]*\)'), (match) => '');

    // If the equation still contains brackets, remove everything inside and including the parentheses.
    if (tempInput.contains('(') || tempInput.contains(')')) {
      return tempInput.replaceAllMapped(RegExp(r'\([^()]*\)'), (match) => '');
    }

    return false;
  }

  dynamic termWise(String? wholeEquation) {
    /*
    Using regex to identify the like terms in the given equation (wholeEquation) and
    sort them into their respective key-value pair in a dictionary (groupedTerms).

    Parameters:
      @params wholeEquation: The equation to be split into terms.
      @type wholeEquation: String

    Return:
      @return groupedTerms: The terms grouped into a dictionary or an empty dictionary.
      @type Union[Map<String, List<String>>, {}]
    */

    // Creating the instances of the classes.
    SimplifyHandler simplifyHandler = SimplifyHandler();
    ExtractArithmetic extractArithmetic = ExtractArithmetic();

    // Initialising the variables.
    String? innerTerms = '';
    dynamic newTerm;
    dynamic simplifiedTerm;
    List<String> lstSplit = [];
    Map<String, List<String>> groupedTerms = {};

    // Check if the equation is empty.
    if (wholeEquation == null || wholeEquation.isEmpty) {
      return {};
    }

    // Split the equation at points where arithmetic operators are found. But ignores '+' and '-'
    // within parentheses. Retaining expressions within brackets.
    lstSplit = wholeEquation.split(splitArithmetics);

    // Iterate over the split terms (lstSplit).
    for (String term in lstSplit) {
      // Remove any leading or trailing whitespaces.
      term = term.trim();

      //Skip empty terms
      if (term.isEmpty) continue;

      // Checks if term is purely numerical
      if (purelyNumerical(term)) {
        // Create new key-value pair if term not found, else append to existing key
        groupedTerms
            .putIfAbsent(term, () => [])
            .add(term); // PROBLEM: Constants aren't grouped together.
        continue;
      }

      // Handle inner grouped terms first
      innerTerms = extractArithmetic.extractGroupedTerm(term);
      if (innerTerms != null && innerTerms != 't') {
        
        // Recursively simplify inner terms first
        simplifiedTerm = simplifyHandler.simplifyHandler(innerTerms);
        term = term.replaceAll(innerTerms, simplifiedTerm);
      }

      /*
      Over here we are attempting to prepare the regex such that we can execute
      a proper 'regex.firstMatch' on the proper term. Since Regex is a bit tricky
      to work with, we need to ensure that we are able to clean and tweak the term
      such that we can get the proper match. 
      */
      newTerm = prepareRegEx(term);

      Match match;
      RegExp regex = extractCoeffVariable;
      if (newTerm == false) {
        /*
        If brackets not removed, means that no work around was needed and the
        Regex can be performed on the original expression. It usually is only
        needed for lesser complex expressions (e.g. 5t, 5t+5, etc.).
        */
        match = regex.firstMatch(term) as Match; 
      } else {
        /*
        If brackets were removed, means that a work around was needed and the
        Regex must be performed on the new expression. It usually is only
        needed for more complex expressions (e.g. 5t(5t), etc.).
        */
        match = regex.firstMatch(newTerm) as Match; 
      }

      // Extracts the key from the matched term.
      String key = match.group(2)!;

      // Remove parentheses if key is not a trigonometric function
      if (!RegExp(r'^(sin|cos|ln)\(.*\)$').hasMatch(key) &&
          !key.contains('(')) {
        key = key.replaceAll(RegExp(r'[()]'), '');
      }

      // Create new key-value pair if term not found, else append to existing key
      groupedTerms.putIfAbsent(key, () => []).add(term);
    }

    return groupedTerms;
  }
}
