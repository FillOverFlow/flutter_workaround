import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:work_around/screen/authentication_module/login_design_screen.dart';
import 'package:work_around/screen/running_history_module/running_history.dart';
import 'package:work_around/screen/running_module/running.dart';
import 'package:work_around/screen/settime_module/list_time_running.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  //database reference
  FirebaseDatabase database = new FirebaseDatabase();
  FirebaseDatabase database2 = new FirebaseDatabase();
  var width;
  var height;
  var _bmi;
  String image_path;
  String detail;
  var profile =
      FirebaseDatabase.instance.reference().child("profile").child("finfin");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database
        .reference()
        .child('profile')
        .child("finfin")
        .child("width")
        .once()
        .then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
      setState(() {
        width = "${snapshot.value}";
      });
    });
    database2
        .reference()
        .child('profile')
        .child("finfin")
        .child("height")
        .once()
        .then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
      setState(() {
        height = "${snapshot.value}";
      });
    });
  }

  void set_bmi() {
    setState(() {
      var _height = int.parse(height);
      var _width = int.parse(width);
      _bmi = _width / ((_height / 100) * (_height / 100));
      if (_bmi > 22.90) {
        image_path = "assets/images/fat.jpg";
        detail = "เริ่มอ้วน";
      } else {
        image_path = "assets/images/running.jpg";
        detail = "สุขภาพดี";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    set_bmi();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('หน้าหลัก'),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text("Fin Fin"),
              accountEmail: new Text("Fin@gmail.com"),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.lightBlue,
                child: new Text("F"),
              ),
              onDetailsPressed: null,
            ),
            new ListTile(
              title: new Text("หน้าแรก"),
              trailing: new Icon(Icons.home),
            ),
            new ListTile(
                title: new Text("เริ่มวิ่งกันเลย"),
                trailing: new Icon(Icons.directions_run),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RunningPage()));
                }),
            new ListTile(
                title: new Text("ตั้งเวลาการวิ่ง"),
                trailing: new Icon(Icons.access_alarm),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ListNotificationScreen(null, null)));
                }),
            new ListTile(
              title: new Text("ประวัติการวิ่ง"),
              trailing: new Icon(Icons.history),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RunningHistory()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("ตั้งค่า"),
              trailing: new Icon(Icons.settings),
            ),
            new ListTile(
                title: new Text("ปิด"),
                trailing: new Icon(Icons.exit_to_app),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                })
          ],
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("ส่วนสูง: ${height}"),
              Text("น้ำหนัก:${width}"),
              Text("ค่าดัชนีมลวกาย (BMI):${_bmi}"),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 3.0,
                child: Column(
                  children: <Widget>[Text(detail), Image.asset(image_path)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void link_to_profiling(){
  //   Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage()));
  // }
}
