class ReplaceX {
  String replaceX(String variable, String deriveThis) {
    var newEquation = variable.replaceFirst('x', deriveThis);
    return newEquation;
  }
}