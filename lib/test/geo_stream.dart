import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as prefix0;
import 'package:location/location.dart';

class GeolocationStream extends StatefulWidget {
  @override
  _GeolocationStreamState createState() => _GeolocationStreamState();
}

class _GeolocationStreamState extends State<GeolocationStream> {
  Geolocator _geolocator;
  Position _position;

  @override
  void initState() {
    _geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(
        accuracy: prefix0.LocationAccuracy.high, distanceFilter: 1);

    StreamSubscription positionStream = _geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) {
      _position = position;
    });
    super.initState();
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: prefix0.LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));
      print("update location ${newPosition}");
      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print(" error : ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("GeoStream Test"),
        ),
        body: Column(
          children: <Widget>[
            Text(
                'Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
                ' Longitude: ${_position != null ? _position.longitude.toString() : '0'}'),
            FlatButton(
                child: FlatButton(
              child: Icon(Icons.pin_drop),
              color: Colors.green,
              onPressed: () => updateLocation(),
            ))
          ],
        ));
  }
}
