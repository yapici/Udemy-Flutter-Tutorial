import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {
    final buttonColor = Theme.of(context).primaryColor;

    return Column(children: <Widget>[
      OutlineButton(
          borderSide: BorderSide(color: buttonColor, width: 2.0),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.camera_alt, color: buttonColor),
              SizedBox(
                width: 5.0,
              ),
              Text('Add Image', style: TextStyle(color: buttonColor))
            ],
          ))
    ]);
  }
}
