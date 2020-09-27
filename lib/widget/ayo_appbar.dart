import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/widget/carousel_banner.dart';
import 'package:ayo/widget/search_bar.dart';
import 'package:ayo/widget/shimmer/banner_shimmer.dart';
import 'package:ayo/widget/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AyoAppBar extends StatefulWidget {
  final ScrollController scrollController;

  AyoAppBar({Key key, @required this.scrollController}) : super(key: key);

  @override
  _AyoAppBarState createState() => _AyoAppBarState();
}

class _AyoAppBarState extends State<AyoAppBar> {
  Color _appBarIcon = Colors.white;

  void _changeIconColor(double value) {
    setState(() {
      if (value > 120.0) {
        _appBarIcon = Colors.pink[300];
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
      pinned: true,
      backgroundColor: Colors.white,
      title: SearchBar(
        scrollController: widget.scrollController,
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Icon(
              FontAwesomeIcons.shoppingBag,
              color: _appBarIcon,
              size: 20,
            ),
            Positioned(
              left: 8,
              top: 10,
              child: ShoppingCart(animate: true),
            ),
          ],
        ),
        SizedBox(width: 15),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: BlocBuilder<BannerCubit, BannerState>(
          builder: (context, state) {
            if (state is BannerCompleted) {
              return CarouselBanner(banners: state.banners);
            }

            return bannerShimmer();
          },
        ),
      ),
    );
  }
}
