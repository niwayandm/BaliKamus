import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

import 'package:pi_project/screens/help_page.dart';
import 'package:pi_project/screens/about_page.dart';
import 'package:pi_project/database/database_helper.dart';
import 'package:pi_project/database/kamus.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _result = 'Result';
  String _translated = 'Translation';

  String _scannedlanguage = 'Balinese';
  String _translatedlanguage = 'Inggris';

  File _image;
  bool isImageLoaded = false;
  final picker = ImagePicker();

  DatabaseHelper dbHelper = DatabaseHelper.db;
  List<Kamus> kamus = new List();

  Future galleryImage() async {
    var pickedFile;
    if (pickedFile == null) {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }
    setState(() {
      _image = File(pickedFile.path);
      isImageLoaded = true;
    });
  }

  Future cameraImage() async {
    var pickedFile;
    if (pickedFile == null) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    }
    setState(() {
      _image = File(pickedFile.path);
      isImageLoaded = true;
    });
  }

  Future<String> getFirebaseVisionText() async {
    final File imageFile = _image;
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);
    setState(() {
      _result = visionText.text;
      _result = _result.toLowerCase();
    });
    cektulisan();
    translate();
    textRecognizer.close();
    return visionText.text;
  }

  void cektulisan() {
    if (_result == null || _result == "") {
      Fluttertoast.showToast(msg: 'Cannot scan Text');
      _result = 'Hasil';
    }
  }

  void translate() {
    for (var row in kamus) {
      _translated = 'No translation';
      if (_translatedlanguage == 'Inggris') {
        if (_result == row.bali) {
          _translated = row.inggris;
          break;
        }
      } else if (_translatedlanguage == 'Balinese') {
        if (_result == row.inggris) {
          _translated = row.bali;
          break;
        }
      }
    }
  }

  void changeLanguage() {
    if (_translatedlanguage == 'Inggris') {
      _scannedlanguage = 'Inggris';
      _translatedlanguage = 'Balinese';
    } else {
      _scannedlanguage = 'Balinese';
      _translatedlanguage = 'Inggris';
    }
    Fluttertoast.showToast(
        msg: 'Now translating ' +
            _scannedlanguage +
            ' To ' +
            _translatedlanguage);
  }

  @override
  void initState() {
    super.initState();
    dbHelper.getKamus().then((rows) {
      setState(() {
        rows.forEach((row) {
          kamus.add(Kamus.fromMap(row));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: new AppBar(
            titleSpacing: 0.0,
            backgroundColor: Colors.red,
            title: Text("Bali Kamus")),
        drawer: new Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(255, 255, 255, 0),
                      backgroundImage: AssetImage('assets/barong.png'),
                      radius: 60,
                    )),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Bali Kamus',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                Align(
                    alignment: Alignment.centerRight + Alignment(0, .3),
                    child: Text('ver 1.0.0',
                        style: TextStyle(color: Colors.white70)))
              ],
            ),
          ),
          ListTile(
              trailing: Icon(Icons.help),
              title: Text('Help', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HelpPage()));
              }),
          ListTile(
              trailing: Icon(Icons.person),
              title: Text('About', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AboutPage()));
              }),
        ])),
        body: Container(
            color: Colors.grey[300],
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isImageLoaded
                      ? Center(
                          child: Container(
                              height: SizeConfig.blockSizeVertical * 30,
                              width: SizeConfig.blockSizeHorizontal * 80,
                              child: Image(
                                  image: FileImage(_image), fit: BoxFit.cover)))
                      : Container(
                          height: SizeConfig.blockSizeVertical * 30,
                          width: SizeConfig.blockSizeHorizontal * 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              color: Colors.white),
                          child: Center(
                              child: Text(
                            'Pick an image',
                            style: TextStyle(color: Colors.grey),
                          ))),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text('Camera'),
                            onPressed: cameraImage),
                        SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                        RaisedButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text('Gallery'),
                            onPressed: galleryImage)
                      ]),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5),
                  Container(
                      width: SizeConfig.blockSizeHorizontal * 95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0)),
                      child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 24.0),
                              disabledBorder: InputBorder.none,
                              hintText: _result))),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  Container(
                      width: SizeConfig.blockSizeHorizontal * 95,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0)),
                      child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 24.0),
                              disabledBorder: InputBorder.none,
                              hintText: _translated))),
                  SizedBox(height: SizeConfig.blockSizeVertical * 7),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text('Change Language'),
                            onPressed: changeLanguage),
                        SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                        RaisedButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            child: Text('Translate'),
                            onPressed: getFirebaseVisionText),
                      ])
                ])));
  }
}
