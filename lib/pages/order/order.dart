import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> with TickerProviderStateMixin {
  AnimationController _mainWindowAnimationController;
  AnimationController _secondWindowAnimationController;

  Animation<Offset> _mainWindowAnimationOffset;
  Animation<Offset> _secondWindowAnimationOffset;

  double _pos = 0.1;

  @override
  void initState() {
    _mainWindowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _secondWindowAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _mainWindowAnimationOffset =
        Tween<Offset>(begin: Offset(0.0, 0.6), end: Offset(0.0, _pos)).animate(_mainWindowAnimationController);
    _secondWindowAnimationOffset =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.6)).animate(_secondWindowAnimationController);

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('Order'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    onPressed: () {
                      _mainWindowAnimationController.forward();
                    },
                    child: Text('FORWARD'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _mainWindowAnimationController.reverse();
                    },
                    child: Text('REVERSE'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    onPressed: () {
                      _secondWindowAnimationController.forward();
                    },
                    child: Text('FORWARD SECOND'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _secondWindowAnimationController.reverse();
                    },
                    child: Text('REVERSE SECOND'),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        _pos = 0.4;

                        _mainWindowAnimationController.forward();
                      });

                      print(_pos);
                    },
                    child: Text('INCREMENT FIRST'),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _secondWindowAnimationController.reverse();
                    },
                    child: Text('INCREMENT SECOND'),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MainWindow(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _secondWindowAnimationOffset,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Text('Second Window'),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: TweenAnimationBuilder(
          //     duration: Duration(milliseconds: 200),
          //     tween: Tween<Offset>(begin: Offset(0.0, 0.6), end: Offset(0.0, 0.6)),
          //     builder: (context, value, child) {
          //       return FractionalTranslation(
          //         translation: value,
          //         child: Container(
          //           height: double.infinity,
          //           color: Colors.blueAccent,
          //         ),
          //       );
          //     },
          //     child: Container(
          //       height: 200,
          //       color: Colors.blueAccent,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class MainWindow extends StatefulWidget {
  @override
  _MainWindowState createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  double _offset = 0.6;

  void _setOffset(double offset) {
    setState(() {
      _offset = offset;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 200),
      tween: Tween<Offset>(begin: Offset(0.0, 0.6), end: Offset(0.0, _offset)),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RaisedButton(
              onPressed: () {
                _setOffset(0.6);
              },
              child: Text('INITIAL'),
            ),
            RaisedButton(
              onPressed: () {
                _setOffset(0.1);
              },
              child: Text('FULL'),
            ),
            RaisedButton(
              onPressed: () {
                _setOffset(0.8);
              },
              child: Text('HIDE'),
            ),
          ],
        ),
      ),
      builder: (context, value, child) {
        return FractionalTranslation(
          translation: value,
          child: child,
        );
      },
    );
  }
}
