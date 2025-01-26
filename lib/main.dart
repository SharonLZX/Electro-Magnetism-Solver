import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:window_size/window_size.dart';
import 'package:electro_magnetism_solver/app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:electro_magnetism_solver/data/local/database_helper.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

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
  WebViewPlatform.instance = AndroidWebViewPlatform();
  runApp(const MyApp());
}