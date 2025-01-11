class SubscriptManager {
  String subscriptFormatting(String formula) {
    // Replace variables with subscripts (e.g., c1 -> c₁)
    formula = formula.replaceAllMapped(
      RegExp(r'([a-zA-Z])(\d+)'),
      (match) => '${match[1]}${convertToSubscript(match[2]!)}',
    );

    // Replace superscripts (e.g., ^2 -> ²)
    formula = formula.replaceAllMapped(
      RegExp(r'\^(\d)'),
      (match) => convertToSuperscript(match[1]!),
    );

    return formula;
  }

  // Helper function to convert numbers to subscript
  String convertToSubscript(String number) {
    const subscriptDigits = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];
    return number
        .split('')
        .map((digit) => subscriptDigits[int.parse(digit)])
        .join('');
  }

  // Helper function to convert numbers to superscript
  String convertToSuperscript(String number) {
    const superscriptDigits = [
      '⁰',
      '¹',
      '²',
      '³',
      '⁴',
      '⁵',
      '⁶',
      '⁷',
      '⁸',
      '⁹'
    ];
    return number
        .split('')
        .map((digit) => superscriptDigits[int.parse(digit)])
        .join('');
  }
}
