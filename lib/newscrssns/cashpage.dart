import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pai_nai/screens/mainscreen.dart';

class Cashpage extends StatefulWidget {
  @override
  _CashpageState createState() => _CashpageState();
}

class _CashpageState extends State<Cashpage> {
  int _n = 0;

  void minus() {
    setState(() {
      if (_n != 0) _n--;
    });
  }

  void add() {
    setState(() {
      _n++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'จำนวนบุคคลที่ต้องการใช้บริการ',
          style: TextStyle(color: Colors.lightBlue.shade900),
        ),
        SizedBox(height : 5.0),
        count(),
        Text(
          'ช่องทางการจ่ายเงิน',
          style: TextStyle(color: Colors.lightBlue.shade900),
        ),
        SizedBox(height : 5.0),
        dropdown()
      ],
    ));
  }

//count nunmber
  Widget count() {
    return Container(
      child: new Center(
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: add,
              child: new Icon(
                Icons.add,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
            Text('$_n',
                style:
                    new TextStyle(fontSize: 60.0, color: Colors.blue.shade900)),
            FloatingActionButton(
              onPressed: minus,
              child: new Icon(
                  const IconData(0xe15b, fontFamily: 'MaterialIcons'),
                  color: Colors.black),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

//drop down buttton
//add dropdownfield: ^1.0.3 in .yaml
  Widget dropdown() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('....'),
          SizedBox(height: 10.0),
          DropDownField(
            controller: payment,
            hintText: "Please choose payment way",
            enabled: true,
            // itemsVisibleInDropdown: 2, // //ไม่จำเป็น
            items: pay,
            onValueChanged: (value) {
              setState(() {
                selectpayment = value;
              });
            },
          ),
          SizedBox(height: 10.0),
          Text(
            selectpayment,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget button() {
    return GestureDetector(
      onTap: () {
        db_count();

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => MainScreen());
        Navigator.of(context).pushReplacement(materialPageRoute);
      },
      child: Container(
        width: 200,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.blue.shade900,
        ),
        child: Center(child: Text('Confirm!')),
      ),
    );
  }

  Future<void> db_count() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user_uid = firebaseAuth.currentUser.uid;
    DocumentSnapshot documentSnapshot;
    await FirebaseFirestore.instance
        .collection('profile')
        .doc('$user_uid')
        .get()
        .then((value) {
      documentSnapshot = value;
      setState(() {
        var type = documentSnapshot['type'];
        var cartype = documentSnapshot['cartype'];
        int count = documentSnapshot['count'];
        int num = count + _n;
        if (num <= 8) {
          firebaseFirestore
              .collection('location')
              .doc('$cartype')
              .collection('$type')
              .doc(user_uid)
              .update({'count': '$num'});
        } else {
          myAlertcount();
        }
      });
    });
  }

  void myAlertcount() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: ListTile(
              leading: Icon(
                Icons.sentiment_dissatisfied,
                color: Colors.red.shade700,
                size: 35.0,
              ),
              title: Text(
                'SORRY!',
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            content:
                Text('Sorry, the number of people exceeded the standard set !'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }
}

final payment = TextEditingController();
String selectpayment = "";

List<String> pay = ["cash", "bank"];
