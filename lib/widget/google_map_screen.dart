import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

class MapScreen extends StatefulWidget {
  @override
  final List _start_location;
  final List _end_location;
  MapScreen(this._start_location, this._end_location);
  _MyMapPageState createState() =>
      _MyMapPageState(this._start_location, this._end_location);
}

class _MyMapPageState extends State<MapScreen> {
  /* var from timmer page */
  final List _start_location;
  final List _end_location;
  _MyMapPageState(this._start_location, this._end_location);

  GoogleMapController mapController;
  var currentLocation;
  List start_location = [];
  List end_location = [];
  bool mapToggle = false;
  bool check_start = false;

  @override
  void initState() {
    super.initState();
    Geolocator().getCurrentPosition().then((currloc) {
      setState(() {
        currentLocation = currloc;
        mapToggle = true;
        start_location.add(currentLocation);
        check_start = true;
      });
    });
  }

  void getCurrentLocation() async {
    String error = "";
    try {
      Geolocator().getCurrentPosition().then((currloc) {
        setState(() {
          currentLocation = currloc;
        });
      });
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: 20)));
      print(
          "current location: ${currentLocation.latitude} ${currentLocation.longitude}");
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      }
      print('set currentLocation null');
      currentLocation = null;
    }
  }

  Future _testCalDistance() async {
    Dio dio = new Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=40.6655101,-73.89188969999998&destinations=40.6905615%2C,-73.9976592&key=AIzaSyBA54tae36qRifa7wiE-iJ1HrUDuZPZfk0");
    print(response.data);
  }

  // Future _zoomOutToBankok() async {
  //   final GoogleMapController controller = await mapController.future;
  //   controller.animateCamera(
  //       CameraUpdate.newLatLngZoom(LatLng(13.6900043, 100.7479237), 12));
  // }

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
        body: Stack(
      children: <Widget>[
        Container(
          child: mapToggle
              ? GoogleMap(
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentLocation.latitude, currentLocation.longitude),
                    zoom: 20,
                  ),
                  onMapCreated: onMapCreated,
                  markers: {
                    Marker(
                        markerId: MarkerId("1"),
                        position: LatLng(currentLocation.latitude,
                            currentLocation.longitude),
                        infoWindow: InfoWindow(
                            title: "Mylocation", snippet: "mylocation"))
                  },
                  polylines: {
                    Polyline(
                        polylineId: PolylineId("p1"),
                        color: Colors.red[300],
                        points: [
                          LatLng(13.7123167, 100.728104),
                          LatLng(13.655067, 100.722697),
                          // LatLng(13.648389, 100.753335),
                          // LatLng(13.705761, 100.779158),
                          // LatLng(13.7123167,100.728104),
                        ])
                  },
                )
              : Center(
                  child: Text("loading plasewait..."),
                ),
        ),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                heroTag: 'bangkok',
                onPressed: null,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.blue,
                child: Icon(Icons.location_city),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: 'mylocation',
                onPressed: getCurrentLocation,
                label: Text('Mylocation'),
                icon: Icon(Icons.near_me),
              )),
        )
      ],
    ));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}
