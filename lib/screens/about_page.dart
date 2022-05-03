import 'package:flutter/material.dart';

import 'package:pi_project/screens/home_page.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            titleSpacing: 0.0,
            backgroundColor: Colors.red,
            title: Text("About")),
        body: Container(
            color: Colors.grey[300],
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: SizeConfig.blockSizeVertical * 25,
                        child: Image(image: AssetImage('assets/barong.png'))),
                    SizedBox(height: SizeConfig.blockSizeVertical * 5),
                    Container(
                        height: SizeConfig.blockSizeVertical * 15,
                        width: SizeConfig.blockSizeHorizontal * 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: Colors.white),
                        child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Center(
                              child: TextField(
                                  maxLines: 3,
                                  decoration: InputDecoration.collapsed(
                                      hintText:
                                          'Bali Kamus is an app that scans and translates a word in Balinese to English and vice versa from an image.',
                                      hintStyle:
                                          TextStyle(color: Colors.black))),
                            ))),
                    SizedBox(height: SizeConfig.blockSizeVertical * 4),
                    Container(
                        width: SizeConfig.blockSizeHorizontal * 80,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Bali Kamus ver 1.0.0',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 2),
                              Text('Created By: Ni Wayan Devina',
                                  style: TextStyle(fontSize: 18)),
                              Text('Universitas Gunadarma',
                                  style: TextStyle(fontSize: 18)),
                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 4),
                              Text('email: dedev524@gmail.com',
                                  style: TextStyle(fontSize: 18))
                            ]))
                  ]),
            )));
  }
}
