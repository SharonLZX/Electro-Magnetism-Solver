import 'package:electro_magnetism_solver/db_handler.dart';
import 'package:electro_magnetism_solver/main/result_model.dart';
import 'package:electro_magnetism_solver/main/widget/custom/print_button.dart';
import 'package:electro_magnetism_solver/main/widget/custom/save_button.dart';
import 'package:electro_magnetism_solver/main/widget/custom/share_button.dart';
import 'package:flutter/material.dart';
import 'package:electro_magnetism_solver/main/core/constants.dart';
import 'package:electro_magnetism_solver/main/features/calculations/subscript.dart';
import 'package:electro_magnetism_solver/main/features/forms/forms.dart';
import 'package:electro_magnetism_solver/main/widget/custom/result_list.dart';
import 'package:electro_magnetism_solver/main/widget/custom/solve_button.dart';
import 'package:electro_magnetism_solver/main/features/calculations/padded_forms.dart';
import 'package:electro_magnetism_solver/main/widget/custom/dropdown_button.dart';
import 'package:electro_magnetism_solver/main/features/calculations/calculate.dart';
import 'package:share_plus/share_plus.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
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
  List<String> questionBank = [];
  DBHandler dbHandler = DBHandler();

  void buildEditor() {
    for (var input in inputs) {
      controllers[input] = TextEditingController();
    }
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

      questionBank.addAll([plane, magField, surfArea, fieldDir, surfDir]);

      areaElm = calcHandler.calcPlane(plane);
      result = calcHandler.magFlxIntgSymb(
          magField, fieldDir, surfArea, surfDir, areaElm);
      _result = subscriptManager.subscriptFormatting(result);
    } else if (selectedFormula == formulaList[1]) {
      // double chgFlux = double.tryParse(controllers['dFlux']?.text ?? '0') ?? 0;
      // double chgTime = double.tryParse(controllers['dt']?.text ?? '0') ?? 0;
      // _result = calcHandler.inducedEMFLoop(chgFlux, chgTime);
    }

    setState(() {
      _result;
    });
  }

  void shareResult() {
    Share.share(_result.last);
  }

  void printResult() async{
    final List<Result> storedresult = await dbHandler.retrieveResult();
    debugPrint(storedresult.join());
  }

  void saveResult() async{
    var resMap = Result(
      id: 0, 
    question: questionBank.join(), 
    result: _result.join());

    await dbHandler.insertResult(resMap);
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: SingleChildScrollView(
        child: SizedBox(
          width: screenWidth - 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomDropDown(
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFormula = newValue!;
                      controllers.forEach((key, controller) {
                        controller.clear();
                      });
                      _result.clear();
                    });
                  },
                  selectedFormula: selectedFormula),
              if (selectedFormula == formulaList[0]) ...[
                paddedForm(widgetFactory.customForm, 0, planeHint, 'P'),
                paddedForm(widgetFactory.customForm, 2, magFieldHint, 'B'),
                paddedForm(widgetFactory.customForm, 1, fieldDirecHint, 'BD'),
                paddedForm(widgetFactory.customForm, 2, surfAreaHint, 'S'),
                paddedForm(widgetFactory.customForm, 1, surfDirecHint, 'SD'),
              ] else if (selectedFormula == formulaList[1]) ...[
                paddedForm(
                    widgetFactory.customForm, 1, chgMagFluxHint, 'dFlux'),
                paddedForm(widgetFactory.customForm, 1, chgTimeHint, 'dt'),
              ],
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: SolveButton(
                      onPressed: calculateResult,
                    )),
              ),
              Visibility(
                visible: (_result.length > 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 5),
                  child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ShareButton(onPressed: shareResult)),
                ),
              ),
              Visibility(
                visible: (_result.length > 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 5),
                  child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: SaveButton(onPressed: saveResult)),
                ),
              ),
              Visibility(
                visible: (_result.length > 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 5),
                  child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: PrintButton(onPressed: printResult)),
                ),
              ),
              SizedBox(
                  width: screenWidth - 10,
                  height: (_result.length * 70),
                  child: ResultList(
                    result: _result,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
