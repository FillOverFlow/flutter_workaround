// import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:dio/dio.dart';

class MapScreenResult extends StatefulWidget {
  var _start_location;
  var _end_location;

  MapScreenResult(this._start_location, this._end_location);
  @override
  _MyMapResultState createState() =>
      _MyMapResultState(this._start_location, this._end_location);
}

class _MyMapResultState extends State<MapScreenResult> {
  var _start_location;
  var _end_location;
  _MyMapResultState(this._start_location, this._end_location);

  GoogleMapController mapController;
  var currentLocation;
  bool mapToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          child: mapToggle
              ? GoogleMap(
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        _start_location.latitude, _start_location.longitude),
                    zoom: 18,
                  ),
                  onMapCreated: onMapCreated,
                  markers: {
                    Marker(
                        markerId: MarkerId("1"),
                        position: LatLng(_start_location.latitude,
                            _start_location.longitude),
                        infoWindow: InfoWindow(
                            title: "starlocation", snippet: "startlocation")),
                    Marker(
                        markerId: MarkerId("2"),
                        position: LatLng(
                            _end_location.latitude, _end_location.longitude),
                        infoWindow: InfoWindow(
                            title: "endlocation", snippet: "endlocation")),
                    //   Marker(
                    //       markerId: MarkerId("3"),
                    //       position: LatLng(35.4219983, -122.084),
                    //       infoWindow: InfoWindow(
                    //           title: "fakelocation",
                    //           snippet: "fakelocation")) //fake marker
                  },
                  polylines: {
                    Polyline(
                        polylineId: PolylineId("p1"),
                        color: Colors.red[300],
                        points: [
                          LatLng(_start_location.latitude,
                              _start_location.longitude),
                          LatLng(
                              _end_location.latitude, _end_location.longitude),
                          // LatLng(35.4219983, -122.084),
                          // LatLng(13.705761, 100.779158),
                          // LatLng(13.7123167,100.728104),
                        ])
                  },
                )
              : Center(
                  child: Text("loading plasewait..."),
                ),
        ),
        // Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Align(
        //       alignment: Alignment.topRight,
        //       child: FloatingActionButton(
        //         heroTag: 'bangkok',
        //         onPressed: goto_fakelocation,
        //         materialTapTargetSize: MaterialTapTargetSize.padded,
        //         backgroundColor: Colors.blue,
        //         child: Icon(Icons.location_city),
        //       ),
        //     )),
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Align(
        //       alignment: Alignment.bottomRight,
        //       child: FloatingActionButton.extended(
        //         heroTag: 'mylocation',
        //         onPressed: null,
        //         label: Text('Mylocation'),
        //         icon: Icon(Icons.near_me),
        //       )),
        // )
      ],
    ));
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  void goto_fakelocation() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(35.4219983, -122.084), zoom: 20)));
  }
}
