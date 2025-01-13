import 'package:electro_magnetism_solver/plane.dart';
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
    'directionInput': TextEditingController(),
    'planeInput': TextEditingController()
  };

  late final WidgetFactory widgetFactory;

  List<String> _result = [];
  String selectedFormula = 'Magnetic Flux Integral (ΦB = ∫∫B·dS)';
  SubscriptManager subscriptManager = SubscriptManager();
  PlaneManager planeManager = PlaneManager();

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
  List<String> magneticFluxIntegralSymbolic(
      String B, String bd, String S, String sd, String areaElement) {
    List<String> resultList = [];

    resultList.add('Formula: Φm = ∫∫ B · dS');
    resultList.add('∫∫ (($B)($bd)) · (($areaElement)($sd))');

    if (bd == sd) {
      resultList.add('∫∫ ($B) ($areaElement)');
      resultList.add('($B) ∫∫ ($areaElement)');
      resultList.add('($B) * ($S)');
    } else {
      resultList.add('0 (BD and SD are orthogonal)');
    }
    return resultList;
  }

  // Perform calculation based on selected formula
  void calculateResult() {
    setState(() {
      switch (selectedFormula) {
        case 'Magnetic Flux Integral (ΦB = ∫∫B·dS)':
          String P = controllers['P']?.text ?? "xy";
          String B = controllers['B']?.text ?? "0";
          String S = controllers['S']?.text ?? "0";
          String bd = controllers['BD']?.text ?? "az";
          String sd = controllers['SD']?.text ?? "az";

          // Format plane
          String areaElement =
              planeManager.planeSelection(P); //areaElement: e.g. dxdy

          // Use the symbolic flux calculation
          List<String> result =
              magneticFluxIntegralSymbolic(B, bd, S, sd, areaElement);

          // Format for display with subscripts and superscripts
          _result = subscriptManager.subscriptFormatting(result);
          break;
        case 'Induced EMF in a loop (E = - dΦB/dt)':
          double dFlux =
              double.tryParse(controllers['dFlux']?.text ?? '0') ?? 0;
          double dt = double.tryParse(controllers['dt']?.text ?? '0') ?? 0;
          // _result = inducedEMFLoop(dFlux, dt);
          break;
      }
    });
  }

  void clearFields() {
    controllers.forEach((key, controller) {
      controller.clear();
    });
    setState(() {
      _result.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth - 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: selectedFormula,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFormula = newValue!;
                      controllers.forEach((key, controller) {
                        controller.clear();
                      });
                      _result.clear();
                    });
                  },
                  items: formulaList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                if (selectedFormula ==
                    'Magnetic Flux Integral (ΦB = ∫∫B·dS)') ...[
                  widgetFactory.planeForm(planeFormHint, 'P'),
                  widgetFactory.defaultForm(magFieldHint, 'B'),
                  widgetFactory.directionForm(fieldDirecHint, 'BD'),
                  widgetFactory.defaultForm(surAreaHint, 'S'),
                  widgetFactory.directionForm(surDirecHint, 'SD'),
                ] else ...[
                  widgetFactory.directionForm(chgMagFluxHint, 'dFlux'),
                  widgetFactory.directionForm(chgTimeHint, 'dt'),
                ],
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: calculateResult,
                        child: const Text('Calculate'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: clearFields,
                        child: const Text('Restart'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenWidth - 10,
                  height: (_result.length * 50),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemCount: _result.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text("Step $index"),
                        subtitle: Text(_result[index]),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
