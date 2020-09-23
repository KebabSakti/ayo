import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget boxRadiusShimmer() {
  return SizedBox(
    width: double.infinity,
    height: 220,
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
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
