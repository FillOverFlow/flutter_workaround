// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  static const LatLng _center = const LatLng(33.738045, 73.084488);
  var _start_location;
  var _end_location;

  _MyMapResultState(this._start_location, this._end_location);

  GoogleMapController mapController;
  Firestore firestore = Firestore();
  Geoflutterfire geo = Geoflutterfire();
  bool mapToggle = true;
  //add your lat and lng where you wants to draw polyline
  LatLng _lastMapPosition = _center;
  List<LatLng> latlng = List();
  LatLng _new = LatLng(33.738045, 73.084488);
  LatLng _news = LatLng(33.567997728, 72.635997456);

  final Set<Polyline> _polyline = {};
  var currentLocation;

  @override
  void initState() {
    var collectionRef = firestore
        .collection('locations')
        .where('running_round', isEqualTo: 'running002');
    var geo_object = geo.collection(collectionRef: collectionRef);
    geo_object.snapshot().listen((data) => data.documents.forEach((doc) {
          GeoPoint pos = doc['position']['geopoint'];
          LatLng _latLng = LatLng(pos.latitude, pos.longitude);
          latlng.add(_latLng);
          print("add new latlng ${latlng}");
        }));
    super.initState();
    setState(() {
      //fake polyline
      latlng.add(_new);
      //polyline
      _polyline.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        //latlng is List<LatLng>
        points: latlng,
        color: Colors.blue,
      ));
    });
  }

  _query_geo_data() async {
    var collection = await firestore.collection('locations');
    return geo.collection(collectionRef: collection);
  }

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
                    zoom: 12,
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
                  polylines: _polyline,
                  // polylines: {
                  //   Polyline(
                  //       polylineId: PolylineId("p1"),
                  //       color: Colors.red[300],
                  //       points: [
                  //         LatLng(_start_location.latitude,
                  //             _start_location.longitude),
                  //         LatLng(
                  //             _end_location.latitude, _end_location.longitude),
                  //         // LatLng(35.4219983, -122.084),
                  //         // LatLng(13.705761, 100.779158),
                  //         // LatLng(13.7123167,100.728104),
                  //       ])
                  // },
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
