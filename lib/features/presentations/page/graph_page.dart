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

  @override
  void initState() {
    super.initState();
    objs = UtilSp3dCommonParts.coordinateArrows(100);
    objs.addAll(UtilSp3dCommonParts.worldMeshes(255));

    void create_arrow_z_axis(double x, double y){
      for (double z = 0; z < 6; z++) {
        Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
        arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
          ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

        //Sp3dV3D(0, -1, 0) is the axis of the arrow - use either 0, 1, or -1.
        arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
        //50 is the distance from the origin to 1 square
        arrow.move(Sp3dV3D(50*x, 50 * y, 50*z));
        objs.add(arrow);
      }
    }

    void create_arrow_y_axis(double x) {
      for (double y = 0; y < 6; y++) {
        Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
        arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
          ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

        //Sp3dV3D(0, -1, 0) is the axis of the arrow - use either 0, 1, or -1.
        arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
        //50 is the distance from the origin to 1 square
        arrow.move(Sp3dV3D(50*x, 50 * y, 0));
        objs.add(arrow);
        create_arrow_z_axis(x, y);
      }
    }

    for (double x = 0; x < 6; x++) {
        Sp3dObj arrow = UtilSp3dGeometry.cone(10, 20);
      arrow.materials[0] = FSp3dMaterial.grey.deepCopy()
        ..strokeColor = const Color.fromARGB(255, 0, 255, 0);

      //Sp3dV3D(0, -1, 0) is the axis of the arrow - use either 0, 1, or -1.
      arrow.rotate(Sp3dV3D(0, -1, 0), -90 * 3.14 / 180);
      //50 is the distance from the origin to 1 square
      arrow.move(Sp3dV3D(50 * x, 0, 0));
      objs.add(arrow);
      create_arrow_y_axis(x);
    }

    /*Sp3dObj cube = UtilSp3dGeometry.cube(500, 5, 10, 4, 4, 4);
    cube.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 255, 0);
    cube.move(Sp3dV3D(-200, 0, 0)); // Move the cube left
    objs.add(cube);*/

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

    return Container(
      color: Colors.black,
      child: Center(
        child: Sp3dRenderer(
          const Size(2000, 2000),
          Sp3dV2D(screenWidth / 2, screenHeight / 2),
          world,
          Sp3dCamera(Sp3dV3D(0, 200, 1000), 1000,
              rotateAxis: Sp3dV3D(0, 1, 0), radian: -0.79),
          Sp3dLight(Sp3dV3D(0, 0, -1), syncCam: true),
        ),
      ),
    );
  }
}
