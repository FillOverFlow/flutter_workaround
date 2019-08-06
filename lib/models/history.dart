import 'package:firebase_database/firebase_database.dart';

class History{
  String key;
  String datetime;
  String record;
  String user;

  History(this.datetime, this.record , this.user);
  History.fromSnapshot(DataSnapshot snapshot):key = snapshot.key,
    datetime = snapshot.value['datetime'],
    record  = snapshot.value['record'],
    user    = snapshot.value['user'];

    toJson(){
      return {
        "datetime":datetime,
        "record":record,
        "user":user
      };
    }
}