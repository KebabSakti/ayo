import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  ScrollController _scrollController = ScrollController();

  bool loading = false;

  List<Widget> myList = List<Widget>.generate(
      10, (index) => ListTile(title: Text('Index is $index')));

  void _addMoreData() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        for (var i = 0; i <= 5; i++) {
          myList.add(ListTile(title: Text('Index is ${myList.length}')));
        }

        loading = false;
      });
    });
  }

  void _scrollListener() {
    var scrollPos = _scrollController.position;

    var scrollDown = scrollPos.userScrollDirection == ScrollDirection.reverse;
    var shouldLoadMore = (scrollPos.pixels >= scrollPos.maxScrollExtent - 150 &&
        scrollPos.pixels <= scrollPos.maxScrollExtent);

    if (scrollPos.maxScrollExtent == scrollPos.pixels) {
      setState(() {
        loading = true;
      });

      _addMoreData();
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);
    final height = (screen.size.height - 56 - 30) / 2;
    final width = (screen.size.width - 30) / 2;
    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Container(
              // margin: EdgeInsets.only(left: 10, right: 5),
              color: Colors.green,
              height: height,
              width: width,
            ),
            SizedBox(width: 10),
            Container(
              // margin: EdgeInsets.only(left: 5, right: 10),
              color: Colors.amber,
              height: height,
              width: width,
            ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            SizedBox(width: 10),
            Container(
              // margin: EdgeInsets.only(left: 10, right: 5),
              color: Colors.red,
              height: height,
              width: width,
            ),
            SizedBox(width: 10),
            Container(
              // margin: EdgeInsets.only(left: 5, right: 10),
              color: Colors.blue,
              height: height,
              width: width,
            ),
            SizedBox(width: 10),
          ],
        ),
        SizedBox(height: 10),
      ],
    ));
  }
}

// ListView.builder(
// shrinkWrap: true,
// controller: _scrollController,
// itemBuilder: (context, index) {
// if (index + 1 == myList.length) {
// return loading
// ? Container(
// padding: EdgeInsets.only(left: 4, right: 4),
// height: 50,
// width: double.infinity,
// child: boxRadiusShimmer(),
// )
//     : SizedBox.shrink();
// }
//
// return Card(
// child: myList[index],
// );
// },
// itemCount: myList.length,
// )
