import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signIn.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  String _email, _password;
  GlobalKey <FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("สมัครสมาชิก"),
        ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator:(input){
                if(input.isEmpty){
                  return 'กรุณากรอก email';
                }
              } ,
              onSaved: (input) => _email = input,
              decoration: InputDecoration(labelText: "อีเมล์"),
              ),
            TextFormField(
              validator:(input){
                 if(input.length < 6){
                  return 'password ต้องมีความยาวไม่น้อยกว่า 6 ตัวอักษร';
                }
              },
               onSaved: (input) => _password = input,
              decoration: InputDecoration(labelText: "รหัสผ่าน"),
            ),
            RaisedButton(
              child: Text("สมัครสมาชิค"),
              onPressed: register_with_firebase,
            )
          ],
        ),
      ),
    );
  }

  Future<void> register_with_firebase(){
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try {
        FirebaseAuth.instance.createUserWithEmailAndPassword(
          email:_email,
          password:_password,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}