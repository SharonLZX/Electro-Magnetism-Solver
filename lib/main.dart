import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:window_size/window_size.dart';
import 'package:electro_magnetism_solver/app.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:electro_magnetism_solver/data/local/database_helper.dart';

void setupWindow(){
  if (kIsWeb){
    // If is web (e.g. Chrome), then set the min and max size.
    setWindowMinSize(const Size(360, 640));
    setWindowMaxSize(const Size(360, 640));
  }
}

// Create a new instance of the database handler.
//DBHandler dbhandler = DBHandler();

Future<void> main() async{

  // Ensure that the widgets binding is initialized.
  WidgetsFlutterBinding.ensureInitialized();  

  // Finds out which platform the app is running on.
  setupWindow(); 

  // Open the database.
  //dbhandler.openDB(); 

  // Ensure that the screen size is set.
  await ScreenUtil.ensureScreenSize(); 

  // Set the WebView platform to Android.
  //WebViewPlatform.instance = AndroidWebViewPlatform(); 
  runApp(const MyApp());  
}