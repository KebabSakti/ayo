import 'package:flutter/material.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import 'package:supercharged/supercharged.dart';

class ShoppingCart extends StatefulWidget {
  final bool animate;

  ShoppingCart({Key key, @required this.animate}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  CustomAnimationControl _control = CustomAnimationControl.PLAY;

  @override
  void initState() {
    setState(() {
      if (widget.animate) {
        _control = CustomAnimationControl.PLAY;
      } else {
        _control = CustomAnimationControl.PLAY_REVERSE;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      control: _control,
      curve: Curves.elasticInOut,
      duration: Duration(milliseconds: 500),
      tween: 0.0.tweenTo(1.0), // <-- d
      child: SizedBox(
        height: 15,
        width: 15,
        child: CircleAvatar(
          backgroundColor: Colors.red,
          child: Text(
            '99',
            style: TextStyle(color: Colors.white, fontSize: 7),
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
