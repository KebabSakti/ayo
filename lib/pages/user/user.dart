import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import 'package:supercharged/supercharged.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  CustomAnimationControl control =
      CustomAnimationControl.PLAY; // <-- state variable

  bool animate = false;
  double value = 200.0;
  void toggleDirection() {
    setState(() {
      // toggle between control instructions
      control = (control == CustomAnimationControl.PLAY)
          ? CustomAnimationControl.PLAY_REVERSE
          : CustomAnimationControl.PLAY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAnimation<double>(
              control: control, // <-- bind state variable to parameter
              tween: (-100.0).tweenTo(100.0),
              builder: (context, child, value) {
                return Transform.translate(
                  // <-- animation that moves childs from left to right
                  offset: Offset(value, 0),
                  child: child,
                );
              },
              child: MaterialButton(
                // <-- there is a button
                color: Colors.yellow,
                child: Text("Swap"),
                onPressed:
                    toggleDirection, // <-- clicking button changes animation direction
              ),
            ),
            RatingBar(
              initialRating: 3,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              ignoreGestures: true,
              itemSize: 12,
              itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (_) {},
            ),
            RaisedButton(
              onPressed: () {
                toggleDirection();
              },
              child: Text('ANIMATE'),
            ),
          ],
        ),
      ),
    );
  }
}
