import 'package:ayo/widget/search_bar.dart';
import 'package:ayo/widget/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AyoAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final Widget flexibleSpace;
  final double titleSpacing;

  AyoAppBar(
      {Key key,
      @required this.scrollController,
      @required this.flexibleSpace,
      this.titleSpacing})
      : super(key: key);

  @override
  _AyoAppBarState createState() => _AyoAppBarState();
}

class _AyoAppBarState extends State<AyoAppBar> {
  Color _appBarIcon = Colors.white;

  void _changeIconColor(double value) {
    setState(() {
      if (value > 120.0) {
        _appBarIcon = Theme.of(context).primaryColor;
      } else {
        _appBarIcon = Colors.white;
      }
    });
  }

  void _scrollListener() {
    _changeIconColor(widget.scrollController.offset);
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220.0,
      titleSpacing: widget.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
      pinned: true,
      backgroundColor: Colors.white,
      title: SearchBar(
        scrollController: widget.scrollController,
      ),
      actions: [
        (widget.titleSpacing != null) ? SizedBox(width: 15) : SizedBox.shrink(),
        Stack(
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Ink(
              width: 20,
              child: IconButton(
                onPressed: () {},
                splashRadius: 20,
                splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                padding: EdgeInsets.zero,
                icon: Icon(
                  FontAwesomeIcons.shoppingBasket,
                  color: _appBarIcon,
                  size: 20,
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: ShoppingCart(animate: true),
            ),
          ],
        ),
        SizedBox(width: 15),
      ],
      flexibleSpace: widget.flexibleSpace ?? SizedBox.shrink(),
    );
  }
}
