import 'package:flutter/material.dart';

import 'forms.dart';
import 'constants.dart';
import 'subscript.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 192, 62, 153)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Electromagnetism Solver'),
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
  final Map<String, TextEditingController> controllers = {
    'numberInput': TextEditingController(),
    'defaultInput': TextEditingController(),
    'directionInput': TextEditingController()
  };

  late final WidgetFactory widgetFactory;

  dynamic _result = 0.0;
  String selectedFormula = 'Magnetic Flux Integral (ΦB = ∫∫B·dS)';
  SubscriptManager subscriptManager = SubscriptManager();

  void buildEditor() {
    // Builds TextEditingController during initState phase.
    for (var input in inputs) {
      controllers[input] = TextEditingController();
    }
  }

  @override
  void initState() {
    super.initState();
    buildEditor();
    widgetFactory = WidgetFactory(controllers);
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  double inducedEMFLoop(double dFlux, double dt) {
    return dt != 0 ? -(dFlux / dt) : 0.0;
  }

  String multiplySymbolic(String term1, String term2) {
    /// Helper function for symbolic multiplication
    if (term1.trim() == "0" || term2.trim() == "0") return "0";
    if (term1.trim() == "1") return term2.trim();
    if (term2.trim() == "1") return term1.trim();
    return "$term1 * $term2";
  }

  // Magnetic Flux Integral for symbolic variables
  String magneticFluxIntegralSymbolic(
      String B, String bd, String sd, String dS, String totalArea) {
    // Step 1: Write the formula
    String formula = 'Φm = ∫∫ B · dS';

    // Step 2: Substitute B and dS
    String step1 = 'Substitution: ∫∫ (($B)($bd)) · (($dS)($sd))';

    // Step 3: Compute the dot product
    String dotProduct = (bd == sd) ? "1" : "0";
    String step2;
    if (dotProduct == "1") {
      step2 = 'Step 2: ∫∫ ($B) ($dS)';
    } else {
      step2 = 'Step 2: 0 (BD and SD are orthogonal)';
      return '$formula\n$step1\n$step2\nResult: 0';
    }

    // Step 4: Factor out constants
    String step3 = 'Step 3: ($B) ∫∫ ($dS)';

    // Step 5: Replace area integral with totalArea
    String step4 = 'Step 4: ($B) * ($totalArea)';

    // Result
    String result = 'Result: ($B) * $totalArea';

    return '$formula\n$step1\n$step2\n$step3\n$step4\n$result';
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
          String dS = controllers['dS']?.text ?? "";

          // Use the symbolic flux calculation
          String rawResult = magneticFluxIntegralSymbolic(B, S, bd, sd, dS);

          // Format for display with subscripts and superscripts
          _result = subscriptManager.subscriptFormatting(rawResult);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Electromagnetism Solver'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedFormula,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFormula = newValue!;
                  controllers.forEach((key, controller) {
                    controller.clear();
                  });
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
            const SizedBox(height: 10),
            if (selectedFormula == 'Magnetic Flux Integral (ΦB = ∫∫B·dS)') ...[
              widgetFactory.defaultForm(
                  'B (Magnetic Field Strength in Tesla)', 'B'),
              widgetFactory.directionForm('Field direction (ax, ay, az)', 'BD'),
              widgetFactory.defaultForm('S (Surface Area in m²)', 'S'),
              widgetFactory.directionForm(
                  'Surface direction (ax, ay, az)', 'SD'),
            ] else if (selectedFormula ==
                'Induced EMF in a loop (E = - dΦB/dt)') ...[
              widgetFactory.directionForm(
                  'dΦB (Change in Magnetic Flux in Weber)', 'dFlux'),
              widgetFactory.directionForm(
                  'dt (Change in Time in seconds)', 'dt'),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: calculateResult,
                  child: const Text('Calculate'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: clearFields,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Result: ${_result.toString()}'),
          ],
        ),
      ),
    );
  }
}
