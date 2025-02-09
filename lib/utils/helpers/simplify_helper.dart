class Simplification_mini {
  dynamic simplify(String? result) {
    if (result != null && result.contains('-')) {
      result = result.replaceFirst('-', '');
      result = "-$result";
    }
    return result;
  }
  
  dynamic simplifyEnd(String result){
    result = result.replaceFirst('+-', '-');
    return result;
  }
}