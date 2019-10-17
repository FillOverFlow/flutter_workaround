import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListViewClound extends StatefulWidget {
  @override
  _ListViewCloundState createState() => _ListViewCloundState();
}

class _ListViewCloundState extends State<ListViewClound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("list view"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('profile').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new ListTile(
                      leading: Icon(Icons.history),
                      onTap: () => print("on tap .. ${document['name']}"),
                      title: new Text(document['email']),
                      subtitle: new Text(document['name']),
                    );
                  }).toList(),
                );
            }
          },
        ));
  }
}
