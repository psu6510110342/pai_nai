import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pai_nai/newscrssns/head_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pai_nai/screens/mainscreen.dart';
import 'package:pai_nai/newscrssns/app_localizations.dart';
import 'package:pai_nai/newscrssns/map_driver.dart';
//import 'package:pai_nai/screens/mainscreen_2.dart';
//import 'package:pai_nai/screens/map.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();
  String emailString, passwordString;

  //Method
  Widget backButton() {
    return IconButton(
        icon: Icon(
          Icons.navigate_before,
          size: 36.0,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  Widget content() {
    return Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            emailText(),
            SizedBox(
              height: 30.0,
            ),
            passwordText()
          ],
        ),
      ),
    );
  }

  Widget emailText() {
    return Container(
      width: 230.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            icon: Icon(
              Icons.email_outlined,
              size: 33.0,
              color: HexColor("#29557a"),
            ),
            labelText: AppLocalizations.of(context).translate('Email'),
            labelStyle: TextStyle(color: HexColor("#29557a"))),
        onSaved: (String value) {
          emailString = value.trim();
        },
      ),
    );
  }

  Widget passwordText() {
    return Container(
      width: 230.0,
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            icon: Icon(
              Icons.lock_outline,
              size: 33.0,
              color: HexColor("#29557a"),
            ),
            labelText: AppLocalizations.of(context).translate('Password'),
            labelStyle: TextStyle(color: HexColor("#29557a"))),
        onSaved: (String value) {
          passwordString = value.trim();
        },
      ),
    );
  }

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) async {
      print('Authen Success');
      String uid = firebaseAuth.currentUser.uid;
      DocumentSnapshot documentSnapshot;
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(uid)
          .get()
          .then((value) {
        documentSnapshot = value;
      });
      var type = documentSnapshot['type'];
      if (type == 'user') {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => MainScreen());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      } else if (type == 'driver') {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Mapdriver());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      }
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      myAlert(title, message);
    });
  }

  Widget showTitle(String title) {
    return ListTile(
      leading: Icon(
        Icons.report_problem,
        size: 40.0,
        color: Colors.red,
      ),
      title: Text(
        AppLocalizations.of(context).translate('ERROR'),
        style: TextStyle(fontSize: 20.0, color: Colors.red),
      ),
    );
  }

  Widget okButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          AppLocalizations.of(context).translate('Ok'),
          style: TextStyle(color: Colors.red.shade400),
        ));
  }

  void myAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: showTitle(title),
            content: Text(message),
            actions: <Widget>[okButton()],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Head_box(size: size),
          SizedBox(height: 10.0),
          Container(
            child: Stack(
              children: <Widget>[content()],
            ),
          ),
          SizedBox(
            height: 150.0,
          ),
          Container(
            height: 50.0,
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              onPressed: () {
                formKey.currentState.save();
                print('email = $emailString password = $passwordString');
                checkAuthen();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(0.0),
              color: HexColor("#29557a"),
              child: Container(
                constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context).translate("Sign In"),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
