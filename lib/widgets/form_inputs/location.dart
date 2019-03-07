import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:map_view/map_view.dart';
import 'package:http/http.dart' as http;

import '../helpers/ensure_visible.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    getInitialStaticMap();
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void getInitialStaticMap() {
    final StaticMapProvider staticMapViewProvider =
        StaticMapProvider('AIzaSyA7neY4pIwlVBIyxEOqga-1Y4-xJ_maF_8');

    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
        [Marker('position', 'Position', 45.52638, -122.6754)],
        center: Location(45.52638, -122.6754),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

    setState(() {
      _staticMapUri = staticMapUri;
    });
  }

  void getStaticMap(String address) async {
    if (address.isEmpty) return;

    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json',
        {'address': address, 'key': 'AIzaSyA7neY4pIwlVBIyxEOqga-1Y4-xJ_maF_8'});

    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddrss = decodedResponse['resulsts'][0]['formatted_address'];
    final coordinates = decodedResponse['results'][0]['geometry']['location'];

    final StaticMapProvider staticMapViewProvider =
        StaticMapProvider('AIzaSyA7neY4pIwlVBIyxEOqga-1Y4-xJ_maF_8');

    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers([
      Marker('position', 'Position', coordinates['lat'], coordinates['lng'])
    ],
        center: Location(coordinates['lat'], coordinates['lng']),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap);

    setState(() {
      _addressInputController.text = formattedAddrss;
      _staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
            controller: _addressInputController,
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.network(_staticMapUri.toString())
      ],
    );
  }
}
