import 'package:flutter/material.dart';
import 'dart:async';



class SetTimeRunning extends StatefulWidget {
  @override
  _SetTimeRunningState createState() => _SetTimeRunningState();
}

class _SetTimeRunningState extends State<SetTimeRunning> {

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

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
                    RaisedButton(
                        onPressed: (){ print('time set !!');},
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
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
                Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: null, 
                      child: Text('แจ้งเตือน'),
                    )
                  ],
                )
              ],
            ),
          ), 
        ),
      );
    }
}