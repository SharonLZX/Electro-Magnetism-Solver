import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:window_size/window_size.dart';
import 'package:electro_magnetism_solver/main/app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void setupWindow(){
  if (kIsWeb){
    setWindowMinSize(const Size(360, 640));
    setWindowMaxSize(const Size(360, 640));
  }
}
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupWindow();
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}