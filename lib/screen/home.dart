import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:work_around/screen/authentication_module/login_design_screen.dart';
import 'package:work_around/screen/running_history_module/running_history.dart';
import 'package:work_around/screen/running_module/running.dart';
import 'package:work_around/screen/settime_module/list_time_running.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  var email;
  HomeScreen(this.email);
  @override
  _HomePageState createState() => _HomePageState(this.email);
}

class _HomePageState extends State<HomeScreen> {
  //database reference
  FirebaseDatabase database = new FirebaseDatabase();
  FirebaseDatabase database2 = new FirebaseDatabase();
  Firestore firestore = Firestore();
  var width;
  var height;
  var _bmi;
  var email;
  String image_path;
  String detail;

  _HomePageState(this.email);

  @override
  void initState() {
    // TODO: implement initState
    setData_user();
    super.initState();
    // _queryProfile();
    // database
    //     .reference()
    //     .child('profile')
    //     .child("finfin")
    //     .child("width")
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    //   setState(() {
    //     width = "${snapshot.value}";
    //   });
    // });
    // database2
    //     .reference()
    //     .child('profile')
    //     .child("finfin")
    //     .child("height")
    //     .once()
    //     .then((DataSnapshot snapshot) {
    //   print('Connected to second database and read ${snapshot.value}');
    //   setState(() {
    //     height = "${snapshot.value}";
    //   });
    // });
  }

  void set_bmi() {
    print("in set bmi");
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

  Future setData_user() async {
    await _queryProfile();
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  void _queryProfile() {
    print("in query");
    firestore
        .collection('profile')
        .where('email', isEqualTo: email)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
              print("found weight ${doc['weight']} ");
              print("found weight ${doc['height']} ");
              setState(() {
                width = doc['weight'];
                height = doc['height'];
              });
            }));
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
              accountEmail: new Text(email),
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
              Text("ค่าดัชนีมลวกาย (BMI):" +
                  "${_bmi.toStringAsFixed(_bmi.truncateToDouble() == _bmi ? 0 : 2)}"),
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
