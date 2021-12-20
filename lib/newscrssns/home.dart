import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:pai_nai/screens/authen.dart';
import 'package:pai_nai/newscrssns/body.dart';
import 'package:pai_nai/screens/mainscreen.dart';
import 'package:pai_nai/screens/mainscreen.dart';
//import 'package:pai_nai/screens/register.dart';
//import 'package:pai_nai/screens/authen.dart';

class Home extends StatefulWidget {
  static const String idScreen = 'login';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return Scaffold(body: Body(), backgroundColor: Colors.grey.shade200);
  }
}
