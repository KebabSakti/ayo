import 'dart:io';

import 'package:ayo/moor/db.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderIntro extends StatefulWidget {
  final List<IntroData> intros;
  SliderIntro({Key key, @required this.intros}) : super(key: key);

  @override
  _SliderIntroState createState() => _SliderIntroState();
}

class _SliderIntroState extends State<SliderIntro> {
  CarouselController _buttonCarouselController = CarouselController();
  int _activeSlider = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _activeSlider = index;
                  });
                },
                viewportFraction: 1.0,
                height: 500,
                autoPlay: false,
                enableInfiniteScroll: false,
              ),
              carouselController: _buttonCarouselController,
              itemCount: widget.intros.length,
              itemBuilder: (BuildContext context, int itemIndex) {
                return Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: Image.file(
                          File(
                            widget.intros[itemIndex].path,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: [
                          Text(
                            '${widget.intros[itemIndex].title}',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            '${widget.intros[itemIndex].caption}',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: 56,
            // padding: EdgeInsets.only(left: 4, right: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Builder(
                  builder: (context) {
                    if (_activeSlider > 0) {
                      return FlatButton(
                        child: Text(
                          'Kembali',
                          style: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                        onPressed: () {
                          _buttonCarouselController.previousPage();
                        },
                      );
                    }

                    return SizedBox(width: 90);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.intros.map((i) {
                    int index = widget.intros.indexOf(i);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _activeSlider == index
                            ? Colors.red
                            : Colors.grey[400],
                      ),
                    );
                  }).toList(),
                ),
                Builder(
                  builder: (context) {
                    if ((_activeSlider + 1) == widget.intros.length) {
                      return FlatButton(
                        child: Text(
                          'Mulai',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/app', (Route<dynamic> route) => false);
                        },
                      );
                    }

                    return FlatButton(
                      child: Text('Berikut'),
                      onPressed: () {
                        _buttonCarouselController.nextPage();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
