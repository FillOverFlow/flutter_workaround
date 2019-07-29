import 'package:flutter/material.dart';
import 'package:work_around/widget/google_map_screen.dart';
import 'package:work_around/widget/timer.dart';
import 'dart:async';


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
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                 SizedBox( //Card for map 
                  width: 400,
                  height: 300,
                  child: MapScreen(),
                ),
                SizedBox( //Card for timmer 
                  width: 400,
                  height: 200,
                  child: TimerPage(),
                ),
              ],
            ), 
          ],
          )
        ),
    );
  }
}