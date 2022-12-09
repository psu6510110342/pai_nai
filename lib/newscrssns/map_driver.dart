import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pai_nai/Assistants/assistantsMethods.dart';
import 'package:pai_nai/newscrssns/app_localizations.dart';
import 'package:pai_nai/newscrssns/setting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:pai_nai/newscrssns/setting_driver.dart';

import 'package:audioplayers/audioplayers.dart';

class Mapdriver extends StatefulWidget {
  static const String idScreen = 'mapDriver';

  GoogleMapController newGoogleMapController;
  @override
  _MapdriverState createState() => _MapdriverState();
}

class _MapdriverState extends State<Mapdriver> {
  GoogleMapController newGoogleMapController;
  double bottomPaddingOfMap = 0;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapContraller;
  String latitudeData = '';
  String longitudeData = '';
  bool _openlocation = false;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference();

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool mapToggle = false;
  var currentLocation;

  // Geoflutterfire geo = Geoflutterfire();

  Position currentPosition;
  var geoLocator = Geolocator();

  // Set<Marker> allMarkers = {};
  // BitmapDescriptor mapMarker;
  int p_count = 0;
  int a = 0;
  String ct;
  final assetsAudioPlayer = AssetsAudioPlayer();

  void writedata() {
    databaseReference.child('LatLng').set({
      // 'LatLng' เปลี่ยนตามที่ใส่ใน firebase
      'Lat': '1',
      'Lng': '2'
    });
  }

  void readdata() {
    databaseReference.once().then((DataSnapshot dataSnapshot) {
      print(dataSnapshot.value);
    });
  }

  void updatedata() {
    databaseReference.child('LatLng').update({
      'Lat': '3',
      'Lng': '4'
    }); // 'LatLng' เปลี่ยนตามที่ใส่ใน firebase ==> แล้วค่าที่อัปเดตจะใส่ตามหัวข้อที่เรากำหนด
    // เช่น ในขั้นตอน writedata เรากำหนด Lat เป็น 1 แล้วพอรันขั้นตอน updatedata 'Lat' จะเป็น 3
  }

  void deletedata_realtime() {
    databaseReference.child('LatLng').remove();
  }

  Set<Marker> markersSet = {};

  BitmapDescriptor pinicon;

