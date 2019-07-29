import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:work_around/models/history.dart';

class RunningHistory extends StatefulWidget {
  @override
  _RunningHistoryState createState() => _RunningHistoryState();
}

class _RunningHistoryState extends State<RunningHistory> {
  DatabaseReference historyRef;
  FirebaseDatabase database = new FirebaseDatabase();

  List<History> historys = List();
  History history;

  _onEntryAdded(Event event) {
    setState(() {
      historys.add(History.fromSnapshot(event.snapshot));
    });
  }
 _onEntryChanged(Event event) {
    var old = historys.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      historys[historys.indexOf(old)] = History.fromSnapshot(event.snapshot);
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    historyRef = database.reference().child('history');
    historyRef.onChildAdded.listen(_onEntryAdded);
    historyRef.onChildChanged.listen(_onEntryChanged);
    database.reference().child('history').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    
    
  }

  DatabaseReference getHistory(){
    return historyRef;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการวิ่ง'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(child: FirebaseAnimatedList(
            query: historyRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index){
              return new ListTile(
                  leading: Icon(Icons.history),
                  title: Text(historys[index].datetime),
                  subtitle: Text(historys[index].record),
                );
            },
          ),)
        ],
      ),
    );
  }

  // void show_data(){
  //   history
  // }
}