import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register.dart';
import 'home.dart';

class SignInPage extends StatefulWidget{
  @override 
  _SignInPageState createState() => new _SignInPageState();
}
  
class _SignInPageState extends State<SignInPage> {
  String _email, _password;
  GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('เข้าสู่ระบบ'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            //Todo imprement fields 
            TextFormField(
              validator:(input){
                if(input.isEmpty){
                  return 'กรุณากรอก email';
                }
              } ,
              onSaved:(input) => _email = input ,
              decoration: InputDecoration(labelText: 'อีเมล'),
            ),
            TextFormField(
              validator: (input){
                if(input.length < 6){
                  return 'password ต้องมีความยาวไม่น้อยกว่า 6 ตัวอักษร';
                }
              },
              onSaved:(input)=>_password = input,
              decoration: InputDecoration(labelText: 'รหัสผ่าน'),
              ),
            RaisedButton(
              onPressed: signIn,
              child: Text('เข้าสู่ระบบ'),
            ),
            RaisedButton(
              onPressed: link_to_register,
              child: Text("สมัคร"),
            )
          ],
        ),
      ),
    );
  } 

  void link_to_register(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }
  Future<void> signIn()async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try {
        FirebaseUser use = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email,password: _password);
        Navigator.push(context,MaterialPageRoute(builder:(context) => HomePage()));
      } catch (e) {
        print(e.message);
      }
    }
    //validate field

    //login to firebase 

  }
}