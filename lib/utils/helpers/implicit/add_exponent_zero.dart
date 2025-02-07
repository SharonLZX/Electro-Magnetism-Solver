
class AddExponentZero {
  String? addExponentZero(String? eqn) {
    // Add '^0' if eqn is constant
    if (eqn == null) {
      throw ArgumentError('Argument cannot be null');
    }

    RegExp regExp = RegExp(r'^\d+$');
    if (regExp.hasMatch(eqn)) {
      return "${eqn}t^0";
    }
    return eqn;
  }
}
