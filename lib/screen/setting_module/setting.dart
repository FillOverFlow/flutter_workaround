import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:work_around/screen/authentication_module/login_design_screen.dart';
import 'package:flutter/services.dart';
import 'package:work_around/screen/home.dart';
import 'package:work_around/service/curd.dart';

class Setting extends StatefulWidget {
  String email;
  @override
  Setting(this.email);
  _SettingState createState() => _SettingState(this.email);
}

class _SettingState extends State<Setting> {
  _SettingState(this.email);

  Firestore firestore = Firestore();
  String email;
  crudMedthods crudObj = new crudMedthods();
  var width, height;
  var query;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    crudObj.getData(email).then((results) {
      print("result : $results");
      setState(() {
        query = results;
      });
    });
    super.initState();
  }

  Widget _listFirebase() {
    if (query != null) {
      return StreamBuilder(
          stream: query,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: EdgeInsets.all(5.0),
                itemBuilder: (context, i) {
                  print(
                      "snap shot data ${snapshot.data.documents[i].data['name']}");
                  return new ListTile(
                    title: Text(snapshot.data.documents[i].data['email']),
                    subtitle: Text(snapshot.data.documents[i].data['height'] +
                        " " +
                        "${snapshot.data.documents[i].data['weight']}"),
                    onTap: () {
                      null;
                      updateDialog(
                          context, snapshot.data.documents[i].documentID);
                    },
                    onLongPress: () {
                      null;
                      // crudObj.deleteData(snapshot.data.documents[i].documentID);
                    },
                  );
                },
              );
            }
          });
    } else {
      return Text("Loading ...");
    }
  }

  Future<bool> updateDialog(BuildContext context, selectedDoc) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update Data', style: TextStyle(fontSize: 15.0)),
            content: Container(
              height: 125.0,
              width: 150.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter new Weight'),
                    onChanged: (value) {
                      this.width = value;
                    },
                  ),
                  SizedBox(height: 5.0),
                  TextField(
                    decoration: InputDecoration(hintText: 'Enter new Height'),
                    onChanged: (value) {
                      this.height = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Update'),
                textColor: Colors.blue,
                onPressed: () => update_firebase_profile(selectedDoc),
              ),
              FlatButton(
                child: Text("Cancel"),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  update_firebase_profile(selectedDoc) {
    Navigator.of(context).pop();
    print("width ${width} height ${height}");
    crudObj.updateData(selectedDoc,
        {'weight': this.width, 'height': this.height}).then((result) {
      // dialogTrigger(context);
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Setting"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              })),
      body: Container(child: _listFirebase()),
    );
  }
}
