import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pai_nai/main.dart';
import 'package:pai_nai/newscrssns/app_localizations.dart';
import 'package:pai_nai/screens/finishBlue.dart';
import 'package:pai_nai/screens/finishBrown.dart';
import 'package:pai_nai/screens/mainscreen.dart';

class Cashpage extends StatefulWidget {
  final String markerId;
  final colorWay;
  final int count;
  final plate;
  Cashpage({Key key, this.markerId, this.colorWay, this.plate, this.count})
      : super(key: key);
  @override
  _CashpageState createState() => _CashpageState();
}

class _CashpageState extends State<Cashpage> {
  int _n = 0;
  int count_num = 0;

  String uid;

  var color;
  var plate_car;
  int cnum;

  String ct;

  @override
  void initState() {
    super.initState();
    uid = widget.markerId;
    color = widget.colorWay;
    plate_car = widget.plate;
    //count_num = widget.count;
    //cnum = widget.count;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('amount/$uid/count').once().then((DataSnapshot datasnapshot) {
      print('Data : ${datasnapshot.value.toString()}');
      ct = datasnapshot.value.toString();
      count_num = int.parse(ct);
      cnum = int.parse(ct);
    });
    
  }

  void minus() {
    setState(() {
      if (_n != 0) {
        _n--;
        count_num = count_num - 1;
      }
    });
  }

  void add() {
    setState(() {
      _n = _n + 1;
      count_num = count_num + 1;
      // if (count_num == 8) {
      //   myAlertcount();
      // } else 
      if (count_num > 8) {
        _n--;
        myAlertcount();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).translate('ป้ายทะเบียน'),
                  style: TextStyle(
                    color: HexColor('#29557a'),
                    fontSize: 22.0,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '$plate_car',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: HexColor("#eb5844"),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)
                      .translate('จำนวนผู้ใช้บริการในขณะนี้'),
                  style: TextStyle(
                    fontSize: 17.0,
                    color: HexColor('#29557a'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '$cnum',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: HexColor("#eb5844"),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          AppLocalizations.of(context)
              .translate('จำนวนบุคคลที่ต้องการใช้บริการ'),
          style: TextStyle(color: HexColor('#29557a'), fontSize: 15.0),
        ),
        SizedBox(height: 5.0),
        count(),
        Text(
          AppLocalizations.of(context).translate('ช่องทางการจ่ายเงิน'),
          style: TextStyle(color: HexColor('#29557a'), fontSize: 15.0),
        ),
        SizedBox(height: 5.0),
        dropdown(),
        SizedBox(height: 8.0),
        button(),
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
              heroTag: 'btn1',
              onPressed: minus,
              child: new Icon(
                Icons.remove_rounded,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 10.0),
            Text('$_n',
                style:
                    new TextStyle(fontSize: 60.0, color: Colors.blue.shade900)),
            SizedBox(width: 10.0),
            FloatingActionButton(
              heroTag: 'btn2',
              onPressed: add,
              child: new Icon(
                Icons.add,
                color: Colors.black,
              ),
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
      // height: MediaQuery.of(context).size.height,
      // width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Text('....'),
          SizedBox(height: 5.0),
          DropDownField(
            controller: payment,
            hintText: AppLocalizations.of(context)
                .translate("Please choose payment way"),
            enabled: true,
            // itemsVisibleInDropdown: 2, // //ไม่จำเป็น
            items: pay,
            onValueChanged: (value) {
              setState(() {
                selectpayment = value;
              });
            },
          ),
          SizedBox(height: 20.0),
          Text(
            selectpayment,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget button() {
    return RaisedButton(
        onPressed: () {
          //db_count();
          //count_num = count_num + _n;
          if ('$color' == 'สายสีน้ำเงิน') {
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => FinishBlue(
                      number: _n,
                      driveruid: uid,
                      count: count_num,
                    ));
            Navigator.of(context).pushReplacement(materialPageRoute);
          } else if ('$color' == 'สายสีน้ำตาลแดง') {
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => FinishBrown(
                      number: _n,
                      driveruid: uid,
                      count: count_num,
                    ));
            Navigator.of(context).pushReplacement(materialPageRoute);
          }
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(60.0)),
        color: HexColor('#29557a'),
        child: Container(
            constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context).translate("Confirm!"),
              textAlign: TextAlign.center,
              style: TextStyle(color: HexColor('#ffffff'), fontSize: 15),
            )));
  }

  /*Future<void> db_count() async {
    //count_num = count_num + _n;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('location')
        .doc('driver')
        .collection('$color')
        .doc('$uid')
        .update({'count': '$count_num'});
  }*/

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
                AppLocalizations.of(context).translate('SORRY!'),
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            content: Text(AppLocalizations.of(context).translate(
                'Sorry, the number of people exceeded the standard set !')),
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
List<String> pay = ["cash", "bank", "paypal"];
