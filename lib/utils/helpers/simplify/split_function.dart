class SplitFunction {
  List<String> splitFunction(String wholeFunction) {
    /*
    Splits the function where there is a + or -
    but returns the whole string as a list of 
    size 1 if none found.
    */
    if (wholeFunction.contains('+')) {
      return wholeFunction.split('+');
    } else if (wholeFunction.contains('-')) {
      return wholeFunction.split('-');
    } else {
      return [wholeFunction];
    }
  }
}
