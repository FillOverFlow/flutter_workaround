import 'package:flutter/material.dart';
import 'package:work_around/widget/google_map_screen.dart';
import 'screen/splash_screen.dart';
import 'package:work_around/screen/authentication_module/login_design_screen.dart';
import 'test/run_test.dart';

void main() => runApp(TestApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkAroud application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/Login": (BuildContext context) => LoginScreen(),
        "/Map": (BuildContext context) => MapScreen()
      },
    );
  }
}
