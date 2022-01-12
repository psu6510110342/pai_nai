import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:image_picker/image_picker.dart';
//import 'package:pai_nai/screens/language.dart';
//import 'package:pai_nai/screens/map.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pai_nai/newscrssns/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:translator/translator.dart';
import 'package:pai_nai/newscrssns/app_localizations.dart';
import 'package:pai_nai/newscrssns/map_driver.dart';
import 'package:pai_nai/screens/mainscreen.dart';

class SettingDriver extends StatefulWidget {
  @override
  _SettingDriverState createState() => _SettingDriverState();
}

class _SettingDriverState extends State<SettingDriver> {
  List<bool> isSelected;
  // PickedFile file;
  String name, email, type, text;
  String urlImage;
  String valuechoose;
  bool _openlocation = false;
  List data = [];
  List listlanguage = ['english', 'thai', 'chinese'];

  // List<User> user = List();

  Widget updateButton() {
    return RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        color: HexColor("#29557a"),
        child: Container(
            constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              "Update",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            )),
        onPressed: () {
          // updateProfile();
        });
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            title: Text('Are You Sure To Sign Out?'),
            actions: <Widget>[cancelButton(), okButton()],
          );
        });
  }

  Widget okButton() {
    return FlatButton(
        child: Text('Sure'),
        onPressed: () {
          Navigator.of(context).pop();
          processSignout();
        });
  }

  Future<void> processSignout() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext context) => Home());
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    });
  }

  // Future<void> chooseImage() async {
  //   final object = await ImagePicker().getImage(
  //     source: ImageSource.camera,
  //   );
  //   setState(() {
  //     file = object;
  //   });
  // }

  Widget cancelButton() {
    return FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text('Cancel'));
  }

  // **google translate**
  // GoogleTranslator googleTranslator = GoogleTranslator();
  // // zh-cn : chinese
  // // th : thai
  // // en-us :
  // void translate(text) async {
  //   User firebaseAuth = FirebaseAuth.instance.currentUser;
  //   var uid = firebaseAuth.uid;
  //   DocumentSnapshot documentSnapshot;
  //   await FirebaseFirestore.instance
  //       .collection('profile')
  //       .doc(uid)
  //       .get()
  //       .then((value) {
  //     documentSnapshot = value;
  //   });

  //   if (documentSnapshot['language'] == 'thai') {
  //     googleTranslator.translate(text, to: 'th').then((output) {
  //       setState(() {
  //         text = output;
  //       });
  //     });
  //   }
  //   if (documentSnapshot['language'] == 'english') {
  //     googleTranslator.translate(text, to: 'en-us').then((output) {
  //       setState(() {
  //         text = output;
  //       });
  //     });
  //   }
  //   if (documentSnapshot['language'] == 'chinese') {
  //     googleTranslator.translate(text, to: 'zh-cn').then((output) {
  //       setState(() {
  //         text = output;
  //       });
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getUserData();
  }

  Widget profileMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HexColor("#f2f2f2"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Row(children: [
              Icon(
                Icons.person_outline,
                color: HexColor("#29557a"),
                size: 30,
              ),
              SizedBox(width: 20),
              Expanded(child: Text('My Account')),

              // user()
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'SettingDriver',
                // AppLocalizations.of(context).translate('SettingDriver'),
                style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: HexColor("#29557a")),
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          // profilepic(),
          profileMenu(),
          //languageButton(context),
          // buildToggleButtons(),
          // dropdownButton(),
          signoutButton(context),
          SizedBox(
            height: 10.0,
          ),
          // location()
          // updateButton(),
        ],
      ),
      bottomNavigationBar: Bottomnavbar(),
      backgroundColor: Colors.grey.shade100,
    );
  }

  location() {
    ListView(
      children: [
        ListTile(title: Text('location')),
        SwitchListTile(
            title: Text('เปิดตำแหน่งของท่าน'),
            value: _openlocation,
            onChanged: (bool value) {
              setState(() {
                _openlocation = value;
              });

              if (_openlocation) {
                print(Text('hello'));
              }
            })
      ],
    );
  }

  Padding signoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: HexColor("#f2f2f2"),
        onPressed: () {
          myAlert();
        },
        child: Row(children: [
          Icon(
            Icons.exit_to_app_outlined,
            color: HexColor("#29557a"),
            size: 30,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Sign Out',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ]),
      ),
    );
  }

  /* Padding languageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: HexColor("#f2f2f2"),
        onPressed: () {
          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) => Language());
          Navigator.of(context).pushReplacement(materialPageRoute);
        },
        child: Row(children: [
          Icon(
            Icons.g_translate_outlined,
            color: HexColor("#29557a"),
            size: 30,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Language',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ]),
      ),
    );
  }
 */
  // SizedBox profilepic() {
  //   return SizedBox(
  //       height: 135,
  //       width: 135,
  //       child: Stack(
  //         fit: StackFit.expand,
  //         overflow: Overflow.visible,
  //         children: <Widget>[
  //           CircleAvatar(
  //             backgroundImage: file == null
  //                 ? AssetImage('images/picture_icon.png')
  //                 : FileImage(File(file.path)),
  //           ),
  //           Positioned(
  //             right: -10,
  //             bottom: 0,
  //             child: SizedBox(
  //               height: 46,
  //               width: 46,
  //               child: FlatButton(
  //                 padding: EdgeInsets.all(10),
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(50),
  //                     side: BorderSide(color: Colors.white)),
  //                 color: Color(0xFFF5F6F9),
  //                 onPressed: () {
  //                   // chooseImage();
  //                 },
  //                 child: Icon(
  //                   Icons.camera_alt_outlined,
  //                   size: 25,
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ));
  // }

  Widget dropdownButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
            border: Border.all(color: HexColor("#f2f2f2"), width: 1),
            borderRadius: BorderRadius.circular(15)),
        child: DropdownButton(
            hint: Text('Select Item'),
            dropdownColor: HexColor("#f2f2f2"),
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 36,
            isExpanded: true,
            underline: SizedBox(),
            style: TextStyle(color: Colors.black),
            value: valuechoose,
            onChanged: (newValue) {
              setState(() {
                valuechoose = newValue;
              });
            },
            items: listlanguage.map((valueItem) {
              return DropdownMenuItem(
                value: valueItem,
                child: Text(valueItem),
              );
            }).toList()),
      ),
    );
  }

  buildToggleButtons() {
    return ToggleButtons(
      borderColor: HexColor("#29557a"),
      fillColor: Colors.blue.shade50,
      borderWidth: 2,
      selectedBorderColor: HexColor("#29557a"),
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(30),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/eng_flag.png',
            height: 50,
            width: 60,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/china_flag.png',
            height: 50,
            width: 60,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/thai_flag.png',
            height: 50,
            width: 60,
          ),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
            print(i);
          }
        });
      },
      isSelected: isSelected,
    );
  }
}

class ProfileLanguage extends StatelessWidget {
  const ProfileLanguage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HexColor("#f2f2f2"),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(children: [
          Icon(
            Icons.translate_outlined,
            color: HexColor("#29557a"),
            size: 30,
          ),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'Language',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 25,
          )
        ]),
      ),
    );
  }
}

class Bottomnavbar extends StatelessWidget {
  const Bottomnavbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 70.0, right: 70.0, bottom: 5.0),
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -10),
            blurRadius: 35,
            color: Colors.white.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.home,
              ),
              onPressed: () {
                MaterialPageRoute materialPageRoute = MaterialPageRoute(
                    builder: (BuildContext context) => Mapdriver());
                Navigator.of(context).pushReplacement(materialPageRoute);

                //pushReplacement มีไว้เพื่อไม่ให้มีarrow back คือลบหน้าเก่าแล้วแสดงหน้าใหม่เลย
              }),
          IconButton(
              icon: Icon(
                Icons.account_circle,
                color: HexColor("#eb5844"),
                size: 28.0,
              ),
              onPressed: () {})
        ],
      ),
    );
  }
}
