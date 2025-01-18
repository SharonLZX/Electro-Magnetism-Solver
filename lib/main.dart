import 'package:electro_magnetism_solver/db_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:window_size/window_size.dart';
import 'package:electro_magnetism_solver/main/app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void setupWindow(){
  if (kIsWeb){
    setWindowMinSize(const Size(360, 640));
    setWindowMaxSize(const Size(360, 640));
  }
}

DBHandler dbhandler = DBHandler();
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupWindow();
  dbhandler.openDB();
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}