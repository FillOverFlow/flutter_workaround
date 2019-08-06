import 'package:flutter/material.dart';


class RunningHistory extends StatefulWidget {
  @override
  _RunningHistoryState createState() => _RunningHistoryState();
}

class _RunningHistoryState extends State<RunningHistory> {
  List<String> _places = <String>[]; //create place list empty string

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _places = new List.generate(99, (i) => "ประวัติการวิ่งที่ ($i)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ประวัติการวิ่ง"),
      ),
      body: Center(
        child: ListView(
          children: _places.map((place) => new Text(place)).toList(),
          ),
        )
    );
  }
}