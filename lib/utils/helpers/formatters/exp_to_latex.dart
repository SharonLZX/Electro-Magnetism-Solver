import 'package:math_expressions/math_expressions.dart';

class ExpToLatex{
  String expressionToLatex(Expression expression) {
    if (expression is Variable) {
      return expression.name;
    } else if (expression is Number) {
      // Check if the number is a whole number and remove the decimal point
      double value = expression.value;
      if (value == value.toInt()) {
        return value.toInt().toString(); // Remove decimals if it's an integer
      }
      return expression.toString();
    } else if (expression is BinaryOperator) {
      String left = expressionToLatex(expression.first);
      String right = expressionToLatex(expression.second);

      if (expression is Plus) {
        return '$left + $right';
      } else if (expression is Minus) {
        return '$left - $right';
      } else if (expression is Times) {
        return '$left \\cdot $right';
      } else if (expression is Divide) {
        return '\\frac{$left}{$right}';
      } else if (expression is Power) {
        return '$left^{$right}';
      } else {
        return '$left ? $right';
      }
    } else {
      return expression.toString();
    }
  }
}