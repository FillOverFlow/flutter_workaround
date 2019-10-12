import 'package:flutter/material.dart';
import 'package:work_around/screen/authentication_module/login_design_screen.dart';
import 'package:work_around/screen/home.dart';
import 'package:work_around/widget/google_map_screen.dart';
import 'package:work_around/screen/settime_module/list_time_running.dart';

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkAroud application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomeScreen(null),
      routes: <String, WidgetBuilder>{
        "/Login": (BuildContext context) => LoginScreen(),
        "/Map": (BuildContext context) => MapScreen()
      },
    );
  }
}
