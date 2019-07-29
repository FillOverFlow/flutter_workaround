import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:work_around/plugin/notification_plugin.dart';
import 'package:work_around/screen/settime_module/set_time_running.dart';

class ListNotificationScreen extends StatefulWidget {
  @override
  _ListNotificationScreenState createState() => _ListNotificationScreenState();
}

class _ListNotificationScreenState extends State<ListNotificationScreen> {
  final NotificationPlugin _notificationPlugin = NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationFuture = _notificationPlugin.getScheduledNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('list notification'),),
      body: Center( 
        child: Column(
          children:<Widget>[
             FutureBuilder<List<PendingNotificationRequest>>(
            future: notificationFuture,
            initialData: [],
            builder: (context, snapshot){
              final notifications = snapshot.data;
              return Expanded( 
                child: ListView.builder( 
                  itemCount: notifications.length,
                  itemBuilder: (context , index ){
                    final notification = notifications[index];
                    return Text(notification.title);
                  },
                ),
              );
            },
           ),
           FlatButton(
             padding: EdgeInsets.all(0),
             onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => SetTimeRunning()));
             },
            //  () async{
            //    await _notificationPlugin.showWeeklyAtDayAndTime(
            //      Time(12,0,0), 
            //      Day.Monday, 
            //      0, 
            //      'first notification', 
            //      'description'
            //      );
            //     setState(() {
            //       notificationFuture = _notificationPlugin.getScheduledNotifications();
            //     });
            //  },
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.only( 
                 bottomRight: Radius.circular(5),
                 bottomLeft: Radius.circular(5)
               ),
             ),
             color:Colors.blue.shade300,
             child: Container( 
               alignment: Alignment.center,
               height: 50,
               width: double.infinity,
               child: Text('Create',style: TextStyle(color: Colors.blue.shade900,
               fontSize: 20,
               fontWeight: FontWeight.bold),
               ),
             ),
           )
          ]
        ),
      ),
      
    );
  }
}