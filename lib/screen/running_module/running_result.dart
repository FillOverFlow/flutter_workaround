import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_around/screen/home.dart';
import 'package:work_around/widget/google_map_screen.dart';

class RunningResultScreen extends StatefulWidget {
  @override
  _RunningResultState createState() => _RunningResultState();
}

class _RunningResultState extends State<RunningResultScreen> {
  void intiState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  void linkto_home() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                  child: MapScreen(null, null),
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
