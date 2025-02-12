class ContainTrigo {
  bool containTrigo(String equation){
    if ((equation.contains('sin')) || equation.contains('cos')){
      return true;
    }return false;
  }
}