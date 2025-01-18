import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:electro_magnetism_solver/utils/forms.dart';
import 'package:electro_magnetism_solver/utils/formatters/padded_forms.dart';
import 'package:electro_magnetism_solver/calculations/calculate.dart';
import 'package:electro_magnetism_solver/utils/formatters/subscripts.dart';
import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/data/local/database_helper.dart';
import 'package:electro_magnetism_solver/features/auth/data/models/result_model.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/bttn_save.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/bttn_print.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/bttn_solve.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/bttn_share.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/bttn_drop_down.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/list_view_result.dart';

class CalculatePage extends StatefulWidget {
  const CalculatePage({super.key});

  @override
  State<CalculatePage> createState() => _CalculatePageState();
}

class _CalculatePageState extends State<CalculatePage> {
  List<String> result = [];
  List<String> questionBank = [];
  late WidgetFactory widgetFactory;
  String selectedFormula = formulaList[0];

  final Map<String, TextEditingController> controllers = {
    'defaultInput': TextEditingController(),
    'directionInput': TextEditingController(),
    'planeInput': TextEditingController()
  };

  DBHandler dbHandler = DBHandler();
  Calculate calcHandler = Calculate();
  SubscriptManager subscriptManager = SubscriptManager();

  void buildEditor() {
    for (var input in inputs) {
      controllers[input] = TextEditingController();
    }

    widgetFactory = WidgetFactory(controllers);
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

      areaElm = calcHandler.planeFormatting(plane);
      result = calcHandler.magFlxIntgSymb(
          magField, fieldDir, surfArea, surfDir, areaElm);
      result = subscriptManager.subscriptFormatting(result);
    } else if (selectedFormula == formulaList[1]) {
      // double chgFlux = double.tryParse(controllers['dFlux']?.text ?? '0') ?? 0;
      // double chgTime = double.tryParse(controllers['dt']?.text ?? '0') ?? 0;
      // _result = calcHandler.inducedEMFLoop(chgFlux, chgTime);
    }

    setState(() {
      result;
    });
  }

  void shareResult() {
    Share.share(result.last);
  }

  void saveResult() async {
    var resMap =
        Result(id: 0, question: questionBank.join(), result: result.join());

    await dbHandler.insertResult(resMap);
  }

  void printResult() async {
    final List<Result> storedresult = await dbHandler.retrieveResult();
    debugPrint(storedresult.join());
  }

  void dropDownChange(String? newValue) {
    selectedFormula = newValue!;
    controllers.forEach((key, controller) {
      controller.clear();
    });
    result.clear();
  }

  @override
  void initState() {
    super.initState();
    buildEditor();
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
                      dropDownChange(newValue);
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
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: SolveButton(
                      onPressed: calculateResult,
                    )),
              ),
              Visibility(
                visible: (result.length > 1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: ShareButton(onPressed: shareResult)),
                ),
              ),
              Visibility(
                visible: (result.length > 1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: SaveButton(onPressed: saveResult)),
                ),
              ),
              Visibility(
                visible: (result.length > 1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: PrintButton(onPressed: printResult)),
                ),
              ),
              SizedBox(
                  width: screenWidth - 10,
                  height: (result.length * 70),
                  child: ResultList(
                    result: result,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
