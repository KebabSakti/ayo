import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget boxRadiusShimmer({double radius, double width, double height}) {
  return SizedBox(
    width: width ?? double.infinity,
    height: height ?? double.infinity,
    child: Shimmer.fromColors(
      period: Duration(
        milliseconds: 700,
      ),
      baseColor: Colors.grey[200],
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(radius ?? 10),
        ),
      ),
    ),
  );
}
