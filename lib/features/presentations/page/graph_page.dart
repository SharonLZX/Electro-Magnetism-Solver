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

  /*void create_arrow_z_axis(double x, double y) {
    for (double z = -5; z < 6; z++) {
      Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
      arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

      //Sp3dV3D(0, -1, 0) is the axis of the arrow - use either 0, 1, or -1.
      arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
      //50 is the distance from the origin to 1 square
      arrow.move(Sp3dV3D(50 * x, 50 * y, 50 * z));
      objs.add(arrow);
    }
  }*/
  /*void create_arrow_y_axis(double x) {
    for (double y = -5; y < 6; y++) {
      Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
      arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

      //Sp3dV3D(0, -1, 0) is the axis of the arrow - use either 0, 1, or -1.
      arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
      //50 is the distance from the origin to 1 square
      arrow.move(Sp3dV3D(50 * x, 50 * y, 0));
      objs.add(arrow);
      create_arrow_z_axis(x, y);
    }
  }*/

  @override
  void initState() {
    super.initState();
    objs = UtilSp3dCommonParts.coordinateArrows(300); // Create XYZ arrows
    //objs.addAll(UtilSp3dCommonParts.worldMeshes(255)); // Add world meshes (optional)

    /*for (double x = 0; x < 6; x++) {
      /// * [r] : radius.
      /// * [h] : height.
      /// * [fragments] : The number of triangles that make up a circle. The more it is, the smoother it becomes.
      /// Divide the area for the angle specified by theta by this number of triangles.
      /// * [theta] : 360 for a circle. 180 for a semicircle. The range is 1-360 degrees.
      /// * [isClosedBottom] : If true, close bottom. otherwise open.
      /// * [isClosedSide] : If true, close the side on the start point side and the side on the end point side. otherwise open.
      /// * [material] : face material
      ///
      Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
      arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

      //Sp3dV3D(0, 1, 0) is the axis of the arrow - use either 0, 1, or -1.
      arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
      //50 is the distance from the origin to 1 square
      arrow.move(Sp3dV3D(50 * x, 0, 0));
      objs.add(arrow);
      create_arrow_y_axis(x);
    }*/

    /// * [w] : width.
    /// * [h] : height.
    /// * [d] : depth.
    /// * [wSplit] : Number of divisions in the width direction. Must be 1 or more.
    /// * [hSplit] : Number of divisions in the height direction. Must be 1 or more.
    /// * [dSplit] : Number of divisions in the depth direction. Must be 1 or more.
    /// * [material] : face material
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

  void create_axes() {
    create_arrow_x_axis();
    create_arrow_y_axis();
    create_arrow_z_axis();
  }

  void create_arrow_x_axis() {
    for (double x = -5; x < 6; x++) {
      Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
      arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

      if (x >= 0) {
        arrow.move(Sp3dV3D(50 * x, 0, 0)); // Move to positive x-axis
      } else {
        arrow.move(Sp3dV3D(50 * x, 0, 0)); // Move to negative x-axis
        arrow.rotate(Sp3dV3D(0, 1, 0),
            180 * 3.14 / 180); // Flip the direction of the arrow
      }

      arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
      objs.add(arrow);
    }
  }

  void create_arrow_y_axis() {
    for (double y = -5; y < 6; y++) {
      Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
      arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

      if (y >= 0) {
        arrow.move(Sp3dV3D(0, 50 * y, 0)); // Move to positive y-axis
      } else {
        arrow.move(Sp3dV3D(0, 50 * y, 0)); // Move to negative y-axis
        arrow.rotate(Sp3dV3D(1, 0, 0),
            180 * 3.14 / 180); // Flip the direction of the arrow
      }

      arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
      objs.add(arrow);
    }
  }

  void create_arrow_z_axis() {
    for (double z = -5; z < 6; z++) {
      Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
      arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

      if (z >= 0) {
        arrow.move(Sp3dV3D(0, 0, 50 * z)); // Move to positive z-axis
      } else {
        arrow.move(Sp3dV3D(0, 0, 50 * z)); // Move to negative z-axis
        arrow.rotate(Sp3dV3D(1, 0, 0),
            180 * 3.14 / 180); // Flip the direction of the arrow
      }

      arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
      objs.add(arrow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust camera position based on zoom level (distance from the scene)
    Sp3dCamera camera = Sp3dCamera(
      Sp3dV3D(0, 200,
          1000 * zoomLevel), // Camera position on Z-axis (zooming in/out)
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
                  value: zoomLevel,
                  min: 0.1, // Minimum zoom level (zoom out)
                  max: 2.0, // Maximum zoom level (zoom in)
                  onChanged: (double value) {
                    setState(() {
                      zoomLevel = value;
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
