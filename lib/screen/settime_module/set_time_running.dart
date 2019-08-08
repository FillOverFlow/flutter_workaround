import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:work_around/screen/settime_module/schedu.dart';
import 'list_time_running.dart';


class SetTimeRunning extends StatefulWidget {
  @override
  _SetTimeRunningState createState() => _SetTimeRunningState();
  
}

class _SetTimeRunningState extends State<SetTimeRunning> {

  DateTime _date;
  TimeOfDay _time;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  @override
  void initState() {
     setState(() {
      _date = new DateTime.now();
      _time = new TimeOfDay.now();
    });
    message = "No message.";
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
  }

  sendNotificationTime() async {
    var timealert = DateTime(_date.year,_date.month,_date.day,_time.hour,_time.minute);
    var scheduledNotificationDateTime =
        timealert;
    var androidPlatformChannelSpecifics =
        new AndroidNotificationDetails('your other channel id',
            'your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      111,
      'scheduled title',
      'scheduled body',
      scheduledNotificationDateTime,
      platformChannelSpecifics
      );
      print('send.. $scheduledNotificationDateTime');

      //reformat datetime 
      String format_date = DateFormat('dd-MM-yyyy').format(_date);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ListNotificationScreen(format_date,_time.toString())));
      
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker( 
      context: context,
      initialDate: _date,
      firstDate: new DateTime(2016),
      lastDate: new DateTime(2020)
    );

    //logic select time
     if(picked !=null  && picked != _date){
       print("Date selected ${_date.toString()}");
       setState(() {
         _date = picked;
         //change format _date to dd-MM-yyyy
       });
     }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked_time = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    //logic select time
     if(picked_time !=null  && picked_time != _date){
       print("Date selected ${_time.toString()}");
       setState(() {
         _time = picked_time;
       });
     }
  }

  // _scheduleNotification() async {
  //   int notificationoId = await ScheduledNotifications.scheduleNotification(
  //     new DateTime.now().add(new Duration(seconds: 5)).millisecondsSinceEpoch, 
  //     "ticker", 
  //     "contentTitle", 
  //     "content"
  //     );
  //   print('alert $notificationoId');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('set time running'),),
      body: Center( 
        child:Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child:Align(
                        alignment: Alignment.topLeft,
                        child: Text('${_date.toString()}'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child:Align(
                        alignment: Alignment.topRight,
                        child:
                          RaisedButton( 
                          child: Text('choose datetime'),
                          onPressed: (){_selectDate(context);},
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child:Align(
                        alignment: Alignment.topLeft,
                        child: Text('${_time.toString()}'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child:Align(
                        alignment: Alignment.topRight,
                        child:
                          RaisedButton( 
                          child: Text('choose time'),
                          onPressed: (){_selectTime(context);},
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
                          margin: EdgeInsets.all(0.0),
                          height: 45,
                          width: MediaQuery.of(context).size.width/1.2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFf45d27),
                                Color(0xFFf5851f)
                              ],
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50)
                            )
                          ),
                          child: Center(
                            child:   Text('set time'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
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
    }
}