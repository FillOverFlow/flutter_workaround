import 'package:flutter/material.dart';
import 'package:work_around/Pages/running_history.dart';
import 'package:work_around/Pages/running.dart';
import 'package:work_around/Pages/send_data_firebase.dart';
import 'package:work_around/Pages/profile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
              onDetailsPressed: link_to_profiling,
            ),
            new ListTile(
              title: new Text("หน้าแรก"),
              trailing: new Icon(Icons.home),
            ),
            new ListTile(
              title:new Text("เริ่มวิ่งกันเลย"),
              trailing: new Icon(Icons.directions_run),
              onTap:() { 
                Navigator.of(context).pop();
                Navigator.push(context,MaterialPageRoute(builder:(context) => RunningPage()));
                }
            ),
            new ListTile(
              title:new Text("ประวัติการวิ่ง"),
              trailing: new Icon(Icons.history),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(context,MaterialPageRoute(builder: (context) => RunningHistory()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("ตั้งค่า"),
              trailing: new Icon(Icons.settings),
            ),
            new ListTile(
              title: new Text("ปิด"),
              trailing: new Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
      body: 
        Container(
          child:
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("ส่วนสูง:xxx"),
                  Text("น้ำหนัก:xxx"),
                  Card(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(15.0)),
                    elevation: 3.0,
                    child: Column(
                      children: <Widget>[
                        Text("knowleadge"),
                        Image.asset("assets/images/running.jpg")
                      ],
                    ),
                  ),
                ],
            ),
      ),
    );
  }

  void link_to_profiling(){
    Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}