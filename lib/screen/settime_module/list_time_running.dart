import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:work_around/plugin/notification_plugin.dart';
import 'dart:async';

import 'package:work_around/screen/settime_module/set_time_running.dart';

class ListNotificationScreen extends StatefulWidget {
  @override
  final String date_string;
  final String time_string;
  ListNotificationScreen(this.date_string, this.time_string);
  _ListNotificationScreenState createState() =>
      _ListNotificationScreenState(this.date_string, this.time_string);
}

class _ListNotificationScreenState extends State<ListNotificationScreen> {
  final String date_string;
  final String time_string;

  _ListNotificationScreenState(this.date_string, this.time_string);
  /* variable */
  List<String> _scheduList = [];
  Future<List<PendingNotificationRequest>> notificationFuture;

  DateTime _date;
  TimeOfDay _time;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final NotificationPlugin _notificationPlugin = NotificationPlugin();

  String message;

  /* fucntion module */
  @override
  void initState() {
    var datetime_schedu;
    message = "No message.";
    print('you have datetime ${date_string}');
    if (date_string != null) {
      datetime_schedu = date_string + '  ' + time_string;
      _addScheduItems(datetime_schedu);
    }
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
    super.initState();
    notificationFuture = _notificationPlugin.getScheduledNotifications();
  }

  void _addScheduItems(String schedu) {
    if (schedu.length > 0)
      setState(() {
        _scheduList.add(schedu);
      });
  }

  void _removeScheduItem(int index) {
    setState(() {
      _scheduList.removeAt(index);
    });
  }

  void sendNotificationTime() async {
    var timenow = DateTime.now();
    var scheduledNotificationDateTime = timenow;
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        111,
        'scheduled title',
        'scheduled body',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
    print('send.. $scheduledNotificationDateTime');
    Navigator.of(context).pop();
  }

  /*Future function */
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked_time = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    //logic select time
    if (picked_time != null && picked_time != _date) {
      print("Date selected ${_time.toString()}");
      setState(() {
        _time = picked_time;
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2020));

    //logic select time
    if (picked != null && picked != _date) {
      print("Date selected ${picked.toString()}");
      setState(() {
        _date = picked;
      });
      print("Date change ${_date.toString()}");
    }
  }

  /* Widget module */
  Widget _scheduItemslist() {
    return ListView.builder(itemBuilder: (context, index) {
      if (index < _scheduList.length) {
        return _scheduItem(_scheduList[index], index);
      }
    });
  }

  Widget _removeWidget(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('do you want to remove this Schedu ?'),
            actions: <Widget>[
              FlatButton(
                child: Text('cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('remove'),
                onPressed: () {
                  _removeScheduItem(index);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget _scheduItem(String scheduText, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[300],
        child: Text('${index + 1}'),
      ),
      trailing: Icon(Icons.delete),
      title: Text(scheduText),
      onTap: () => _removeWidget(index),
    );
  }

  void _setTimeScreen() {
    //push this page onto the stack
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('settime'),
          ),
          body: Center(
            child: Container(
              margin: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('${_date.toString()}'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: RaisedButton(
                            child: Text('choose datetime'),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('${_time.toString()}'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: RaisedButton(
                            child: Text('choose time'),
                            onPressed: () {
                              _selectTime(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      GestureDetector(
                        onTap: sendNotificationTime,
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'set time'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void show() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SetTimeRunning()));
  }

  /* Build module */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการแจ้งเตือนการวิ่ง'),
      ),
      body: _scheduItemslist(),
      floatingActionButton: FloatingActionButton(
        onPressed: show,
        tooltip: 'add schedu items',
        child: Icon(Icons.add),
      ),
    );
  }
}
