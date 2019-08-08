import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  @override
  _MyMapPageState createState() => _MyMapPageState();
}

class _MyMapPageState extends State<MapScreen> {

  Completer <GoogleMapController> _controller = Completer(); //class for map 
  LocationData currentLocation;

  void getCurrentLocation() async{
    final GoogleMapController controller = await _controller.future;
    Location location = Location();
    String error = "";
      try {
        currentLocation = await location.getLocation();
        controller.animateCamera(CameraUpdate.newCameraPosition( 
          CameraPosition(target: LatLng( 
            currentLocation.latitude,
            currentLocation.longitude),
            zoom: 14)
        ));
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        }
        print('set currentLocation null'); 
        currentLocation = null;
        
      }
  }

  Future _zoomOutToBankok() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(13.6900043, 100.7479237),12));
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar( 
      //   title: Text('My Map'),
      //   actions: <Widget>[ 
      //     IconButton( 
      //       icon: Icon(Icons.home),
      //       onPressed: _zoomOutToBankok,
      //     )
      //   ],
      // ),
      body: 
      Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition( 
              target: LatLng(13.7650836, 100.5379664),
              zoom: 18,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              Marker( 
                markerId: MarkerId("1"),
                position: LatLng(currentLocation.latitude, currentLocation.longitude),
                infoWindow: InfoWindow(title:"Mylocation",snippet: "สนามบินไทย")
              )
            },
            polylines: {
              Polyline(
                polylineId: PolylineId("p1"),
                color: Colors.red[300],
                points: [
                  LatLng(13.7123167,100.728104),
                  LatLng(13.655067, 100.722697),
                  // LatLng(13.648389, 100.753335),
                  // LatLng(13.705761, 100.779158),
                  // LatLng(13.7123167,100.728104),
                ])},
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                heroTag: 'bangkok', 
                onPressed: _zoomOutToBankok,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.blue,
                child: Icon(Icons.location_city),
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:Align(
              alignment:Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: 'mylocation',
                onPressed: getCurrentLocation,
                label: Text('Mylocation'),
                icon:Icon(Icons.near_me),
              )
            ) ,
          )   
        ],
      )
    );
  }
}

