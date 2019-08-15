import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

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
  bool check_start = false;

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
                        _start_location.latitude, _start_location.longitude),
                    zoom: 8,
                  ),
                  onMapCreated: onMapCreated,
                  markers: {
                    Marker(
                        markerId: MarkerId("1"),
                        position: LatLng(_start_location.latitude,
                            _start_location.longitude),
                        infoWindow: InfoWindow(
                            title: "starlocation", snippet: "startlocation")),
                    // Marker(
                    //     markerId: MarkerId("2"),
                    //     position: LatLng(
                    //         _end_location.latitude, _end_location.longitude),
                    //     infoWindow: InfoWindow(
                    //         title: "endlocation", snippet: "endlocation")),
                    Marker(
                        markerId: MarkerId("3"),
                        position: LatLng(35.4219983, -122.084),
                        infoWindow: InfoWindow(
                            title: "fakelocation",
                            snippet: "fakelocation")) //fake marker
                  },
                  polylines: {
                    Polyline(
                        polylineId: PolylineId("p1"),
                        color: Colors.red[300],
                        points: [
                          LatLng(_start_location.latitude,
                              _start_location.longitude),
                          // LatLng(
                          //     _end_location.latitude, _end_location.longitude),
                          LatLng(35.4219983, -122.084),
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
                onPressed: goto_fakelocation,
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
                onPressed: null,
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

  void goto_fakelocation() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(35.4219983, -122.084), zoom: 20)));
  }
}
