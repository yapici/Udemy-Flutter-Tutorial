import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import './product_manager.dart';

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
        accentColor: Colors.deepPurple
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('EasyList'),
        ),
        body: ProductManager(),
      ),
    );
  }
}
