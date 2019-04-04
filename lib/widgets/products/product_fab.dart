import 'package:flutter/material.dart';

class ProductFAB extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductFABState();
  }
}

class _ProductFABState extends State<ProductFAB> {
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'contact',
              mini: true,
              onPressed: () {},
              child: Icon(Icons.mail, color: Theme.of(context).primaryColor))),
      Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              heroTag: 'favorite',
              mini: true,
              onPressed: () {},
              child: Icon(Icons.favorite, color: Colors.red))),
      FloatingActionButton(
          heroTag: 'options', onPressed: () {}, child: Icon(Icons.more_vert)),
    ]);
  }
}
