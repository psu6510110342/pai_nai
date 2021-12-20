/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class testMarker extends StatefulWidget {
  

  @override
  _testMarkerState createState() => _testMarkerState();
}

class _testMarkerState extends State<testMarker> {
  @override
  Widget build(BuildContext context) {
    Set<Marker> markersSet = {};
    void carStop(){}
    return Scaffold(
     body: GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            
            markers: markersSet,
            //circles: circlesSet,
            /* onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 230;
              });
              //initMarker();
              locatePosition();
            }, */
          ),
    );
  }
} */