import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:work_around/screen/running_module/running_result.dart';

class RunningHistory extends StatefulWidget {
  @override
  _RunningHistoryState createState() => _RunningHistoryState();
}

class _RunningHistoryState extends State<RunningHistory> {
  Position start_location;
  Position end_location;
  var email = "";

  @override
  void initState() {
    query_history();
    super.initState();
  }

  query_history() async {
    var user = await get_current_user();
    setState(() {
      email = "${user.email}";
    });
  }

  Future get_current_user() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("user now ${user.email}");
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ประวัติการวิ่ง"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('history')
              .where("user", isEqualTo: email)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    start_location = Position(
                        latitude: document['start_locatio_lat'],
                        longitude: document['start_location_lng']);
                    end_location = Position(
                        latitude: document['end_location_lat'],
                        longitude: document['end_location_lng']);
                    return new ListTile(
                      leading: Icon(Icons.history),
                      onTap: () {
                        print("start_locaiont ${start_location}");
                        //Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RunningResultScreen(
                                    start_location,
                                    end_location,
                                    document['runningId'],
                                    document['record'])));
                      },
                      title: new Text(document['datetime']),
                      subtitle: new Text(document['record']),
                    );
                  }).toList(),
                );
            }
          },
        ));
  }
}
