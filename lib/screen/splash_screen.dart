import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigationPage(user) {
    if (user.uid == null) {
      Navigator.of(context).pushReplacementNamed('/Login');
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  startTime() async {
    var user = await get_current_user();
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage(user));
  }

  Future get_current_user() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("user now ${user.uid}");
    return user;
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/flutter_logo2.png',
        ),
      ),
    );
  }
}
