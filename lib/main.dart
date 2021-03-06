import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';
//import 'package:flutter/rendering.dart';

import './pages/auth.dart';
import './pages/product_admin.dart';
import './pages/products.dart';
import './pages/product.dart';
import './models/product.dart';
import './scoped-models/main.dart';
import './widgets/helpers/custom_route.dart';

import './shared/global_config.dart';

void main() {
//  debugPaintBaselinesEnabled = true;
//  debugPaintSizeEnabled = true;
//  debugPaintPointersEnabled = true;
  MapView.setApiKey(mapApiKey);
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
  final _platformChannel = MethodChannel('yapici.us/flutter-demo');
  bool _isAuthenticated = false;

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _platformChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level is $result %.';
    } catch (error) {
      batteryLevel = 'Failed to get battery level.';
    }
    print(batteryLevel);
  }

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    _getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          // debugShowMaterialGrid: true,
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              brightness: Brightness.light,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
          // home: AuthPage(),
          routes: {
            '/': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductsPage(_model),
            '/admin': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductAdmin(_model)
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_isAuthenticated) {
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AuthPage(),
              );
            }
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

              return CustomRoute<bool>(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : ProductPage(product),
              );
            }

            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : ProductsPage(_model));
          },
        ));
  }
}
