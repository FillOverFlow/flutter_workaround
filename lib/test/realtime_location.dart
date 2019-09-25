import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class FireMap extends StatefulWidget {
  @override
  _FireMapState createState() => _FireMapState();
}

class _FireMapState extends State<FireMap> {
  GoogleMapController mapController;
  Location location = new Location();
  Geoflutterfire geo = Geoflutterfire();
  Firestore firestore = Firestore();
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
        )
      ],
    );
  }

  Future<DocumentReference> _addGeoPoint() async {
    var pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore
        .collection('locations')
        .add({'position': point.data, 'name': 'finfi'});
  }

  void _onMapcreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _addMarker() {}
}
