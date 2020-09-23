import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget bannerShimmer() {
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
        color: Colors.grey[200],
      ),
    ),
  );
}
