import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:work_around/screen/authentication_module/login_design_screen.dart';
import 'package:work_around/screen/running_history_module/running_history.dart';
import 'package:work_around/screen/running_module/running.dart';
import 'package:work_around/screen/settime_module/list_time_running.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:work_around/screen/setting_module/setting.dart';

class HomeScreen extends StatefulWidget {
  var email;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  Firestore firestore = Firestore();
  var width = "0";
  var height = "0";
  var _bmi = 0.0;
  var email = "";
  String image_path = "";
  String detail = "";

  @override
  void initState() {
    setData_user();
    // get_current_user();
    super.initState();
  }

  Future set_bmi() {
    print("== set_bmi() ==");
    setState(() {
      var _height = int.parse(height);
      var _width = int.parse(width);

      print("=======================================");
      print("Get height : ${_height}");
      print("=======================================");

      var _bmi2 = _width / ((_height / 100) * (_height / 100));
      _bmi = _bmi2;
      print("bmi: ${_bmi}");
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
    // await set_bmi();
  }

  Future get_current_user() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("user now ${user.email}");
    return user;
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  Future _queryProfile() async {
    print("== _queryProfile() ==");
    var user = await get_current_user();
    setState(() {
      email = user.email;
    });
    firestore
        .collection('profile')
        .where('email', isEqualTo: "admin@admin.com")
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
              print("found weight ${doc['weight']} ");
              print("found height ${doc['height']} ");

              print("=======================================");
              print("Fuck : ${doc['height']}");
              print("=======================================");

              // set_bmi();
              print("WTF : ${doc['weight']}");
              width = doc['weight'];
              height = doc['height'];

              set_bmi();

              print(":)");

              // setState(() {
              // width = doc['weight'];
              // height = doc['height'];
              // });
            }));
  }

  @override
  Widget build(BuildContext context) {
    // set_bmi();
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
                //Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RunningHistory()));
              },
            ),
            new Divider(),
            new ListTile(
                title: new Text("ตั้งค่า"),
                trailing: new Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Setting(email)));
                }),
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
              Text("น้ำหนัก: ${width}"),
              _bmi > 1
                  ? Text("ค่าดัชนีมลวกาย (BMI):" +
                      "${_bmi.toStringAsFixed(_bmi.truncateToDouble() == _bmi ? 0 : 2)}")
                  : Text("ค่าดัชนีมลวกาย (BMI):" + "${_bmi}"),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 3.0,
                // child: Column(
                //   children: <Widget>[Text(detail), Image.asset(image_path)],
                // ),
                child: Column(
                    // child: condition == true ? new Container() : new Container()
                    // condition? Text("True"): null
                    children: <Widget>[
                      Text(detail),
                      image_path != "" ? Image.asset(image_path) : Container()
                    ]),
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
