import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';

void main() {
//  debugPaintBaselinesEnabled = true;
//  debugPaintSizeEnabled = true;
//  debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Map<String, String>> _products = [];

  void _addProduct(Map<String, String> product) {
    setState(() {
      _products.add(product);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      debugShowMaterialGrid: true,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          brightness: Brightness.light,
          accentColor: Colors.deepPurple),
//      home: AuthPage(),
      routes: {
        '/': (BuildContext context) => ProductsPage(_products, _addProduct, _deleteProduct),
        '/admin': (BuildContext context) => ProductAdmin()
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');

        // Checking if path starts with a slash
        if (pathElements[0] != '') {
          return null;
        }

        if (pathElements[1] == 'product') {
          final int index = int.parse(pathElements[2]);

          return MaterialPageRoute<bool>(
            builder: (BuildContext context) =>
                ProductPage(
                  _products[index]['title'],
                  _products[index]['image'],
                ),
          );
        }

        return null;
      },
    );
  }
}
