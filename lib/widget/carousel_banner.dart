import 'package:ayo/model/banner/slide_banner.dart';
import 'package:ayo/widget/shimmer/banner_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouselBanner extends StatefulWidget {
  final List<SlideBanner> banners;
  CarouselBanner({Key key, @required this.banners});

  @override
  _CarouselBannerState createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  int _activeSlider = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CarouselSlider.builder(
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                _activeSlider = index;
              });
            },
            viewportFraction: 1.0,
            height: double.infinity,
            autoPlay: true,
            enableInfiniteScroll: true,
          ),
          itemCount: widget.banners.length,
          itemBuilder: (BuildContext context, int itemIndex) {
            return CachedNetworkImage(
              imageUrl: widget.banners[itemIndex].url,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) {
                return bannerShimmer();
              },
            );
          },
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 20),
            child: Row(
              children: widget.banners.map((url) {
                int index = widget.banners.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _activeSlider == index ? Colors.red : Colors.grey[100],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 20,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                ),
              ),
              child: Text(
                'Semua Promo',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
