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
    objs = UtilSp3dCommonParts.coordinateArrows(300); // Create XYZ arrows

    Sp3dObj arrow_inverse_x = UtilSp3dGeometry.cone(5, 10);
    arrow_inverse_x.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 255, 0, 0);
    arrow_inverse_x.rotate(Sp3dV3D(0, 1, 0), -90 * 3.14 / 180);
    arrow_inverse_x.move(Sp3dV3D(-300, 0, 0));
    objs.add(arrow_inverse_x);

    Sp3dObj pillar_inverse_x = UtilSp3dGeometry.pillar(2, 2, 300);
    pillar_inverse_x.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 255, 0, 0);
    pillar_inverse_x.rotate(Sp3dV3D(0, 1, 0), -90 * 3.14 / 180);
        objs.add(pillar_inverse_x);


    Sp3dObj arrow_inverse_y = UtilSp3dGeometry.cone(5, 10);
    arrow_inverse_y.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 55, 255, 0);
    arrow_inverse_y.rotate(Sp3dV3D(-1, 0, 0), -90 * 3.14 / 180);
    arrow_inverse_y.move(Sp3dV3D(0, -300, 0));
    objs.add(arrow_inverse_y);

    Sp3dObj pillar_inverse_y = UtilSp3dGeometry.pillar(2, 2, 300);
    pillar_inverse_y.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = Color.fromARGB(255, 55, 255, 0);
    pillar_inverse_y.rotate(Sp3dV3D(-1, 0, 0), -90 * 3.14 / 180);
        objs.add(pillar_inverse_y);

    Sp3dObj arrow_inverse_z = UtilSp3dGeometry.cone(5, 10);
    arrow_inverse_z.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 47, 255);
    arrow_inverse_z.rotate(Sp3dV3D(0, 0, 0), 180 * 3.14 / 180);
    arrow_inverse_z.move(Sp3dV3D(0, 0, -300));
    objs.add(arrow_inverse_z);

    Sp3dObj pillar_inverse_z = UtilSp3dGeometry.pillar(2, 2, 300);
    pillar_inverse_z.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 47, 255);
    pillar_inverse_z.rotate(Sp3dV3D(0, 0, 0), 180 * 3.14 / 180);
        objs.add(pillar_inverse_z);

    Sp3dObj cube = UtilSp3dGeometry.cube(250, 5, 300, 1, 1, 1);
    cube.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

    // THIS ONE IS FOR XY:
    cube.move(Sp3dV3D(0, 0, -150)); // Move the cube left
    cube.rotate(Sp3dV3D(1, 0, 0), 90 * 3.14 / 180);

    // THIS ONE IS FOR YZ:
    //cube.move(Sp3dV3D(0, 0, -150)); // Move the cube left
    //cube.rotate(Sp3dV3D(0, 0, 1), -90 * 3.14 / 180);

    // THIS ONE IS FOR ZX:
    //cube.move(Sp3dV3D(0, 0, -150)); // Move the cube left
    //cube.rotate(Sp3dV3D(0, 1, 0), -90 * 3.14 / 180);

    objs.add(cube);
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
      appBar: AppBar(title: const Text("3D Graph Page")),
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
            top: screenHeight * 0.1,
            right: 20,
            child: Container(
              width: 125,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(92, 0, 0, 0).withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Axis Legend",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: const Color.fromARGB(
                            255, 255, 0, 0), // X axis color
                      ),
                      SizedBox(width: 10),
                      Text("X Axis", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: const Color.fromARGB(
                            255, 0, 255, 0), // Y axis color
                      ),
                      SizedBox(width: 10),
                      Text("Y Axis", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: const Color.fromARGB(
                            255, 0, 0, 255), // Z axis color
                      ),
                      SizedBox(width: 10),
                      Text("Z Axis", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              children: [
                Text("Zoom Level: ${zoomLevel.toStringAsFixed(2)}"),
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
          ),
        ],
      ),
    );
  }
}
