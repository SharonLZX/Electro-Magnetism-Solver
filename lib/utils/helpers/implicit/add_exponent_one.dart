
class AddExponentOne {

String? addExponentOne(String? eqn) {
    // Add '^1' if doesn't contain any exponent
    if (eqn == null) {
      throw ArgumentError('Argument cannot be null');
    }

    RegExp regExp = RegExp(r'(?=.*t)(?!.*\^)');
    if (regExp.hasMatch(eqn)) {
      return "$eqn^1";
    }
    return eqn;
  }
}