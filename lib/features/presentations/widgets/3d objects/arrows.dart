import 'package:flutter/material.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

class AxisObj {
  // X-axis: 1, Y-axis: 2, Z-axis: 3
  List<Color> colorLst = const [
    Color.fromARGB(255, 255, 0, 0),
    Color.fromARGB(255, 55, 255, 0),
    Color.fromARGB(255, 0, 47, 255)
  ];

  List<double> radLst = const [-1.57, -1.57, 3.14];

  List<Sp3dV3D> v3dLst = [
    Sp3dV3D(0, 1, 0),
    Sp3dV3D(-1, 0, 0),
    Sp3dV3D(0, 0, 0)
  ];

  List<Sp3dV3D> coordLst = [
    Sp3dV3D(-300, 0, 0),
    Sp3dV3D(0, -300, 0),
    Sp3dV3D(0, 0, -300),
  ];

  Sp3dObj createCone() {
    return UtilSp3dGeometry.cone(5, 10);
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

  Sp3dObj createArrow(int axis) {
    Sp3dObj arrInv = createCone();
    arrInv.materials[0] = addMaterial(axis);
    arrInv = rotateObj(arrInv, axis);
    arrInv = moveObj(arrInv, axis);
    return arrInv;
  }

  Sp3dObj createAxis() {
    return UtilSp3dGeometry.pillar(2, 2, 300);
  }

  Sp3dObj createPillar(int axis) {
    Sp3dObj pilInv = createAxis();
    pilInv.materials[0] = addMaterial(axis);
    pilInv = rotateObj(pilInv, axis);
    return pilInv;
  }
}
