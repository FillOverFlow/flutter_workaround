import 'package:firebase_database/firebase_database.dart';

class Profile {
  String key;
  String name;
  double height;
  double width;

  Profile(this.name, this.height, this.width);
  Profile.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value['name'],
        width = snapshot.value['width'],
        height = snapshot.value['height'];

  toJson() {
    return {"name": name, "width": width, "height": height};
  }
}
