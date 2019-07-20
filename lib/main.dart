import 'package:flutter/material.dart';
import 'package:work_around/Pages/timer.dart';
import 'Pages/signIn.dart';



void main() => runApp(MainApp());

class MainApp extends StatelessWidget{
  @override 
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'WorkAroud application',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: SignInPage(),
      // routes: <String,WidgetBuilder>{
      //   "/a": (BuildContext context) => new BlankPage("title"),
       //}
       );
  }
}

   

