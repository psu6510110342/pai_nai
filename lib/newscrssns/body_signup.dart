import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pai_nai/decoration/constants.dart';
import 'package:pai_nai/decoration/mystyle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pai_nai/newscrssns/app_localizations.dart';
import 'package:pai_nai/newscrssns/head_box.dart';
import 'package:pai_nai/screens/mainscreen.dart';
//import 'package:pai_nai/screens/map.dart';
import 'package:pai_nai/newscrssns/map_driver.dart';

class Bodysignup extends StatefulWidget {
  @override
  _BodysignupState createState() => _BodysignupState();
}

class _BodysignupState extends State<Bodysignup> {
  final formKey = GlobalKey<FormState>();

  String nameString,
      emailString,
      passwordString,
      typeString,
      //cartypeString,
      userString,
      language,
      driverPlate;
  TextEditingController emailTextEditingController = TextEditingController();
  //Method

  Future<void> registerThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailString, password: passwordString)
        .then((response) {
      print('register success for Email = $emailString');
      addUser();

      setupDisplayName();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      print('title = $title , message = $message');
      myAlertemail(title, message);
    });
  }

  void addUser() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final documentID = firebaseUser.uid;
    DocumentReference users =
        FirebaseFirestore.instance.collection('profile').doc(documentID);

    // Call the user's CollectionReference to add a new user

    return await users
        .set(
          {
            'name': nameString,
            'email': emailString,
            'type': typeString,
            'cartype': cartypeString,
            'driverPlate': driverPlate,
          },
        ) //{ merge: true }
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Geoflutterfire geo = Geoflutterfire();

  Future<void> setupDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
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

    var user = firebaseAuth.currentUser;
    var user_uid = firebaseAuth.currentUser.uid;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lati = position.latitude;
    var lngi = position.longitude;
    int count = 0;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    if (user != null) {
      user.updateProfile(displayName: nameString);
      GeoFirePoint pointuser = geo.point(latitude: 0, longitude: 0);
      if (type == 'user') {
        var locate =
            firebaseFirestore.collection('location_user').doc('$user_uid');
        locate.set({
          'lat': '$lati',
          'lng': '$lngi',
          'way': 'null',
        });
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => MainScreen());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      }

      if (type == 'driver') {
        var locate = firebaseFirestore
            .collection('location')
            .doc('driver')
            .collection('$cartypeString')
            .doc('$user_uid');
        locate.set({
          'lat': '$lati',
          'lng': '$lngi',
          'driverPlate': '$driverPlate',
          'count': '$count'
        });
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Mapdriver());
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      }
    }
  }

  void myAlertemail(String title, String message) {
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
                'Apologize',
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            content: Text(message),
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

  void myAlert(String typeString) {
    if (typeString == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: ListTile(
                leading: Icon(
                  Icons.report_problem,
                  color: Colors.red.shade700,
                ),
                title: Text(
                  'Please Check Your answer',
                  style: TextStyle(fontSize: 18.0, color: Colors.red.shade700),
                ),
              ),
              content: Text('Please Enter Your Type'),
              actions: <Widget>[
                FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    } else if (typeString == 'driver' && cartypeString == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: ListTile(
                leading: Icon(
                  Icons.report_problem,
                  color: Colors.red.shade700,
                ),
                title: Text(
                  'Please Check Your answer',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
              content: Text('Please Enter Your Car\'s Type'),
              actions: <Widget>[
                FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    }
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300.0,
              child: TextField(
                //onChanged: (value) => name = value.trim(),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.face,
                    color: Colors.redAccent,
                    size: 35.0,
                  ),
                  labelStyle: TextStyle(color: Colors.redAccent),
                  labelText: 'Name :',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.redAccent)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                  helperText: 'Put Your Name',
                  helperStyle:
                      TextStyle(color: Colors.redAccent, fontSize: 13.0),
                ),
              )),
        ],
      );

  Widget dropdown() {
    return DropDownField(
      controller: car,
      hintText: AppLocalizations.of(context)
                                      .translate("Please choose car's way"),
      enabled: true,
      // itemsVisibleInDropdown: 2, // //ไม่จำเป็น
      items: carway,
      onValueChanged: (value) {
        setState(() {
          cartypeString = value;
        });
      },
    );
  }

  Widget userForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300.0,
              child: TextField(
                  //onChanged: (value) => name = value.trim(),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.face,
                        color: Colors.redAccent,
                        size: 35.0,
                      ),
                      labelStyle: TextStyle(color: Colors.redAccent),
                      labelText: 'UserName :',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                      helperText: 'Put Your Username',
                      helperStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 13.0)))),
        ],
      );

  Widget passwordForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 300.0,
              child: TextField(
                  keyboardType: TextInputType.number,
                  //onChanged: (value) => name = value.trim(),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.face,
                        color: Colors.redAccent,
                        size: 35.0,
                      ),
                      labelStyle: TextStyle(color: Colors.redAccent),
                      labelText: 'Password :',
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.redAccent)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                      helperText: 'Put Your Password',
                      helperStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 13.0)))),
        ],
      );

  Widget nameText() {
    return TextFormField(
      style: TextStyle(color: HexColor("#29557a")),
      decoration: InputDecoration(
          icon: Icon(
            Icons.face,
            color: HexColor("#29557a"),
            size: 32.0,
          ),
          labelText: AppLocalizations.of(context)
                                      .translate('Name'),
          labelStyle: TextStyle(color: HexColor("#29557a")),
          helperText: AppLocalizations.of(context)
                                      .translate('PUT YOUR NAME'),
          helperStyle: TextStyle(color: HexColor("#29557a"))),
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context)
                                      .translate('Please Enter Your Name');
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        nameString = value.trim();
      },
    );
  }

  Widget userText() {
    return TextFormField(
      style: TextStyle(color: HexColor("#29557a")),
      decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: HexColor("#29557a"),
            size: 32.0,
          ),
          labelText: 'UserName',
          labelStyle: TextStyle(color: HexColor("#29557a")),
          helperText: 'PUT YOUR USERNAME',
          helperStyle: TextStyle(color: HexColor("#29557a"))),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Enter Your Username';
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        userString = value.trim();
      },
    );
  }

  Widget passwordText() {
    return TextFormField(
      keyboardType: TextInputType.number,
      style: TextStyle(color: HexColor("#29557a")),
      decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: HexColor("#29557a"),
            size: 32.0,
          ),
          labelText: AppLocalizations.of(context)
                                      .translate('Password'),
          labelStyle: TextStyle(color: HexColor("#29557a")),
          helperText: AppLocalizations.of(context)
                                      .translate('PUT YOUR PASSWORD MORE 6'),
          helperStyle: TextStyle(color: HexColor("#29557a"))),
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context)
                                      .translate('Please Enter Your PassWord');
        } else if (value.length < 6) {
          return AppLocalizations.of(context)
                                      .translate('Please Enter More 6 Character');
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        passwordString = value.trim();
      },
    );
  }

  Widget emailText() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: HexColor("#29557a")),
      decoration: InputDecoration(
          icon: Icon(
            Icons.mail,
            color: HexColor("#29557a"),
            size: 32.0,
          ),
          labelText: AppLocalizations.of(context)
                                      .translate('Email'),
          labelStyle: TextStyle(color: HexColor("#29557a")),
          helperText: AppLocalizations.of(context)
                                      .translate('PUT YOUR EMAIL'),
          helperStyle: TextStyle(color: HexColor("#29557a"))),
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context)
                                      .translate('Please Enter Your Email');
        } else if (!(value.contains('@') && value.contains('.'))) {
          return AppLocalizations.of(context)
                                      .translate('Please Check Your Email\'s Form ');
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        emailString = value.trim();
      },
    );
  }

  Widget popUp() {
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      itemBuilder: (BuildContext context) {
        return Constants.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  Widget userradio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'user',
                  groupValue: typeString,
                  onChanged: (value) {
                    setState(() {
                      typeString = value;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)
                                      .translate('User'), style: TextStyle(color: HexColor("#29557a")))
              ],
            ),
          ),
        ],
      );
  Widget driverradio() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200.0,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'driver',
                  groupValue: typeString,
                  onChanged: (value) {
                    setState(() {
                      typeString = value;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)
                                      .translate('Driver'), style: TextStyle(color: HexColor("#29557a")))
              ],
            ),
          ),
        ],
      );

