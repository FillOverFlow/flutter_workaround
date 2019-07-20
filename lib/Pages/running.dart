import 'package:flutter/material.dart';
import 'package:work_around/Pages/timer.dart';
import 'package:work_around/Pages/profile.dart';

class RunningPage extends StatelessWidget {
  RunningPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Running"),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: TimerPage()
        ),
    );
  }
}