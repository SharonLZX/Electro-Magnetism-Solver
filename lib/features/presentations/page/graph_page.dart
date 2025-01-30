import 'package:electro_magnetism_solver/features/presentations/widgets/3d%20objects/arrows.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/3d%20objects/planes.dart';
import 'package:electro_magnetism_solver/features/presentations/widgets/legend.dart';
import 'package:flutter/material.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<StatefulWidget> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  late List<Sp3dObj> objs = [];
  late Sp3dWorld world;

  bool isLoaded = false;
  double zoomLevel = 1.0; // Default zoom level

  @override
  void initState() {
    super.initState();
    AxisObj axisObj = AxisObj();
    PlaneObj planeObj = PlaneObj();
    objs = UtilSp3dCommonParts.coordinateArrows(300);
    for (int i = 0; i < 3; i++) {
      objs.add(axisObj.createArrow(i));
      objs.add(axisObj.createPillar(i));
      objs.add(planeObj.createPlanes(i));
    }
    loadImage();
  }

  void loadImage() async {
    world = Sp3dWorld(objs);
    world.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    LegendBuilder legendBuilder = LegendBuilder();

    // Adjust camera position based on zoom level (distance from the scene)
    Sp3dCamera camera = Sp3dCamera(
      Sp3dV3D(
          0, 0, 1000 * zoomLevel), // Camera position on Z-axis (zooming in/out)
      1000,
      rotateAxis: Sp3dV3D(0, 1, 0),
      radian: -0.79,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Sp3dRenderer(
              const Size(2000, 2000),
              Sp3dV2D(screenWidth / 2, screenHeight / 2),
              world,
              camera,
              Sp3dLight(Sp3dV3D(0, 0, -1), syncCam: true),
            ),
          ),
          // Legend Box
          Positioned(
            left: 25,
            bottom: 20,
            child: Container(
              width: 350,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(92, 0, 0, 0).withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  legendBuilder.axisBuilder(),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      legendBuilder.axisLegend(0),
                      legendBuilder.axisLegend(1),
                      legendBuilder.axisLegend(2),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //TODO: Can use the zoomBuilder class
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Zoom Level: ${zoomLevel.toStringAsFixed(2)}",
                          style: TextStyle(color: Colors.white)),
                      Slider(
                        value: zoomLevel * -1,
                        min: -2.5, // Minimum zoom level (zoom out)
                        max: -0.5, // Maximum zoom level (zoom in)
                        onChanged: (double value) {
                          setState(() {
                            zoomLevel = value * -1;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
