import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireMap extends StatefulWidget {
  static const String idScreen = 'fireMap';

  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            //padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: CameraPosition(target: LatLng(0,0),
            zoom: 16.00),
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            compassEnabled: true,
            
            //polylines: polylineSet,
            //markers: markersSet,
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
      ],
    );
  }
  _onMapCreated(GoogleMapController controller){
    setState(() {
      
    });
  }
}