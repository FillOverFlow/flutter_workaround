import 'package:flutter/material.dart';

class ListViewInterFace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AppBar')),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(),
            title: Text("Item Text"),
            trailing: Icon(Icons.thumb_up),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.adb),
        onPressed: null
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant),
            title:  Text('News')
          )
        ],
      ),
    );
  }
}