//เมื่อกดประเภทเป็น driver ให้แสดงข้อความต่อไปนี้
  Widget driver_data() {
    if (typeString == 'driver') {
      return Container(
        child: Column(
          children: <Widget>[
            driverplate(),
            SizedBox(
              height: 10.0,
            ),
            dropdown(),
            //drop(),
            SizedBox(
              height: 30,
            )
          ],
        ),
      );
    } else
      return SizedBox(
        height: 1.0,
      );
  }

  Widget driverplate() {
    return TextFormField(
      keyboardType: TextInputType.text,
      style: TextStyle(color: HexColor("#29557a")),
      decoration: InputDecoration(
          icon: Icon(
            Icons.subtitles_outlined,
            color: HexColor("#29557a"),
            size: 32.0,
          ),
          labelText: AppLocalizations.of(context)
                                      .translate('Number Plate'),
          labelStyle: TextStyle(color: HexColor("#29557a")),
          helperText: AppLocalizations.of(context)
                                      .translate('EXAMPLE  กก-0000'),
          helperStyle: TextStyle(color: HexColor("#29557a"))),
      validator: (String value) {
        if (value.isEmpty) {
          return AppLocalizations.of(context)
                                      .translate('Please Enter Your Plate');
        } else if (!(value.contains('-'))) {
          return AppLocalizations.of(context)
                                      .translate('Please Check Your Plate\'s Form');
        } else {
          return null;
        }
      },
      onSaved: (String value) {
        driverPlate = value.trim();
      },
    );
  }

  /* Widget drop() {
    return Row(
      children: [
        Text(
          'Your Car\'s Type',
          style: TextStyle(
              color: HexColor("#29557a"), fontWeight: FontWeight.w900),
        ),
        SizedBox(
          width: 12.0,
        ),
        Container(
          child: DropdownButton<String>(
            value: cartypeString,
            onChanged: (String newvalue) {
              setState(() {
                cartypeString = newvalue;
              });
            },
            items: <String>['สายสีน้ำเงิน', 'สายสีขาว', 'สายสีน้ำตาลแดง']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  } */

  // Future<void> addUID() async{

  // }

  Widget button() {
    return Container(
      height: 50.0,
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: () {
          print('Upload');

          if (formKey.currentState.validate()) {
            if (typeString == 'user') {
              cartypeString = null;
              formKey.currentState.save();
              print(
                  'name = $nameString email = $emailString password = $passwordString type = $typeString car\'s type = $cartypeString');
              registerThread();
              // addUser();
            } else {
              formKey.currentState.save();
              print(
                  'name = $nameString email = $emailString password = $passwordString type = $typeString car\'s type = $cartypeString driverplate = $driverPlate');
              registerThread();
              // addUser();
            }
          }

          myAlert(typeString);
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        color: HexColor("#29557a"),
        child: Container(
          constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context)
                                      .translate("Sign Up"),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Form(
      key: formKey,
      child: Column(children: <Widget>[
        Head_box(size: size),
        Container(
            child: Stack(
          children: <Widget>[
            Column(children: [
              Padding(
                  padding:
                      EdgeInsets.only(left: 30.0, right: 30.0, bottom: 10.0),
                  child: Column(children: <Widget>[
                    nameText(),
                    SizedBox(height: 10.0),
                    emailText(),
                    SizedBox(height: 10.0),
                    passwordText(),
                    SizedBox(height: 20.0),
                    //popUp(),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)
                                      .translate('Please Choose Type'),
                          style: TextStyle(
                              color: HexColor("#29557a"),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    userradio(),
                    driverradio(),

                    driver_data(),
                    SizedBox(
                      height: 30.0,
                    ),
                    button()
                  ])),
            ])
            /*nameForm(),
            SizedBox(
              height: 25.0,
            ),
            userForm(),
            SizedBox(
              height: 25.0,
            ),
            passwordForm()*/
          ],
        ))
      ]),
    ));
  }

  void choiceAction(String choice) {
    if (choice == Constants.user) {
      typeString = Constants.user;
    } else if (choice == Constants.driver) {
      typeString = Constants.driver;
    }
  }
}

final car = TextEditingController();
String cartypeString = "";

List<String> carway = [
  "สายสีน้ำเงิน",
  "สายสีน้ำตาลแดง",
  "สายสีขาว",
];
