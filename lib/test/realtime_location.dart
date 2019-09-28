import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart' as prefix0;

class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Location location = new Location();
  Geoflutterfire geo = Geoflutterfire();
  Firestore firestore = Firestore();
  final radius = new prefix0.BehaviorSubject<double>();
  var _stream;
  // Stream<dynamic> query;
  // StreamSubscription subscription;

  @override
  void initState() {
    GeoFirePoint center = geo.point(latitude: 24.150, longitude: -110.32);
    var collectionRef = firestore.collection('locations');
    double radius = 50;
    String fields = "position";
    Stream<List<DocumentSnapshot>> stream = geo
        .collection(collectionRef: collectionRef)
        .within(center: center, radius: radius, field: fields);
    setState(() {
      _stream = stream;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(24.150, -110.32), zoom: 10),
          onMapCreated: _onMapcreated,
          myLocationEnabled: true,
          mapType: MapType.hybrid,
        ),
        Positioned(
          bottom: 50,
          right: 10,
          child: FlatButton(
            child: Icon(Icons.pin_drop),
            color: Colors.green,
            onPressed: () => _addGeoPoint(),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 10,
          child: FlatButton(
            child: Icon(Icons.pie_chart),
            color: Colors.red,
            onPressed: () => _queryGeo(),
          ),
        )
      ],
    );
  }

  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(pos.latitude, pos.longitude), zoom: 17.0)));
    return firestore.collection('locations').add({
      'position': point.data,
      'running_round': 'running001',
      'name': 'finfi'
    });
  }

  void _onMapcreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  _queryGeo() {
    GeoFirePoint center = geo.point(latitude: 12.960632, longitude: 77.641603);
    double radius = 50;
    String field = 'position';
    // var queryRef = firestore
    //     .collection('locations')
    //     .where('running_round', isEqualTo: 'running001');
    // Stream<List<DocumentSnapshot>> stream =
    //     geo.collection(collectionRef: queryRef).within(field: field);
    // stream.listen((List<DocumentSnapshot> documentList) {
    //   //do something()
    //   print('documentlist: ${documentList}');
    // });
    return Firestore.instance
        .collection('locations')
        .where('running_round', isEqualTo: 'running001')
        .snapshots()
        .listen((data) =>
            data.documents.forEach((doc) => print(doc['running_round'])));
  }
}
