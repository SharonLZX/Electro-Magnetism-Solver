import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Physics Formula Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Map<String, TextEditingController> controllers = {};

  // Variable to hold the result
  dynamic _result = 0.0;

  // List of formulas
  final List<String> formulaList = [
    'Magnetic Flux Integral (ΦB = ∫∫B·dS)',
    'Induced EMF in a loop (E = - dΦB/dt)',
  ];

  // Selected formula
  String selectedFormula = 'Magnetic Flux Integral (ΦB = ∫∫B·dS)';

  @override
  void initState() {
    super.initState();
    final inputs = ['B', 'BD', 'S', 'SD', 'A', 'dFlux', 'dt'];
    for (var input in inputs) {
      controllers[input] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Dispose all the controllers to release resources
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  // Magnetic Flux Integral: ΦB = ∫∫B·dS
  double magneticFluxIntegral(double B, double S) {
    return B * S; // Simplified version for uniform B over S
  }

  // Induced EMF in a loop: E = - dΦB/dt
  double inducedEMFLoop(double dFlux, double dt) {
    return dt != 0 ? -(dFlux / dt) : 0.0; // Handle division by zero
  }

  //To limit numbers only
  Widget buildTextFormFieldNumber(String label, String controllerKey) {
    return TextFormField(
        decoration: InputDecoration(labelText: label),
        controller: controllers[controllerKey],
        keyboardType: TextInputType.number);
  }

  //For Numbers, Trigo Functions and Alphabet
  Widget buildTextFormField(String label, String controllerKey) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controllers[controllerKey],
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'^[a-zA-Z0-9()+\-*/\s^]*$|^[a-zA-Z]+\(.*\)$'))
      ],
    );
  }

  //To limit a directions variable only
  Widget buildTextFormFieldDirection(String label, String controllerKey) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controllers[controllerKey],
      keyboardType: TextInputType.text, // We still allow text input
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^(a|ax|ay|az)$')),
      ],
    );
  }

  //To format super and subscript
  String formatFormulaWithSubscripts(String formula) {
    // Replace variables with subscripts (e.g., c1 -> c₁)
    formula = formula.replaceAllMapped(
      RegExp(r'([a-zA-Z])(\d+)'), // Match a letter followed by digits
      (match) => '${match[1]}${_convertToSubscript(match[2]!)}',
    );

    // Replace superscripts (e.g., ^2 -> ²)
    formula = formula.replaceAllMapped(
      RegExp(r'\^(\d)'), // Match ^ followed by a digit
      (match) => _convertToSuperscript(match[1]!),
    );

    return formula;
  }

// Helper function to convert numbers to subscript
  String _convertToSubscript(String number) {
    const subscriptDigits = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];
    return number
        .split('')
        .map((digit) => subscriptDigits[int.parse(digit)])
        .join('');
  }

// Helper function to convert numbers to superscript
  String _convertToSuperscript(String number) {
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

  /// Helper function for symbolic multiplication
  String multiplySymbolic(String term1, String term2) {
    if (term1 == "0" || term2 == "0") return "0";
    if (term1 == "1") return term2;
    if (term2 == "1") return term1;
    return "$term1 * $term2";
  }

  /// Magnetic Flux Integral for symbolic variables
  String magneticFluxIntegralSymbolic(
      String B, String S, String bd, String sd) {
    // Check if BD and SD are the same, dot product is 1, otherwise 0
    String dotProduct = (bd == sd) ? "1" : "0";

    // Formula
    String formula = 'ΦB = ∫∫B·dS';

    // Substitution step showing the symbolic substitution
    String substitutionStep = 'Substitution: ∫∫(($B)($bd)) · (($S)($sd))';

    // Handle the dot product more accurately
    String result;
    if (dotProduct == "1") {
      // Simplify the expression when the dot product is 1
      result = "$B * $S";
    } else {
      result = "$B · $S = 0";
    }

    return '$formula\n$substitutionStep\nResult: $result';
  }

  // Perform calculation based on selected formula
  void calculateResult() {
    setState(() {
      switch (selectedFormula) {
        case 'Magnetic Flux Integral (ΦB = ∫∫B·dS)':
          String B = controllers['B']?.text ?? "0";
          String S = controllers['S']?.text ?? "0";
          String bd = controllers['BD']?.text ?? "";
          String sd = controllers['SD']?.text ?? "";

          // Use the symbolic flux calculation
          String rawResult = magneticFluxIntegralSymbolic(B, S, bd, sd);

          // Format for display with subscripts and superscripts
          _result = formatFormulaWithSubscripts(rawResult);
          break;
        case 'Induced EMF in a loop (E = - dΦB/dt)':
          double dFlux =
              double.tryParse(controllers['dFlux']?.text ?? '0') ?? 0;
          double dt = double.tryParse(controllers['dt']?.text ?? '0') ?? 0;
          _result = inducedEMFLoop(dFlux, dt);
          break;
      }
    });
  }

  // Function to clear the fields and reset the result
  void clearFields() {
    controllers.forEach((key, controller) {
      controller.clear();
    });
    setState(() {
      _result = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    // The Flutter framework has been optimized to make rerunning build methods fast, so that you can just rebuild anything that needs updating rather than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by the App.build method, and use it to set our appbar title.
        title: const Text('Formular Selector'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Center is a layout widget. It takes a single child and positions it in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedFormula,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFormula = newValue!;

                  // Clear all text fields
                  controllers.forEach((key, controller) {
                    controller.clear();
                  });

                  // Reset the result
                  _result = 0.0;
                });
              },
              items: formulaList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            const SizedBox(height: 10), //Add some space between fields

            if (selectedFormula == 'Magnetic Flux Integral (ΦB = ∫∫B·dS)') ...[
              buildTextFormField('B (Magnetic Field Strength in Tesla)', 'B'),
              buildTextFormFieldDirection('Field direction (ax, ay, az)', 'BD'),
              buildTextFormField('S (Surface Area in m²)', 'S'),
              buildTextFormFieldDirection(
                  'Surface direction (ax, ay, az)', 'SD'),
            ] else if (selectedFormula ==
                'Induced EMF in a loop (E = - dΦB/dt)') ...[
              buildTextFormField(
                  'dΦB (Change in Magnetic Flux in Weber)', 'dFlux'),
              buildTextFormField('dt (Change in Time in seconds)', 'dt'),
            ],

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateResult,
              child: const Text('Calculate'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: clearFields,
              child: const Text('Clear'),
            ),

            const SizedBox(height: 20),

            Text('Result: ${_result.toString()}'),
          ],
        ),
      ),
    );
  }
}
