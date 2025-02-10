

class IsNumeric {
  bool isNum(String str) {
    return int.tryParse(str) != null;
  }
}