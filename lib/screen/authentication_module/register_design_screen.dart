import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_design_screen.dart';
import 'package:work_around/models/profile.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Screen',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: RegisterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _email, _password;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Profile> profiles = List();
  Profile profile;
  DatabaseReference profileRef;
  var width;
  var height;

  final database = FirebaseDatabase.instance.reference();
  void intiState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    profileRef = database.reference().child('profile');
    profileRef.onChildAdded.listen(_onEntryAdded);
    profileRef.onChildChanged.listen(_onEntryChanged);
  }

  //history var zone
  _onEntryAdded(Event event) {
    setState(() {
      profiles.add(Profile.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event) {
    var old = profiles.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      profiles[profiles.indexOf(old)] = Profile.fromSnapshot(event.snapshot);
    });
  }

  void save_profile_to_firebase() {
    print('in save profile to firebase');
    try {
      FirebaseDatabase.instance
          .reference()
          .child('profile')
          .child('finfin')
          .set({
        'name': 'finfin',
        'width': width,
        'height': height,
      });
      print("send record success");
    } catch (e) {
      print("can't send $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Resgister"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              })),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
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
                padding: EdgeInsets.only(top: 42),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      margin: EdgeInsets.only(top: 0),
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
                          hintText: 'อีเมล',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 22),
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
                          hintText: 'รหัสผ่าน',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 24),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextFormField(
                        onSaved: (input) => width = input,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.supervised_user_circle,
                            color: Colors.grey,
                          ),
                          hintText: 'น้ำหนัก',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 14, bottom: 14),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextFormField(
                        onSaved: (input) => height = input,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.supervised_user_circle,
                            color: Colors.grey,
                          ),
                          hintText: 'ส่วนสูง',
                        ),
                      ),
                    ),
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
            ),
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
        save_profile_to_firebase();
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
