import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('MyButton was tapped!');
      },
      child: Container(
        height: 36.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: Center(
          child: Text('Tap Here for button'),
        ),
      ),
    );
  }
}

class TutorialHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title:Text("Example title"),
        actions: <Widget>[
          IconButton(
            icon:Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          )
        ],
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              MyButton()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'add',
        child: Icon(Icons.add),
        onPressed: null,
      ),
    );
  }
}