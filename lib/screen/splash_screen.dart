import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Login');
  }

  startTime() {
    //var user = await get_current_user();
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage());
  }

  Future get_current_user() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
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
