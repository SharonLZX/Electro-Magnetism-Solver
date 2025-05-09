import 'package:electro_magnetism_solver/utils/helpers/formatters/subscript_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:share_plus/share_plus.dart';
import 'package:electro_magnetism_solver/utils/helpers/design/forms.dart';
import 'package:electro_magnetism_solver/utils/handlers/calculation/calculate.dart';
import 'package:electro_magnetism_solver/core/constants/constants.dart';
import 'package:electro_magnetism_solver/data/local/database_helper.dart';
import 'package:electro_magnetism_solver/utils/helpers/design/padded_forms.dart';
import 'package:electro_magnetism_solver/features/auth/data/models/result_model.dart';
import 'package:electro_magnetism_solver/features/presentations/snackbar/snackbar.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/buttons/bttn_save.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/buttons/bttn_solve.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/buttons/bttn_share.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/buttons/bttn_drop_down.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/list_view_result.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/chkbox_chainrule.dart';

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
  bool isChecked = false;

  List<String> _result = [];
  List<String> questionBank = [];
  String selectedFormula = formulaList[0];

  DBHandler dbHandler = DBHandler();
  Calculate calcHandler = Calculate();
  Subscript subscriptHandler = Subscript();

  TextEditingController chainRuleCntrl = TextEditingController();

  void buildEditor() {
    for (var input in inputs) {
      controllers[input] = TextEditingController();
    }
  }

  void calculateResult() {
    String areaElm = "";
    dynamic resStr = [];
    List<String> result = [];

    if (selectedFormula == formulaList[0]) {
      String plane = controllers['P']?.text ?? "xy";
      String magField = controllers['B']?.text ?? "0";
      String surfArea = controllers['S']?.text ?? "0";
      String fieldDir = controllers['BD']?.text ?? "az";
      String surfDir = controllers['SD']?.text ?? "az";
      // Wrap with overrightarrow LaTeX
      String fieldVector = r'\overrightarrow{' + fieldDir + '}';
      String surfVector = r'\overrightarrow{' + surfDir + '}';

      if (surfArea == "1") {
        surfArea = "";
      }

      // Adds the question to the question bank, which is used for storing into database.
      questionBank.addAll([plane, magField, surfArea, fieldDir, surfDir]);

      areaElm = calcHandler.planeFormatting(plane);
      result = calcHandler.magFlxIntgSymb(
          magField, fieldVector, surfArea, surfVector, areaElm);

      _result = subscriptHandler.subscriptFormatting(result);
    } else if (selectedFormula == formulaList[1]) {
      String chgFlux = controllers['dFlux']?.text ?? '0';

      _result.add('E = - dΦB/dt');
      resStr = calcHandler.inducedEMFLoop(chgFlux);
      if (resStr == null) {
        _result.add("Can't compute");
      } else {
        _result.add(resStr.toString());
      }
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
  }

  void saveResult() async {
    var resMap =
        Result(id: 0, question: questionBank.join(), result: _result.join());

    await dbHandler.insertResult(resMap);
  }

  bool isCntrlFilled() {
    String? plane = controllers['P']?.text;
    String? magField = controllers['B']?.text;
    String? surfArea = controllers['S']?.text;
    String? fieldDir = controllers['BD']?.text;
    String? surfDir = controllers['SD']?.text;
    String? chgFlux = controllers['dFlux']?.text;

    if (selectedFormula == formulaList[0]) {
      return (plane!.isNotEmpty &&
          plane.length == 2 &&
          magField!.isNotEmpty &&
          surfArea!.isNotEmpty &&
          fieldDir!.isNotEmpty &&
          surfDir!.isNotEmpty);
    } else {
      return (chgFlux!.isNotEmpty);
    }
  }

  void handleCheckboxChange(bool? value) {
    setState(() {
      isChecked = value ?? false;
    });
  }

  @override
  void initState() {
    super.initState();

    // Builds the relevant text controllers for the input fields.
    buildEditor();

    // Instantiates the widget factory.
    widgetFactory = WidgetFactory(controllers);

    // Listens to the chain rule checkbox controller.
    chainRuleCntrl.addListener(() {});
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    chainRuleCntrl.dispose();
    super.dispose();
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
              // CustomDropDown is a custom widget that displays a dropdown
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

              // The following code block is a conditional statement that displays the input fields.
              if (selectedFormula == formulaList[0]) ...[
                paddedForm(widgetFactory.customForm, 0, planeHint, 'P'),
                paddedForm(widgetFactory.customForm, 2, magFieldHint, 'B'),
                paddedForm(widgetFactory.customForm, 1, fieldDirecHint, 'BD'),
                paddedForm(widgetFactory.customForm, 2, surfAreaHint, 'S'),
                paddedForm(widgetFactory.customForm, 1, surfDirecHint, 'SD'),
              ] else if (selectedFormula == formulaList[1]) ...[
                paddedForm(
                    widgetFactory.customForm, 3, chgMagFluxHint, 'dFlux'),
              ],
              Visibility(
                visible: !selectedFormula.contains('EMF'),
                child: ChkboxChainrule(
                    onChecked: handleCheckboxChange,
                    value: isChecked,
                    textController: chainRuleCntrl),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SolveButton(
                    onPressed: () {
                      // Checks if all fields are filled before calculating.
                      if (isCntrlFilled()) {
                        snacker.showSuccess("Calculating...");
                        if (_result.isNotEmpty) {
                          _result = [];
                        }
                        calculateResult();
                      } else {
                        snacker.showError("Ensure all fields are filled.");

                        setState(() {
                          _result = [];
                        });
                      }
                    },
                  ),
                  Visibility(
                    visible: (_result.isNotEmpty),
                    child: ShareButton(onPressed: shareResult),
                  ),
                  Visibility(
                    visible: (_result.isNotEmpty),
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
              Text("Expression limitations :"),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Math.tex("n+n"),
                  Math.tex("t^n(t+t)"),
                  Math.tex("t(t+t^n)"),
                  Math.tex("nt(nt+n)"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
