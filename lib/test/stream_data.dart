import "package:flutter/material.dart";

class StreamData extends StatefulWidget {
  @override
  _StreamDataState createState() => _StreamDataState();
}

class _StreamDataState extends State<StreamData> {
  @override
  void initState() {
    print("Create a sample Stram ...");
    Stream<String> stream = new Stream.fromFuture(getData());
    print("Created stream");

    stream.listen((data) {
      print("DataReceived: " + data);
    }, onDone: () {
      print("Task Done");
    }, onError: (error) {
      print("Some Error");
    });
    print("code controller is herer");
  }

  Future<String> getData() async {
    await Future.delayed(Duration(seconds: 5)); //Create Delay
    print("Fetched Data");
    return "This a test data";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Center(
          child: Text("Stream Data"),
        ),
      ],
    ));
  }
}
