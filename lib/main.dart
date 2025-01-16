import 'package:electro_magnetism_solver/calculate.dart';
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
  String selectedFormula = formulaList[0];
  CalcManager calcHandler = CalcManager();
  SubscriptManager subscriptManager = SubscriptManager();

  void buildEditor() {
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

  void calculateResult() {
    String areaElm = "";
    List<String> result = [];

    if (selectedFormula == formulaList[0]) {
      String plane = controllers['P']?.text ?? "xy";
      String magField = controllers['B']?.text ?? "0";
      String surfArea = controllers['S']?.text ?? "0";
      String fieldDir = controllers['BD']?.text ?? "az";
      String surfDir = controllers['SD']?.text ?? "az";

      if (surfArea == "1") {
        surfArea = "";
      }

      areaElm = calcHandler.calcPlane(plane);
      result = calcHandler.magFlxIntgSymb(magField, fieldDir, surfArea, surfDir, areaElm);
      _result = subscriptManager.subscriptFormatting(result);
    } else if (selectedFormula == formulaList[1]) {
      double chgFlux = double.tryParse(controllers['dFlux']?.text ?? '0') ?? 0;
      double chgTime = double.tryParse(controllers['dt']?.text ?? '0') ?? 0;
      // _result = calcHandler.inducedEMFLoop(chgFlux, chgTime);
    }

    setState(() {
      _result;
    });
  }

  void clearFields() {
    setState(() {
      controllers.forEach((key, controller) {
        controller.clear();
      });
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
                if (selectedFormula == formulaList[0]) ...[
                  widgetFactory.planeForm(planeHint, 'P'),
                  widgetFactory.defaultForm(magFieldHint, 'B'),
                  widgetFactory.directionForm(fieldDirecHint, 'BD'),
                  widgetFactory.defaultForm(surfAreaHint, 'S'),
                  widgetFactory.directionForm(surfDirecHint, 'SD'),
                ] else if (selectedFormula == formulaList[1]) ...[
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
                        child: const Text('Clear'),
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
