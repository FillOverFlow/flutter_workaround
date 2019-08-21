import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:work_around/screen/home.dart';
import 'login_design_screen.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Screen',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email, _password;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void intiState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFf45d27), Color(0xFFf5851f)]),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person,
                      size: 90,
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
                      child: Text(
                        'ลงทะเบียน',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),

            /* Bottom Zone  */
            Form(
              key: _formKey,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 62),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'กรุณากรอก email';
                          }
                        },
                        onSaved: (input) => _email = input,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextFormField(
                        validator: (input) {
                          if (input.length < 6) {
                            return 'password ต้องมีความยาวไม่น้อยกว่า 6 ตัวอักษร';
                          }
                        },
                        onSaved: (input) => _password = input,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.grey,
                          ),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    ForgetPassword(),
                    Spacer(),
                    GestureDetector(
                      onTap: register,
                      child: Container(
                        height: 45,
                        width: MediaQuery.of(context).size.width / 1.2,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'ลงทะเบียน'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        print("try connecting firebase...");
        FirebaseUser use = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } catch (e) {
        print('error $e.message');
      }
    }
  }
}
// class EmailField extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width/1.2,
//       height: 45,
//       padding: EdgeInsets.only(
//         top:4,left:16,right:16,bottom:4
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(50)
//         ),
//         color:Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color:Colors.black12,
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           icon: Icon(Icons.email,
//           color: Colors.grey,
//           ),
//           hintText: 'Email',
//         ),
//       ),
//     );
//   }
// }

Container _textField(String field_name, IconData icon, BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width / 1.2,
    height: 45,
    margin: EdgeInsets.only(top: 32),
    padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        icon: Icon(
          icon,
          color: Colors.grey,
        ),
        hintText: '$field_name',
      ),
    ),
  );
}
// class PasswordField extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width/1.2,
//       height: 45,
//       margin: EdgeInsets.only(top: 32),
//       padding: EdgeInsets.only(
//           top: 4,left: 16, right: 16, bottom: 4
//       ),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.all(
//               Radius.circular(50)
//           ),
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 5
//             )
//           ]
//       ),
//       child: TextField(
//         decoration: InputDecoration(
//           border: InputBorder.none,
//           icon: Icon(Icons.vpn_key,
//             color: Colors.grey,
//           ),
//           hintText: 'Password',
//         ),
//       ),
//     );
//   }
// }

class ForgetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, right: 32),
        child: Text(
          'Forgot Password ?',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFf45d27), Color(0xFFf5851f)],
          ),
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Center(
        child: Text(
          'Register'.toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
