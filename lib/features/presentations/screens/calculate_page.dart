import 'package:electro_magnetism_solver/features/presentations/snackbar/snackbar.dart';
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
  final Map<String, TextEditingController> controllers = {
    'defaultInput': TextEditingController(),
    'directionInput': TextEditingController(),
    'planeInput': TextEditingController()
  };

  late final WidgetFactory widgetFactory;
  List<String> _result = [];
  List<String> questionBank = [];
  String selectedFormula = formulaList[0];

  DBHandler dbHandler = DBHandler();
  Calculate calcHandler = Calculate();
  SubscriptManager subscriptManager = SubscriptManager();

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

      areaElm = calcHandler.planeFormatting(plane);
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
    Share.share(_result.toString());
  }

  void printResult() async {
    final List<Result> storedresult = await dbHandler.retrieveResult();
    debugPrint(storedresult.join());
  }

  void saveResult() async {
    var resMap =
        Result(id: 0, question: questionBank.join(), result: _result.join());

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

  bool isCntrlFilled() {
    String? plane = controllers['P']?.text;
    String? magField = controllers['B']?.text;
    String? surfArea = controllers['S']?.text;
    String? fieldDir = controllers['BD']?.text;
    String? surfDir = controllers['SD']?.text;

    // Return true if all required fields are filled (i.e., not default values)
    return (plane!.isNotEmpty &&
        magField!.isNotEmpty &&
        surfArea!.isNotEmpty &&
        fieldDir!.isNotEmpty &&
        surfDir!.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    final snacker = Snacker(context);
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
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SolveButton(
                    onPressed: () {
                      if (isCntrlFilled()) {
                        snacker.showSuccess("Calculating...");
                        calculateResult();
                      } else {
                        snacker.showError("Ensure all fields are filled.");
                      }
                    },
                  ),
                  Visibility(
                    visible: (_result.length > 1),
                    child: ShareButton(onPressed: shareResult),
                  ),
                  Visibility(
                    visible: (_result.length > 1),
                    child: SaveButton(onPressed: saveResult),
                  ),
                  /*Visibility(
                    visible: (_result.length > 1),
                    child: PrintButton(onPressed: printResult),
                  ),*/
                ],
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
