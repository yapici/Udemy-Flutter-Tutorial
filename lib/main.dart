import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import './pages/home.dart';

void main() {
//  debugPaintBaselinesEnabled = true;
//  debugPaintSizeEnabled = true;
//  debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      debugShowMaterialGrid: true,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          brightness: Brightness.light,
          accentColor: Colors.deepPurple),
      home: HomePage(),
    );
  }
}
