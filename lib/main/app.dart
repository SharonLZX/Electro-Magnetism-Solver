import 'features/forms/forms.dart';
import 'core/constants.dart';
import 'features/calculations/subscript.dart';
import 'package:flutter/material.dart';
import 'package:electro_magnetism_solver/main/features/calculations/calculate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Electromagnetism Solver'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      result = calcHandler.magFlxIntgSymb(
          magField, fieldDir, surfArea, surfDir, areaElm);
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
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: widgetFactory.planeForm(planeHint, 'P'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: widgetFactory.defaultForm(magFieldHint, 'B'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: widgetFactory.directionForm(fieldDirecHint, 'BD'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: widgetFactory.defaultForm(surfAreaHint, 'S'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: widgetFactory.directionForm(surfDirecHint, 'SD'),
                  ),
                ] else if (selectedFormula == formulaList[1]) ...[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: widgetFactory.directionForm(chgMagFluxHint, 'dFlux'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: widgetFactory.directionForm(chgTimeHint, 'dt'),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:5, vertical: 5),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 174, 213, 129),
                        foregroundColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      onPressed: calculateResult,
                      child: const Text('S O L V E'),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth - 10,
                  height: (_result.length * 70),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0.0),
                    shrinkWrap: true,
                    itemCount: _result.length,
                    itemBuilder: (context, index) {
                      return Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          color: index.isEven
                              ? Colors.grey[300]
                              : Colors.grey[350],
                          child: ListTile(
                            title: Text("Step $index"),
                            subtitle: Text(_result[index]),
                          ));
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
