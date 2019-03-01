import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';
import './scoped-models/main.dart';

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
  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
//      debugShowMaterialGrid: true,
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              brightness: Brightness.light,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
//      home: AuthPage(),
          routes: {
            '/': (BuildContext context) => ScopedModelDescendant(builder:
                    (BuildContext context, Widget child, MainModel model) {
                  return model.user == null ? AuthPage() : ProductsPage(_model);
                }),
            '/products': (BuildContext context) => ProductsPage(_model),
            '/admin': (BuildContext context) => ProductAdmin(_model)
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');

            // Checking if path starts with a slash
            if (pathElements[0] != '') {
              return null;
            }

            if (pathElements[1] == 'product') {
              final String productId = pathElements[2];
              final Product product =
                  _model.allProducts.firstWhere((Product product) {
                return product.id == productId;
              });

              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(product),
              );
            }

            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => ProductsPage(_model));
          },
        ));
  }
}
