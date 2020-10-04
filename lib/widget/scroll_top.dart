import 'package:flutter/material.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import 'package:supercharged/supercharged.dart';

class ScrollTop extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback scrollToTop;
  final double position;

  ScrollTop(
      {@required this.scrollController,
      @required this.scrollToTop,
      @required this.position});

  @override
  _ScrollTopState createState() => _ScrollTopState();
}

class _ScrollTopState extends State<ScrollTop> {
  bool show = false;

  void _scrollListener() {
    setState(() {
      show = widget.scrollController.position.pixels > widget.position
          ? true
          : false;
    });
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: (show)
          ? CustomAnimationControl.PLAY
          : CustomAnimationControl.PLAY_REVERSE,
      curve: Curves.elasticInOut,
      duration: Duration(milliseconds: 500),
      tween: 0.0.tweenTo(1.0), // <-- d
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.scrollToTop,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.arrow_upward,
              size: 20,
            ),
          ),
        ),
      ), // efine tween of colors
      builder: (context, child, value) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
    );
  }
}
