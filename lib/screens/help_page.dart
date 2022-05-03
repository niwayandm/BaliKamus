import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            titleSpacing: 0.0,
            backgroundColor: Colors.red,
            title: Text("Help")),
        body: Container(
            color: Colors.grey[300],
            child: ListView(children: <Widget>[
              Container(
                  height: 650,
                  child: Image(image: AssetImage('assets/help_1.jpg'))),
              Divider(),
              Container(
                  height: 650,
                  child: Image(image: AssetImage('assets/help_2.jpg'))),
              Divider(),
              Container(
                  height: 650,
                  child: Image(image: AssetImage('assets/help_3.jpg')))
            ])));
  }
}
