import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_around/screen/home.dart';
import 'package:work_around/widget/google_map_screen.dart';
import 'package:work_around/widget/map_result.dart';

class RunningResultScreen extends StatefulWidget {
  @override
  var _start_location;
  var _end_location;
  RunningResultScreen(this._start_location, this._end_location);
  _RunningResultState createState() =>
      _RunningResultState(this._start_location, this._end_location);
}

class _RunningResultState extends State<RunningResultScreen> {
  var _start_location;
  var _end_location;

  _RunningResultState(this._start_location, this._end_location);
  void intiState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  void linkto_home() {
    print('[success] start location ${_end_location.longitude}');
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('running result')),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  //Card for map
                  width: 400,
                  height: 300,
                  child: MapScreenResult(_start_location, _end_location),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'สรุปผลการวิ่ง',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'วิ่งระยะทางทั้งหมด:',
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '10 km.',
                            ),
                          )
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'ใช้เวลาทั้งหมด',
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '1 hr.',
                            ),
                          )
                        ],
                      ),
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'เผาผลาญ แคลโลลี่โดยประมาณ',
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              '350 kcal.',
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: RaisedButton(
                          onPressed: linkto_home,
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 45,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFf45d27),
                                    Color(0xFFf5851f)
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: Center(
                              child: Text(
                                'Save History'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
