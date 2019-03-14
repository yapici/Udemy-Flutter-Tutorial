import 'package:flutter/material.dart';

class LocationData {
  final double latitude;
  final double longitude;
  final String address;

  LocationData(
      {@required this.latitude,
      @required this.longitude,
      @required this.address});
}
