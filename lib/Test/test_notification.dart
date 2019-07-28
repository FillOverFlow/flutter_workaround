import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class TextNotification extends StatefulWidget {
  @override
  _TextNotificationState createState() => _TextNotificationState();
}

class _TextNotificationState extends State<TextNotification> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
 
  @override
  void initState() {
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

  sendNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(channelId,
        channelName, channelDescription,
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
 
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
 
    await flutterLocalNotificationsPlugin.show(111, 'Hello, benznest.',
        'This is a your notifications. ', platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
  }

  sendNotificationTime() async {
    var timenow = DateTime.now();
    var scheduledNotificationDateTime =
        timenow;
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
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('notification'),),
      body: Center(
      child: RaisedButton(
        onPressed: sendNotificationTime,
        child: Text('Send Notification'),
        ),
      ) ,
    );
  }
}