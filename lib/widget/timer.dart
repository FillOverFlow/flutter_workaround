/**
 * calculate time and add geolocation in to firebase
 */
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:work_around/models/history.dart';
import 'package:work_around/models/dependencies.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:work_around/screen/running_module/running_result.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  var _start_location;
  var _end_location;
  var currentLocation;
  var _milliseconds;

  /** var reference */
  String history_string = "";
  List<History> historys = List();
  History history;
  Location location = new Location();
  Geoflutterfire geo = Geoflutterfire();
  DatabaseReference historyRef;
  Firestore firestore = Firestore();
  DateTime datetime;
  final database = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    history = History("", "", "");
    historyRef = database.reference().child('history');
    historyRef.onChildAdded.listen(_onEntryAdded);
    historyRef.onChildChanged.listen(_onEntryChanged);
    //createIdRunningRound();
  }

  //function to create id for query
  createIdRunningRound() async {
    //query last id
    print("in createid");
    return Firestore.instance
        .collection("locations")
        .orderBy("name")
        .limit(1)
        .snapshots()
        .listen((data) => data.documents
            .forEach((data) => print("test_id: ${data['name']}")));
  }

  //function get mylocation
  getCurrentLocation() async {
    String error = "";
    try {
      await Geolocator().getCurrentPosition().then((currloc) {
        setState(() {
          currentLocation = currloc;
        });
      });
      print(
          "current location: ${currentLocation.latitude} ${currentLocation.longitude}");
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      print('set currentLocation null');
      currentLocation = null;
    }
    return currentLocation;
  }

  //history var zone
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

  //Timer var zone
  final Dependencies dependencies = new Dependencies();
  void leftButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        print("${dependencies.stopwatch.elapsedMilliseconds}");
      } else {
        dependencies.stopwatch.reset();
      }
    });
  }

  void startButtonPressed() {
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        if (dependencies.stopwatch.isRunning) {
          dependencies.stopwatch.stop();
        } else {
          dependencies.stopwatch.start();
          _start_location = currloc;
          //calculate and send geolocation to firebase
          Timer.periodic(Duration(seconds: 5), (timer) {
            if (!dependencies.stopwatch.isRunning) {
              print("cancel time");
              timer.cancel();
            }
            print('send data:${DateTime.now()}');
            _addGeoPoint();
          });
        }
      });
    });
  }

  Future<DocumentReference> send_data_cloud_firestore(geo_data) {
    firestore.collection('locations').add({
      'position': geo_data,
      'running_id': 'running_001',
      'user': 'finfi',
      'created_at': DateTime.now()
    });
    print("send data success ${DateTime.now()}");
  }

  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    firestore.collection('locations').add({
      'position': point.data,
      'running_round': 'running002',
      'name': 'finfi',
      'created_at': DateTime.now()
    });
  }

  void finishRunningButtonPressed() {
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        if (dependencies.stopwatch.isRunning) {
          dependencies.stopwatch.stop();
          //display alert
          _showDialog();
          _end_location = currloc;
        } else {
          dependencies.stopwatch.reset();
        }
      });
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("การวิ่งเสร็จ เสร็จสิ้น !!!"),
          content: new Text("ยืนยัน ว่าการวิ่งเสร็จสมบรูณ์แล้วเก็บประวัติ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("วิ่งเสร็จแล้ว"),
              onPressed: () {
                Navigator.of(context).pop();
                dependencies.stopwatch.stop();
                save_record_to_history();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RunningResultScreen(
                            _start_location, _end_location, history_string)));
              },
            ),
            new FlatButton(
              child: new Text("ยกเลิก"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void save_record_to_history() {
    //create datetime format
    var now = new DateTime.now();
    var dateNow = new DateFormat("dd-MM-yyyy").format(now);

    _milliseconds = dependencies.stopwatch.elapsedMilliseconds;
    final int hundreds = (_milliseconds / 10).truncate();
    final int seconds = (hundreds / 100).truncate();
    final int minutes = (seconds / 60).truncate();
    setState(() {
      history_string = "${minutes} m ${seconds} s";
    });

    //set value to firebase
    history.record = "${minutes} m ${seconds} s";
    history.user = "finfin";
    history.datetime = '$now';

    try {
      historyRef.push().set(history.toJson());
      // database.child("history").set({
      //   "user":"finfin",
      //   "record":'${dependencies.stopwatch.elapsedMilliseconds}',
      //   "datetime":'${date_now}'
      // });
      print("send record success");
    } catch (e) {
      print("can't send $e");
    }
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
        backgroundColor: Colors.pink,
        heroTag: text,
        child: new Text(text, style: roundTextStyle),
        onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: new TimerText(dependencies: dependencies),
        ),
        new Expanded(
          flex: 0,
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // buildFloatingButton(dependencies.stopwatch.isRunning ? "lap" : "reset", leftButtonPressed),
                buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "เสร็จ" : "คืนค่า",
                    finishRunningButtonPressed),
                buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "พัก" : "เริ่ม",
                    startButtonPressed),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});
  final Dependencies dependencies;

  TimerTextState createState() =>
      new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});
  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    print("timer: ${timer}");
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
      );

      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new SizedBox(
            height: 90,
            child: new MinutesAndSeconds(dependencies: dependencies),
          ),
        ),
        new RepaintBoundary(
          child: new SizedBox(
            height: 90,
            child: new Hundreds(dependencies: dependencies),
          ),
        ),
      ],
    );
  }
}

class MinutesAndSeconds extends StatefulWidget {
  MinutesAndSeconds({this.dependencies});
  final Dependencies dependencies;

  MinutesAndSecondsState createState() =>
      new MinutesAndSecondsState(dependencies: dependencies);
}

class MinutesAndSecondsState extends State<MinutesAndSeconds> {
  MinutesAndSecondsState({this.dependencies});
  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes || elapsed.seconds != seconds) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return new Text('$minutesStr:$secondsStr.', style: dependencies.textStyle);
  }
}

class Hundreds extends StatefulWidget {
  Hundreds({this.dependencies});
  final Dependencies dependencies;

  HundredsState createState() => new HundredsState(dependencies: dependencies);
}

class HundredsState extends State<Hundreds> {
  HundredsState({this.dependencies});
  final Dependencies dependencies;

  int hundreds = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.hundreds != hundreds) {
      setState(() {
        hundreds = elapsed.hundreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');
    return new Text(hundredsStr, style: dependencies.textStyle);
  }
}
