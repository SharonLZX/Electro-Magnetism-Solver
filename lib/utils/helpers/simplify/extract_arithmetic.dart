class ExtractArithmetic {
  List<String?> extractArithmetic(String func) {
    // Splits function at points where there are brackets, + or -.
    RegExp regExp = RegExp(r'([a-zA-Z0-9]+|[+\-*/^=])|\([^)]*\)');
    Iterable<Match> matches = regExp.allMatches(func);
    return matches.map((match) {
      return match.group(0);
    }).toList();
  }

  List<String> extractArithmetic2(String func) {
    // Splits function at points where there are brackets, +, -, *, /, or ^.
    RegExp regExp = RegExp(r'([+\-]?\d*\.*\d*[a-zA-Z()^0-9]*)');
    Iterable<Match> matches = regExp.allMatches(func);
    return matches
        .map((match) => match.group(0)!.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }
}
