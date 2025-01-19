// Text Field for User Input
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Differentiation Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DifferentiationSolver(title: 'Simple Differentiation'),
    );
  }
}

class DifferentiationSolver extends StatefulWidget {
  const DifferentiationSolver({super.key, required String title});

  @override
  // ignore: library_private_types_in_public_api
  _DifferentiationSolverState createState() => _DifferentiationSolverState();
}

class _DifferentiationSolverState extends State<DifferentiationSolver> {
  final TextEditingController _equationController = TextEditingController();
  String latexEquation = '';
  String resultLatex = '';

  // Helper function to add multiplication signs (*) where necessary
  String preprocessInput(String input) {
    return input.replaceAllMapped(RegExp(r'(\d)([a-zA-Z])'),
        (match) => '${match.group(1)}*${match.group(2)}');
  }

  // Custom function to convert expression to LaTeX-like string
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

  // Method to differentiate and format the result
  void calculateDifferentiation() {
    String userInput = _equationController.text;
    String processedInput = preprocessInput(userInput); // Add implicit *

    try {
      Parser p = Parser();
      Expression exp = p.parse(processedInput);

      // Differentiation and simplification
      Expression derivative = exp
          .derive('x')
          .simplify(); // Ensure simplification is after differentiation

      setState(() {
        latexEquation = userInput; // Display original input
        resultLatex =
            expressionToLatex(derivative); // Format the result for LaTeX
      });
    } catch (e) {
      setState(() {
        resultLatex = "Error: Invalid Input!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Differentiation Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // LaTeX Display of the Input Equation on one line
            latexEquation.isNotEmpty
                ? Math.tex(
                    r'Equation: ' + latexEquation,
                    textStyle: const TextStyle(fontSize: 18),
                  )
                : Container(),
            const SizedBox(height: 20),            
            TextField(
              controller: _equationController,
              decoration: const InputDecoration(
                labelText: 'Enter Equation (e.g., 3*x^2 + 2*x + 1)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),

            // Button to Calculate Differentiation
            ElevatedButton(
              onPressed: calculateDifferentiation,
              child: const Text('Calculate Differentiation'),
            ),
            const SizedBox(height: 20),

            // LaTeX Display of the Result
            resultLatex.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Result:'),
                      const SizedBox(height: 15),
                      Math.tex(
                        r'\frac{d}{dx}(' + latexEquation + r')',
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Math.tex(
                        r'=' + resultLatex,
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}