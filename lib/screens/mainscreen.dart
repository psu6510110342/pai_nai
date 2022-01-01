import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pai_nai/Assistants/assistantsMethods.dart';
import 'package:pai_nai/DataHandler/appData.dart';
import 'package:pai_nai/Models/directDetails.dart';
import 'package:pai_nai/newscreens_2/home_screen.dart';
//import 'package:pai_nai/newscreens_2/home_screen.dart';
import 'package:pai_nai/newscrssns/setting.dart';
import 'package:pai_nai/screens/sraechScreen.dart';
import 'package:pai_nai/widgets/progressDialog.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = 'mainScreen';

  GoogleMapController newGoogleMapController;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  DirectionDetails tripDirectionDetails; //
  bool drawOpen = true;

  resetApp() {
    setState(() {
      drawOpen = true;
      searchContainerHeight = 215;
      rideDetailContainerHeight = 0;
      bottomPaddingOfMap = 230;
      carOutHeight = 0;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
    });
    locatePosition();
  } //

  BitmapDescriptor pinicon;

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
  double carOutHeight = 0;

  void displayRideDetailsContainer() async {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      rideDetailContainerHeight = 200;
      bottomPaddingOfMap = 190;
      carOutHeight = 0;
      drawOpen = false;
    });
  }

  void carOutContainer() async {
    await getPlaceDirection();

    await carStop();

    setState(() {
      searchContainerHeight = 0;
      rideDetailContainerHeight = 0;
      bottomPaddingOfMap = 115;
      carOutHeight = 100;
      drawOpen = false;
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final FirebaseAuth auth = FirebaseAuth.instance;
//เอาข้อมูลจาก firebase มาเก็บ
  getMarkerDataBrown() async {
    FirebaseFirestore.instance
        .collection('location')
        .doc('driver')
        .collection('สายสีน้ำตาลแดง')
        .get()
        .then((myMockDoc) {
      if (myMockDoc.docs.isNotEmpty) {
        for (int i = 0; i < myMockDoc.docs.length; i++) {
          print('-----------------------------------------------' +
              myMockDoc.docs[i].id.toString());
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
            /* onTap: () {
              
            }, */
          );
          setState(() {
            markersSet.add(driverPlace);
          });
          print('////////////////////////////////////' +
              latLngPositionDriver.toString());
          //initMarker(latLngPositionDriver, myMockDoc.docs[i].id);
        }
      }
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
          print('-----------------------------------------------' +
              myMockDoc.docs[i].id.toString());
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
            /* onTap: () {
              
            }, */
          );
          setState(() {
            markersSet.add(driverPlace);
          });
        }
      }
    });
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    LatLng latLngPosition_2 = LatLng(specify.latitude, specify.longitude);
    print('==================================================================' +
        latLngPosition_2.toString());
    final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(specify.latitude, specify.longitude),
        infoWindow: InfoWindow(title: specify['plate']));
    setState(() {
      markersSet.add(marker);
      //markers[markerId] = marker;
    });
    /* setState(() {
      markers[markerId] = marker;
    }); */
  }

  void initState() {
    super.initState();
    //getMarkerData();

    //carstop();
    //inputData();

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(1, 1)), 'images/car_map.png')
        .then((value) {
      pinicon = value;
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
    print('This is your Adress ::' + address);
    print('====latlng====' + latLngPosition.toString());

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

  void moveBule() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user_uid = firebaseAuth.currentUser.uid;
    FirebaseFirestore.instance
        .collection('location_user')
        .doc('$user_uid')
        .update({
      'way': 'สายสีน้ำเงิน',
    });
  }

  void moveBrown() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    var user_uid = firebaseAuth.currentUser.uid;
    FirebaseFirestore.instance
        .collection('location_user')
        .doc('$user_uid')
        .update({
      'way': 'สายสีน้ำตาลแดง',
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      /* appBar: AppBar(
        title: Text('PAINAI'),
      ), */
      /* drawer: Container(
        color: Colors.white,
        width: 255,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/user_icon.png',
                        height: 65,
                        width: 65,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Profile Name',
                            style: TextStyle(
                                fontSize: 16, fontFamily: 'Brand-Bold'),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text('Visit Profile'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(
                height: 12,
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  'History',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Visit Profile',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  'About',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ), */
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
                bottomPaddingOfMap = 230;
              });
              //initMarker();
              locatePosition();
            },
          ),
          /* Positioned(
            bottom: 50,
            right: 10,
            child: FlatButton(
              child: Icon(Icons.pin_drop, color: Colors.white,),
              color: Colors.green,
              onPressed: initMarker(),
            ),
          ), */
          Positioned(
            top: 38,
            left: 22,
            child: GestureDetector(
              onTap: () async {
                var res = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Homescreen()));
                if (res == 'obtainDirection') {
                  displayRideDetailsContainer();
                }
                if (drawOpen) {
                  scaffoldKey.currentState.openDrawer();
                }
                //scaffoldKey.currentState.openDrawer();
                else {
                  resetApp();
                }
              },
              child: Container(
                
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                  
                ),
                child: CircleAvatar(
                  
                  backgroundColor: Colors.white,
                  child: Icon(
                    //Icons.menu,
                    (drawOpen) ? Icons.menu : Icons.close, //
                    color: Colors.black,
                  ),
                  radius: 20,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'Where to?',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreens()));
                          if (res == 'obtainDirection') {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Seach Dorp off'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 70.0, right: 70.0, bottom: 2.0),
                        height: 40,
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
                                              Setting());
                                  Navigator.of(context)
                                      .pushReplacement(materialPageRoute);
                                })
                          ],
                        ),
                      ),
                      /* Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Provider.of<AppData>(context)
                                          .pickUpLocation !=
                                      null
                                  ? Provider.of<AppData>(context)
                                      .pickUpLocation
                                      .placeName
                                  : 'Add Home'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Your living home address',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ), */
                      /* SizedBox(
                        height: 24,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 24,
                      ), */
                      /* Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add work'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Your office address',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ), */
                    ],
                  ),
                ),
              ),
            ),
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
                height: rideDetailContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
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
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            moveBule();
                            carOutContainer();
                            getMarkerDataBlue();
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'สายสีน้ำเงิน',
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
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            moveBrown();
                            carOutContainer();
                            getMarkerDataBrown();
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'สายสีน้ำตาลแดง',
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
                      SizedBox(
                        height: 10,
                      ),
                      /* Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            Geoflutterfire geo = Geoflutterfire();
                            GeoFirePoint pointuser =
                                geo.point(latitude: 0, longitude: 0);
                            FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                            String uid = firebaseAuth.currentUser.uid;
                            var user_uid = firebaseAuth.currentUser.uid;
                            FirebaseFirestore.instance
                                .collection('location')
                                .doc('user')
                                .collection('สายสีน้ำตาลแดง')
                                .doc('$user_uid')
                                .delete();
                            FirebaseFirestore.instance
                                .collection('location')
                                .doc('user')
                                .collection('สายสีน้ำเงิน')
                                .doc('$user_uid')
                                .delete();
                            FirebaseFirestore.instance
                                .collection('location')
                                .doc('user')
                                .collection('null')
                                .doc('$user_uid')
                                .set({'geo': pointuser.data});
                            if (drawOpen) {
                              scaffoldKey.currentState.openDrawer();
                            }
                            //scaffoldKey.currentState.openDrawer();
                            else {
                              resetApp();
                            }
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ขึ้นรถแล้ว',
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
                      ), */
                    ],
                  ),
                ),
              ),
            ),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
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
                            /* Geoflutterfire geo = Geoflutterfire();
                            GeoFirePoint pointuser =
                                geo.point(latitude: 0, longitude: 0);
                            FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                            String uid = firebaseAuth.currentUser.uid;
                            var user_uid = firebaseAuth.currentUser.uid;
                            FirebaseFirestore.instance
                                .collection('location')
                                .doc('user')
                                .collection('สายสีน้ำตาลแดง')
                                .doc('$user_uid')
                                .delete();
                            FirebaseFirestore.instance
                                .collection('location')
                                .doc('user')
                                .collection('สายสีน้ำเงิน')
                                .doc('$user_uid')
                                .delete();
                            FirebaseFirestore.instance
                                .collection('location')
                                .doc('user')
                                .collection('null')
                                .doc('$user_uid')
                                .set({'geo': pointuser.data}); */
                            FirebaseFirestore firebaseFirestore =
                                FirebaseFirestore.instance;
                            FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                            var user_uid = firebaseAuth.currentUser.uid;
                            FirebaseFirestore.instance
                                .collection('location_user')
                                .doc('$user_uid')
                                .update({
                              'way': 'null',
                            });
                            if (drawOpen) {
                              scaffoldKey.currentState.openDrawer();
                            }
                            //scaffoldKey.currentState.openDrawer();
                            else {
                              resetApp();
                            }
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ขึ้นรถแล้ว',
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
          /* Positioned(
            bottom: 50,
            left: 10,
            child: Slider(
              min: 100,
              max: 500,
              divisions: 4,
              value: radius.value,
              label: 'Radius ${radius.value}km',
              activeColor: Colors.green,
              inactiveColor: Colors.green.withOpacity(0.2),
              onChanged: _updateQuery,
            ),
          ) */
        ],
      ),
    );
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
              message: 'Please wait...',
            ));
    var details = await AssistantsMethods.obtainDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);
    print('This is Encoded Points ::');
    print(details.encodedPoints);

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

  Future<void> carStop() async {
    Marker car_1Stop = Marker(
      //infoWindow: InfoWindow(title: 'car stop'),
      icon: pinicon,
      position: LatLng(7.028850, 100.474431),
      markerId: MarkerId('carstop1'),
    );
    Marker car_2Stop = Marker(
      //infoWindow: InfoWindow(title: 'car stop'),
      icon: pinicon,
      position: LatLng(7.031661, 100.474923),
      markerId: MarkerId('carstop2'),
    );
    Marker car_3Stop = Marker(
      //infoWindow: InfoWindow(title: 'car stop'),
      icon: pinicon,
      position: LatLng(7.025432, 100.475299),
      markerId: MarkerId('carstop3'),
    );
    setState(() {
      markersSet.add(car_3Stop);
      markersSet.add(car_1Stop);
      markersSet.add(car_2Stop);
    });
  }
}
