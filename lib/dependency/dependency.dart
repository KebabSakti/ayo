import 'package:ayo/moor/db.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class Dependency {
  final DB db;
  final Location location;
  final Dio dio;

  const Dependency(
      {@required this.db, @required this.location, @required this.dio});
}
