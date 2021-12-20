import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pai_nai/screens/mainscreen.dart';
import 'package:pai_nai/screens/mainscreen.dart';
import 'package:pai_nai/newscrssns/body_signup.dart';

class Home2 extends StatefulWidget {
  static const String idScreen = 'singup';
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  @override
  void initState() {
    super.initState();
    //checkStatus();
  }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User firebaseUser = await firebaseAuth.currentUser;
    if (firebaseUser != null) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => MainScreen());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Bodysignup(), backgroundColor: Colors.grey.shade200);
  }
}
