import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'home.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _width , _height;
  String _result ;
  final ref_firebase = FirebaseDatabase.instance.reference();
  GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ProfilePage"),),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
             TextFormField(
              validator:(input){
                //  if(input is String){
                //   return 'กรุณากรอก น้ำหนัก ให้ถูกต้อง';
                // }
              },
               onSaved: (input) => _width = input,
              decoration: InputDecoration(labelText: "น้ำหนัก"),
            ),
            TextFormField(
              validator:(input){
                //  if(input is String){
                //   return 'กรุณากรอก ส่วนสูง ให้ถูกต้อง';
                // }
              },
               onSaved: (input) => _height = input,
              decoration: InputDecoration(labelText: "ส่วนสูง"),
            ),
            RaisedButton(
              child:Text("บันทึก") ,
              onPressed: save_to_firebase,
              ),
            RaisedButton(
              child: Text("show recode"),
              onPressed: save_to_firebase,)
          ],
        ),
      ),
    );
  }

  

  Future<void> save_to_firebase()  {
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try {
      ref_firebase.child("profile").set({
        "user":"finfin",
        "width":_width,
        "height":_height
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
      print("add to database successful");
      } catch (e) {
        print(e.message);
      }
    }
  }

  // Future<void> add_to_cloudfirestore(){
  //   Firestore.instance.runTransaction((Transaction transaction )async{
  //     CollectionReference reference = Firestore.instance.collection('profile');
  //     await reference.add({
  //       'width':_width,
  //       'height':_height
  //     });
  //   });
  //   print("addd firestore success");
  // }

}