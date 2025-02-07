class AddCoefficientOne {
  String? addCoefficientOne(String? eqn) {
    // Add '1' if doesn't contain any coefficient
    if (eqn == null) {
      throw ArgumentError('Argument cannot be null');
    }

    /* 
  Only time we will need to put 1 is when,
  there is nothing infront of t. 
  */
    RegExp regExp = RegExp(r'^t');
    if (regExp.hasMatch(eqn)) {
      return "1$eqn";
    }
    return eqn;
  }
}
