import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pai_nai/Assistants/assistantsMethods.dart';
import 'package:pai_nai/DataHandler/appData.dart';
import 'package:pai_nai/Models/directDetails.dart';
import 'package:pai_nai/newscrssns/app_localizations.dart';
import 'package:pai_nai/newscrssns/cashpage.dart';
import 'package:pai_nai/screens/mainscreen.dart';
import 'package:pai_nai/widgets/progressDialog.dart';
import 'package:provider/provider.dart';

class FinishBlue extends StatefulWidget {
  static const String idScreen = 'FinishBlue';
  final int number;
  final int count;
  final String driveruid;
  FinishBlue({Key key, this.number, this.driveruid, this.count})
      : super(key: key);
  GoogleMapController newGoogleMapController;
  @override
  _FinishBlueState createState() => _FinishBlueState();
}

class _FinishBlueState extends State<FinishBlue> with TickerProviderStateMixin {
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};
  BuildContext _mycontext;

  int count;
  int number;
  String driveruid;

  DirectionDetails tripDirectionDetails; //
  bool drawOpen = true;

  BitmapDescriptor pinicon;
  BitmapDescriptor pinicon_2;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailContainerHeight = 0;
  double searchContainerHeight = 215;
  double carOutHeight = 100;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final FirebaseAuth auth = FirebaseAuth.instance;

  void carOutContainer() async {
    //await getPlaceDirection();
    await getMarkerDataBlue();

    setState(() {
      searchContainerHeight = 0;
      rideDetailContainerHeight = 0;
      bottomPaddingOfMap = 115;
      carOutHeight = 100;
      drawOpen = false;
    });
  }

  Future<void> carStop() async {
    Marker car_1Stop = Marker(
      //infoWindow: InfoWindow(title: 'car stop'),
      icon: pinicon_2,
      position: LatLng(7.028850, 100.474431),
      markerId: MarkerId('carstop1'),
    );
    Marker car_2Stop = Marker(
      //infoWindow: InfoWindow(title: 'car stop'),
      icon: pinicon_2,
      position: LatLng(7.031661, 100.474923),
      markerId: MarkerId('carstop2'),
    );
    Marker car_3Stop = Marker(
      //infoWindow: InfoWindow(title: 'car stop'),
      icon: pinicon_2,
      position: LatLng(7.025432, 100.475299),
      markerId: MarkerId('carstop3'),
    );
    setState(() {
      markersSet.add(car_3Stop);
      markersSet.add(car_1Stop);
      markersSet.add(car_2Stop);
    });
  }

  Future<void> getPlaceDirection() async {
    var initailPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;
    var pickUpLatLng = LatLng(initailPos.latitude, initailPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: AppLocalizations.of(context)
                  .translate('Please wait...'), /////
            ));
    var details = await AssistantsMethods.obtainDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId('PolylineID'),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }
    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      //icon: BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 3.0, "assets/images/logo.png"),
      infoWindow:
          InfoWindow(title: initailPos.placeName, snippet: 'my Location'),
      position: pickUpLatLng,
      markerId: MarkerId('pickUpId'),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: 'DropOff Location'),
      position: dropOffLatLng,
      markerId: MarkerId('dropOffId'),
    );
    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });
    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId('pickUpId'),
    );
    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId('dropOffId'),
    );
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  getMarkerDataBlue() async {
    FirebaseFirestore.instance
        .collection('location')
        .doc('driver')
        .collection('สายสีน้ำเงิน')
        .get()
        .then((myMockDoc) {
      if (myMockDoc.docs.isNotEmpty) {
        for (int i = 0; i < myMockDoc.docs.length; i++) {
          Map<String, dynamic> data = myMockDoc.docs[i].data();
          var lat = double.parse(data['lat']);
          var lng = double.parse(data['lng']);
          LatLng latLngPositionDriver = LatLng(lat, lng);
          var userID = myMockDoc.docs[i].id;
          final MarkerId markerId = MarkerId(userID);
          Marker driverPlace = Marker(
            infoWindow: InfoWindow(title: data['driverPlate']),
            icon: pinicon,
            position: latLngPositionDriver,
            markerId: markerId,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cashpage(markerId: userID),
                  ));
            },
          );
          setState(() {
            markersSet.add(driverPlace);
            carStop();
            getPlaceDirection();
          });
        }
      }
    });
  }

  void initState() {
    super.initState();
    carOutContainer();
    number = widget.number;
    driveruid = widget.driveruid;
    count = widget.count;
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(1, 1)), 'images/car_map.png')
        .then((value) {
      pinicon = value;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(1, 1)), 'images/car_stop_2.png')
        .then((value) {
      pinicon_2 = value;
    });
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
      if ('$type' == 'user') {
        firebaseFirestore.collection('location_user').doc('$user_uid').update({
          'lat': '${position.latitude}',
          'lng': '${position.longitude}',
        });
      }
    });
  } // เก็บgps

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(7.025432, 100.475299),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            //circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 115;
              });
              //initMarker();

              locatePosition();
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: carOutHeight,
                decoration: BoxDecoration(
                  color: HexColor("#29557a"),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
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
                  padding: EdgeInsets.symmetric(vertical: 17),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                            var user_uid = firebaseAuth.currentUser.uid;
                            count = count - number;
                            FirebaseFirestore.instance
                                .collection('location')
                                .doc('driver')
                                .collection('สายสีน้ำเงิน')
                                .doc('$driveruid')
                                .update({'count': '$count'});

                            MaterialPageRoute materialPageRoute =
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        MainScreen());
                            Navigator.of(context)
                                .pushReplacement(materialPageRoute);

                            FirebaseFirestore.instance
                                .collection('location_user')
                                .doc('$user_uid')
                                .update({
                              'way': 'null',
                            });
                          }, ////
                          color: HexColor("#eb5844"),
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('ลงรถแล้ว'), /////
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Icon(
                                  FontAwesomeIcons.taxi,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