  @override
  void initState() {
    
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(1, 1)), 'images/user_icon_map.png')
        .then((value) {
      pinicon = value;
    });

    final uid = auth.currentUser.uid;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    // ref.child('amount/$uid/count').once().listen((DataSnapshot datasnapshot) {
    //    print('Data : ${datasnapshot.value.toString()}');
    //    ct = datasnapshot.value.toString();
    //    p_count = int.parse(ct);
    //  });

    //ref.child('amount/$uid/count').onValue.listen((DatabaseEvent event) {

    // });
    super.initState();

    // final player = AudioCache();
    // int number = 0;
    // if (p_count == 8 && number == 0) {
    //   assetsAudioPlayer.open(Audio('sound/sound_count.mp3'));
    //   player.play('sound_count.mp3');
    //   number = 1;
    // } else if (p_count < 8 && p_count > -1) {
    //   number = 0;
    // } else {
    //   number = 1;
    // }
  }

  getMarkerData() async {
    FirebaseFirestore.instance
        .collection('location_user')
        .get()
        .then((myMockDoc) {
      if (myMockDoc.docs.isNotEmpty) {
        for (int i = 0; i < myMockDoc.docs.length; i++) {
          print('-----------------------------------------------' +
              myMockDoc.docs[i].id.toString());
          Map<String, dynamic> data = myMockDoc.docs[i].data();
          var lat = double.parse(data['lat']);
          var lng = double.parse(data['lng']);
          LatLng latLngPositionUser = LatLng(lat, lng);
          var userID = myMockDoc.docs[i].id;
          final MarkerId markerId = MarkerId(userID);
          Marker userPlace = Marker(
            icon: pinicon,
            position: latLngPositionUser,
            markerId: markerId,
          );
          setState(() {
            markersSet.add(userPlace);
          });
          print('////////////////////////////////////' +
              latLngPositionUser.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [showGoogleMap(), switch_locate(), number()],
      ),
      backgroundColor: Colors.grey.shade100,
    );
  }

  Widget showlocate() {
    return Row(
      children: [
        SwitchListTile(
            title: Text(
                AppLocalizations.of(context).translate('เปิดตำแหน่งของท่าน')),
            value: _openlocation,
            onChanged: (bool value) {
              setState(() {
                _openlocation = value;
              });
              if (_openlocation) {
                setdata();
              } else {
                deletedata();
              }
            })
      ],
    );
  }

  Widget boxlocate() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          color: HexColor("#29557a"),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18)),
          boxShadow: [
            BoxShadow(
              color: HexColor("#29557a"),
              blurRadius: 16,
              spreadRadius: 0.5,
              offset: Offset(0.7, 0.7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  SwitchListTile(
                    title: Text('เปิดตำแหน่งของท่าน'),
                    value: _openlocation,
                    onChanged: (bool value) {
                      setState(() {
                        _openlocation = value;
                        if (_openlocation == true) {
                          setdata();
                        } else {
                          deletedata();
                        }
                      });
                    },
                    activeColor: Colors.indigo.shade900,
                    inactiveTrackColor: Colors.grey.shade200,
                    controlAffinity: ListTileControlAffinity.leading,
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                padding: EdgeInsets.only(left: 70.0, right: 70.0, bottom: 2.0),
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.home,
                          color: Colors.indigo.shade900,
                          size: 28.0,
                        ),
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {
                          MaterialPageRoute materialPageRoute =
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SettingDriver());
                          Navigator.of(context)
                              .pushReplacement(materialPageRoute);
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //ยังไม่ได้แก้ตำแหน่งรับข้อมูล
  Future<void> getData() async {
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
    });
    setState(() {
      var type = documentSnapshot['type'];
      var cartype = documentSnapshot['cartype'];
    });
  }

  Geoflutterfire geo = Geoflutterfire();

  GoogleMapController mapController;

  //เริ่มเก็บตำแหน่ง
  Future<void> setdata() async {
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
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    var type = documentSnapshot['type'];
    var cartype = documentSnapshot['cartype'];
    var lati = '${position.latitude}';
    var lngi = '${position.longitude}';
    var plate = documentSnapshot['driverPlate'];
    int count = 0;
    firebaseFirestore
        .collection('location')
        .doc('$type')
        .collection('$cartype')
        .doc(user_uid)
        .set({
      'lat': '$lati',
      'lng': '$lngi',
      'driverPlate': '$plate',
      'count': '$count',
    });
    setState(() {
      /* GeoFirePoint point =
          geo.point(latitude: position.latitude, longitude: position.longitude);
        */
      if ('$type' == 'driver') {
        firebaseFirestore
            .collection('location')
            .doc('$type')
            .collection('$cartype')
            .doc(user_uid)
            .update({
          'lat': '$lati',
          'lng': '$lngi',
          'driverPlate': '$plate',
        });
      }
      // else if ('$type' == 'user') {
      //   firebaseFirestore
      //       .collection('location')
      //       .doc('$type')
      //       .collection('latlng')
      //       .doc('$user_uid')
      //       .update({'lat': '$latitude', 'lng': '$longitude'});
      // }
    });
  }

  Future<void> deletedata() async {
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
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    setState(() {
      var type = documentSnapshot['type'];
      var cartype = documentSnapshot['cartype'];
      //GeoFirePoint point = geo.point(latitude: null, longitude: null);
      if ('$type' == 'driver') {
        firebaseFirestore
            .collection('location')
            .doc('$type')
            .collection('$cartype')
            .doc(user_uid)
            .delete();
      }
      // else if ('$type' == 'user') {
      //   firebaseFirestore
      //       .collection('location')
      //       .doc('$type')
      //       .collection('latlng')
      //       .doc('$user_uid')
      //       .update({'lat': '', 'lng': ''});
      // }
    });
  }

  GoogleMap showGoogleMap() {
    return GoogleMap(
      padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
      markers: markersSet,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        target: LatLng(13.7650836, 100.5379664),
        zoom: 16,
      ),
      // markers: allMarkers,
      // onTap: _handleTap,
      //onMapCreated: onMapCreated,
      onMapCreated: (GoogleMapController controller) {
        _controllerGoogleMap.complete(controller);
        newGoogleMapController = controller;
        setState(() {
          bottomPaddingOfMap = 160;
        });
        locatePosition();
      },
      // (GoogleMapController controller) {
      //   _controller.complete(controller);

      //   // marker();
      //   locatePosition();
      // }
    );
  }

  /* void initState() {
    locatePosition();
    super.initState();
  } */

  /* void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      locatePosition();
    });
  } */

  // Widget showcount() {
  //   return Container(
  //     padding: EdgeInsets.only(left: 5.0, right: 100.0, bottom: 110.0),
  //     height: 30,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(Radius.circular(20)),
  //       boxShadow: [
  //         BoxShadow(
  //           offset: Offset(0, -10),
  //           blurRadius: 35,
  //           color: HexColor("#f8f8f8"),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: <Widget>[
  //         Text(
  //           'Hello',
  //           style: TextStyle(
  //               color: HexColor('#a0e209'),
  //               // color: (count < 8 && count >= 0)
  //               //     ? HexColor('#a0e209')
  //               //     : HexColor('#ff1807'),
  //               fontFamily: 'Quark-Light',
  //               fontSize: 20.0),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget number() {
    return Positioned(
      left: 5,
      right: 250,
      bottom: 165,
      child: AnimatedContainer(
        curve: Curves.bounceIn,
        duration: new Duration(milliseconds: 160),
        child: Container(
          height: 80.0,
          decoration: BoxDecoration(
            color: HexColor("#696969"),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: HexColor("#f8f8f8"),
                blurRadius: 6,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 17.0, top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '$p_count',
                        style: TextStyle(
                          color: (p_count < 8 && p_count >= 0)
                              ? HexColor('#a0e209')
                              : HexColor('#ff1807'),
                          fontFamily: 'Quark-Bold',
                          fontSize: 40.0,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.person_outline_rounded,
                      size: 50.0,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void count() {
    final uid = auth.currentUser.uid;
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('amount/$uid/count').once().then((DataSnapshot datasnapshot) {
      print('Data : ${datasnapshot.value.toString()}');
      ct = datasnapshot.value.toString();
      p_count = int.parse(ct);
    });
  }

  Widget switch_locate() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedContainer(
        curve: Curves.bounceIn,
        duration: new Duration(milliseconds: 160),
        child: Container(
          height: 160.0,
          decoration: BoxDecoration(
            color: HexColor("#29557a"),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                color: HexColor("#29557a"),
                blurRadius: 16,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: Text(
                    'เปิดตำแหน่งของท่าน',
                    style: TextStyle(color: Colors.white),
                  ),
                  value: _openlocation,
                  onChanged: (bool value) {
                    setState(() {
                      _openlocation = value;
                      if (_openlocation == true) {
                        setdata();
                        getMarkerData();
                        count();
                        
                        
                      } else {
                        deletedata();
                        markersSet.clear();
                        p_count = 0;
                      }
                    });
                  },
                  activeColor: HexColor("#eb5844"),
                  inactiveTrackColor: Colors.grey.shade200,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 70.0, right: 70.0, bottom: 2.0),
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, -10),
                        blurRadius: 35,
                        color: HexColor("#29557a"),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.home,
                            color: HexColor("#eb5844"),
                            size: 28.0,
                          ),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(
                            Icons.account_circle,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            MaterialPageRoute materialPageRoute =
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SettingDriver());
                            Navigator.of(context)
                                .pushReplacement(materialPageRoute);
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 16);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address =
        await AssistantsMethods.searchCoodinateAddress(position, context);
    print('This is your Adress ::' + address);

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
    });
    setState(() {
      var type = documentSnapshot['type'];
      var cartype = documentSnapshot['cartype'];

      if ('$type' == 'driver') {
        firebaseFirestore
            .collection('location')
            .doc('$type')
            .collection('$cartype')
            .doc('$user_uid')
            .set({
          'lat': '${position.latitude}',
          'lng': '${position.longitude}'
        });
      }
    });
  }
}

// void marker() {
//   setState(() {
//     allMarkers.add(Marker(
//       markerId: MarkerId('id-1'),
//       position: LatLng(13.7650836, 100.5379664),
//       icon: mapMarker,
//     ));
//   });
// }

// void setupCustomMarker() async {
//   mapMarker = await BitmapDescriptor.fromAssetImage(
//       ImageConfiguration(), 'images/...');
// }

// _handleTap(LatLng tappedpoint) {
//   print(tappedpoint);
//   setState() {
//     allMarkers = [];
//     allMarkers.add(Marker(
//       markerId: MarkerId(tappedpoint.toString()),
//       position: tappedpoint,
//       // draggable: true,
//     ));
//   }
// }
//}

class Bottomnavbar extends StatelessWidget {
  const Bottomnavbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 70.0, right: 70.0, bottom: 5.0),
      height: 100,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -10),
            blurRadius: 35,
            color: HexColor("#29557a"),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.indigo.shade900,
                    size: 28.0,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    MaterialPageRoute materialPageRoute = MaterialPageRoute(
                        builder: (BuildContext context) => Setting());
                    Navigator.of(context).pushReplacement(materialPageRoute);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget showcount() {
//   return Container(
//     padding: EdgeInsets.only(left: 5.0, right: 100.0, bottom: 110.0),
//     height: 30,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.all(Radius.circular(20)),
//       boxShadow: [
//         BoxShadow(
//           offset: Offset(0, -10),
//           blurRadius: 35,
//           color: HexColor("#f8f8f8"),
//         ),
//       ],
//     ),
//     child: Column(
//       children: <Widget>[
//         Text(
//           '$count',
//           style: TextStyle(
//               color: (count < 8 && count >= 0)
//                   ? HexColor('#a0e209')
//                   : HexColor('#ff1807'),
//               fontFamily: 'Quark-Light',
//               fontSize: 20.0),
//         ),
//       ],
//     ),
//   );
// }

// class CountShow extends StatefulWidget {
//   const CountShow({Key key}) : super(key: key);

//   @override
//   State<CountShow> createState() => _CountShowState();
// }

// class _CountShowState extends State<CountShow> {
//   int count;
//   String ct;
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   //final assetsAudioPlayer = AssetsAudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     final uid = auth.currentUser.uid;
//     DatabaseReference ref = FirebaseDatabase.instance.reference();
//     ref.child('amount/$uid/count').once().then((DataSnapshot datasnapshot) {
//       print('Data : ${datasnapshot.value.toString()}');
//       ct = datasnapshot.value.toString();
//       count = int.parse(ct);
//     });

//     //final player = AudioCache();
//     int number = 0;
//     if (count == 8 && number == 0) {
//       //assetsAudioPlayer.open(Audio('sound/sound_count.mp3'));
//       //player.play('sound_count.mp3');
//       number = 1;
//     } else if (count < 8 && count > -1) {
//       number = 0;
//     } else {
//       number = 1;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 110.0),
//       height: 30,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, -10),
//             blurRadius: 35,
//             color: HexColor("#f8f8f8"),
//           ),
//         ],
//       ),
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Text(
//                 '$count',
//                 style: TextStyle(
//                     color: (count < 8 && count >= 0)
//                         ? HexColor('#a0e209')
//                         : HexColor('#ff1807'),
//                     fontFamily: 'Quark-Light',
//                     fontSize: 20.0),
//               ),
//               Icon(Icons.person_outline_rounded,color: HexColor('#eb5844'),)
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
