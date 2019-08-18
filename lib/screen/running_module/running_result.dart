import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_around/screen/home.dart';
import 'package:work_around/widget/map_result.dart';
import 'dart:math' show cos, sqrt, asin;

class RunningResultScreen extends StatefulWidget {
  @override
  var _start_location;
  var _end_location;
  String history;
  RunningResultScreen(this._start_location, this._end_location, this.history);
  _RunningResultState createState() => _RunningResultState(
      this._start_location, this._end_location, this.history);
}

class _RunningResultState extends State<RunningResultScreen> {
  var _start_location;
  var _end_location;
  String history;

  _RunningResultState(this._start_location, this._end_location, this.history);

  double cal_distance_marker(lat1, lng1, lat2, lng2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double cal_kcal(weight, distance) {
    double kcal;
    return weight * distance * 1.036;
  }

  @override
  void intiState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  void linkto_home() {
    print('[success] start location ${_end_location.longitude}');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double distance_marker = cal_distance_marker(
        _start_location.latitude,
        _start_location.longitude,
        _end_location.latitude,
        _end_location.longitude);
    double kcal_from_running = cal_kcal(60, distance_marker);
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
                              '${distance_marker} km.',
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
                              '${history}',
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
                              '${kcal_from_running} kcal.',
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        child: GestureDetector(
                          onTap: linkto_home,
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
