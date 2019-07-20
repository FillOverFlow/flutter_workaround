import 'package:flutter/material.dart';

class PaddedText extends StatelessWidget {
  final String _data;
  //set paddedText something
  PaddedText(this._data, {Key key})
    :super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(_data),
    );
  }
}