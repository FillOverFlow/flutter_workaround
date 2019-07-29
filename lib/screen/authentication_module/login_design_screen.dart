import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:work_around/screen/home.dart';
import 'register_design_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  String _email, _password;

  GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  void intiState(){
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFf45d27),
                  Color(0xFFf5851f)
                ]),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90)
                )
              ),
              child: Column( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align( 
                    alignment: Alignment.center,
                    child: Icon(Icons.person,
                    size:90,
                    color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Align(
                  alignment: Alignment.bottomRight,
                  child: Padding( 
                    padding: const EdgeInsets.only( 
                      bottom: 32,
                      right: 32,
                    ),
                    child: Text('Login',
                      style: TextStyle( 
                        color:Colors.white,
                        fontSize: 20
                      ),
                    ),
                  ),
                  )
                ],
              ),
            ),


            /* Bottom Zone  */
            Form(
              key:_formKey,
              child: Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top:62),
                child: Column( 
                  children: <Widget>[ 
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height: 45,
                      padding: EdgeInsets.only( 
                        top:4,left:16,right:16,bottom:4
                      ),
                      decoration: BoxDecoration(  
                        borderRadius: BorderRadius.all( 
                          Radius.circular(50)
                        ),
                        color:Colors.white,
                        boxShadow: [
                          BoxShadow( 
                            color:Colors.black12,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        validator:(input){
                          if(input.isEmpty){
                            return 'กรุณากรอก email';
                          }
                        }, 
                        onSaved:(input)=>_email = input, 
                        decoration: InputDecoration( 
                          border: InputBorder.none,
                          icon: Icon(Icons.email,
                          color: Colors.grey,
                          ),
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.only(
                          top: 4,left: 16, right: 16, bottom: 4
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(50)
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5
                            )
                          ]
                      ),
                      child: TextFormField(
                        validator: (input){
                          if(input.length < 6){
                            return 'password ต้องมีความยาวไม่น้อยกว่า 6 ตัวอักษร';
                          }
                        },
                        onSaved:(input)=>_password = input, 
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.vpn_key,
                            color: Colors.grey,
                          ),
                          hintText: 'Password',
                        ),
                      ),        
                    ),
                    ForgetPassword(),
                    Spacer(),
                    RaisedButton(
                        onPressed: signin,
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
                            child:   Text('Login'.toUpperCase(),
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
              ),
            )
          ],
        ) ,
        ),
    );
  }
  Future<void> signin() async{
    //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try {
        FirebaseUser use = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email,password: _password);
        Navigator.push(context,MaterialPageRoute(builder:(context) => HomeScreen()));
      } catch (e) {
        print('error $e.message');
      }
    }
  }
}

Container _textField(String field_name,String ref,IconData icon ,BuildContext context){
  return Container(
      width: MediaQuery.of(context).size.width/1.2,
      height: 45,
      margin: EdgeInsets.only(top: 32),
      padding: EdgeInsets.only(
          top: 4,left: 16, right: 16, bottom: 4
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(50)
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5
            )
          ]
      ),
      child: TextFormField(
        validator: (input){
          if(input.isEmpty){
            return 'กรุณากรอก Email';
          }
        },
        onSaved: (input) => ref = input,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(icon,
            color: Colors.grey,
          ),
          hintText: '$field_name',
        ),
      ),        
  );
}

class ForgetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align( 
      alignment: Alignment.centerRight,
      child: Padding( 
        padding: const EdgeInsets.only( 
          top:16, right:32
        ),
        child:GestureDetector(
          onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));},
          child: Text('Register Account ?', 
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

// class LoginButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 45,
//       width: MediaQuery.of(context).size.width/1.2,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Color(0xFFf45d27),
//             Color(0xFFf5851f)
//           ],
//         ),
//         borderRadius: BorderRadius.all(
//           Radius.circular(50)
//         )
//       ),
//       child: Center(
//         child: RaisedButton(
//           onPressed: null,
//           child: Text('Login'.toUpperCase(),
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width/1.2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF03ecfc),
            Color(0xFF03c2fc)
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(50)
        )
      ),
      child: Center(
        child: Text('Register'.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}



