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
  static const LatLng _center = const LatLng(33.738045, 73.084488);
  LatLng _lastMapPosition = _center;
  GoogleMapController mapController;
  Location location = new Location();
  Geoflutterfire geo = Geoflutterfire();
  Firestore firestore = Firestore();
  final Set<Polyline> _polyline = {};
  List<LatLng> latlng = List();
  LatLng _dummy = LatLng(33.738045, 73.084488);

  final radius = new prefix0.BehaviorSubject<double>();
  var _stream;
  // Stream<dynamic> query;
  // StreamSubscription subscription;

  @override
  void initState() {
    var collectionRef = firestore
        .collection('locations')
        .where('running_round', isEqualTo: 'running001');
    var georef = geo.collection(collectionRef: collectionRef);
    georef.snapshot().listen((data) => data.documents.forEach((doc) {
          GeoPoint pos = doc['position']['geopoint'];
          LatLng _latLng = LatLng(pos.latitude, pos.longitude);
          latlng.add(_latLng);
          print("add new latlng ${latlng}");
        }));
    super.initState();
    setState(() {
      latlng.add(_dummy);
      //polyline
      _polyline.add(Polyline(
        polylineId: PolylineId(_lastMapPosition.toString()),
        visible: true,
        //latlng is List<LatLng>
        points: latlng,
        color: Colors.red,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(33.738045, 73.084488), zoom: 10),
          onMapCreated: _onMapcreated,
          myLocationEnabled: true,
          mapType: MapType.hybrid,
          polylines: _polyline,
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
            onPressed: () => _queryGeo2(),
          ),
        )
      ],
    );
  }

  Future<DocumentReference> _addGeoPoint() async {
    //var pos = await location.getLocation();
    GeoFirePoint point = geo.point(latitude: 33.738045, longitude: 73.084488);
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(33.738045, 73.084488), zoom: 17.0)));
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
        .listen((data) => data.documents.forEach((doc) => print(doc['name'])));
  }

  _queryGeo2() {
    var collectionRef = firestore
        .collection('profile')
        .where('email', isEqualTo: 'test@test12.com')
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
              print(doc['weight']);
            }));
  }

  _polyline_list() {
    print("polyline list: ${_polyline}");
  }
}
