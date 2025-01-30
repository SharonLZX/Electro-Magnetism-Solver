import 'package:flutter/material.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

class PlaneObj {
  // X-axis: 1, Y-axis: 2, Z-axis: 3
  List<Color> colorLst = const [
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 255, 255),
    Color.fromARGB(255, 255, 255, 255)
  ];

  List<double> radLst = const [-1.57, -1.57, 3.14];

  List<Sp3dObj> objLst = [
    UtilSp3dGeometry.cube(250,5,250,1,1,1),
    UtilSp3dGeometry.cube(0,5,0,1,1,1),
    UtilSp3dGeometry.cube(0,5,0,1,1,1),
  ];

    List<Sp3dV3D> v3dLst = [
    Sp3dV3D(0, 1, 0),
    Sp3dV3D(-1, 0, 0),
    Sp3dV3D(0, 0, 0)
  ];

  List<Sp3dV3D> coordLst = [
    Sp3dV3D(125, 0, 0),
    Sp3dV3D(0, 125, 0),
    Sp3dV3D(0, 0, 50),
  ];

  Sp3dObj createPlane(int axis) {
    return objLst[axis];
  }

  Sp3dMaterial addMaterial(int axis) {
    return FSp3dMaterial.grey.deepCopy()..strokeColor = colorLst[axis];
  }

  Sp3dObj rotateObj(Sp3dObj obj, int axis) {
    return obj.rotate(v3dLst[axis], radLst[axis]);
  }

  Sp3dObj moveObj(Sp3dObj obj, int axis) {
    return obj.move(coordLst[axis]);
  }

  Sp3dObj createPlanes(int axis) {
    Sp3dObj planeInv = createPlane(axis);
    planeInv.materials[0] = addMaterial(axis);
    planeInv = rotateObj(planeInv, axis);
    planeInv = moveObj(planeInv, axis);
    return planeInv;
  }
}
