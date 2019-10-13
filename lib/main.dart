import 'package:flutter/material.dart';
import 'package:work_around/screen/home.dart';
import 'package:work_around/test/list_view_could.dart';
import 'package:work_around/widget/google_map_screen.dart';
import 'screen/splash_screen.dart';
import 'package:work_around/screen/authentication_module/login_design_screen.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkAroud application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/Login": (BuildContext context) => LoginScreen(),
        "/Map": (BuildContext context) => MapScreen(),
        "/home": (BuildContext context) => HomeScreen()
      },
    );
  }
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkAroud application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: ListViewClound(),
    );
  }
}
