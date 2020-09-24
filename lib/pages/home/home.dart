import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/theme_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/pages/app/bloc/product_terlaris_kategori_cubit.dart';
import 'package:ayo/pages/app/bloc/scroll_position_cubit.dart';
import 'package:ayo/pages/home/bloc/main_category_cubit.dart';
import 'package:ayo/theme/theme.dart';
import 'package:ayo/widget/carousel_banner.dart';
import 'package:ayo/widget/shimmer/banner_shimmer.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import 'package:supercharged/supercharged.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeMain();
  }
}

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  ScrollController _scrollController;

  AuthenticationCubit authenticateCubit;
  ScrollPositionCubit scrollPositionCubit;
  BannerCubit bannerCubit;
  MainCategoryCubit mainCategoryCubit;
  ProductTerlarisKategoriCubit productTerlarisKategoriCubit;

  void _fetchBanner() {
    bannerCubit.fetchBanner(
      target: 'home',
      user: authenticateCubit.state.userData,
    );
  }

  void _fetchMainCategory() {
    mainCategoryCubit.fetchMainCategory(
      user: authenticateCubit.state.userData,
    );
  }

  void _fetchProductTerlarisKategori() {
    //produk terlaris berdasarkan kategori
    // productTerlarisKategoriCubit.fetchProductTerlarisKategori();
  }

  void _fetchData() {
    //fetch banner
    if (bannerCubit.state is BannerInitial) {
      _fetchBanner();
    }

    //fetch category
    if (mainCategoryCubit.state is MainCategoryInitial) {
      _fetchMainCategory();
    }
  }

  Future _refreshData() async {
    //refresh banner
    _fetchBanner();

    //refresh main category
    _fetchMainCategory();
  }

  void _scrollListener() {
    scrollPositionCubit.keepScrollPosition(
        'home', _scrollController.position.pixels);
  }

  @override
  void initState() {
    context.bloc<ThemeCubit>().loadTheme(appThemeData[AppTheme.gas]);

    authenticateCubit = context.bloc<AuthenticationCubit>();
    scrollPositionCubit = context.bloc<ScrollPositionCubit>();
    bannerCubit = context.bloc<BannerCubit>();
    mainCategoryCubit = context.bloc<MainCategoryCubit>();
    productTerlarisKategoriCubit = context.bloc<ProductTerlarisKategoriCubit>();

    _scrollController = ScrollController(
        initialScrollOffset:
            scrollPositionCubit.state.scrollPosition['home'] ?? 0);
    _scrollController.addListener(_scrollListener);

    //fetch data
    _fetchData();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        slivers: [
          AyoAppBar(scrollController: _scrollController),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.grey[200]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.qrcode,
                          size: 20,
                          color: Colors.pink[300],
                        ),
                        onPressed: () async {
                          String cameraScanResult = await scanner.scan();
                          print(cameraScanResult);
                        },
                      ),
                      Text(
                        'scan kode promo',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.coins,
                          color: Colors.amber,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '9999',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: (itemHeight - 37) / 2,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: BlocBuilder<MainCategoryCubit, MainCategoryState>(
                builder: (context, state) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: (itemWidth - 10) / itemHeight,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.mainCategories.length > 0
                        ? state.mainCategories.length
                        : 2,
                    itemBuilder: (context, index) {
                      if (state is MainCategoryCompleted) {
                        return GestureDetector(
                          child: Container(
                            // height: (itemHeight - 30) / 2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  state.mainCategories[index].image,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: Colors.grey[200]),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: Text(
                                    '${state.mainCategories[index].title}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        );
                      }
                      return boxRadiusShimmer();
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 30,
              width: double.infinity,
              color: Colors.white,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    'Rekomendasi dari kami',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 5,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 5, right: 5),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (itemWidth - 5) / 275,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    height: 275,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8, right: 8, top: 5),
                            child: Column(
                              children: [
                                Container(
                                  height: 35,
                                  child: Text(
                                    'Daging sapi sirloin murah sekali tapi mahal',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Rp 100.000',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[400],
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      'Rp 50.000',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                RatingBar(
                                  initialRating: 3,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  ignoreGestures: true,
                                  itemSize: 20,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (_) {},
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Pengiriman Instan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.green[600],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              width: double.infinity,
              color: Colors.white,
              child: BlocBuilder<BannerCubit, BannerState>(
                builder: (context, state) {
                  if (state is BannerCompleted) {
                    return Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 6, top: 6, bottom: 6),
                            child: Text('Kamu mungkin tertarik'),
                          ),
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      state.banners[0].url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return bannerShimmer();
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
        ],
      ),
    );
  }
}

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
    _changeIconColor(
        context.bloc<ScrollPositionCubit>().state.scrollPosition['home'] ?? 0);

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

class SearchBar extends StatefulWidget {
  final ScrollController scrollController;
  const SearchBar({Key key, @required this.scrollController}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Color _searchBarColor = Colors.white;

  void _changeIconColor(double value) {
    setState(() {
      if (value > 120.0) {
        _searchBarColor = Colors.grey[100];
      } else {
        _searchBarColor = Colors.white;
      }
    });
  }

  void _scrollListener() {
    _changeIconColor(widget.scrollController.offset);
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);
    _changeIconColor(
        context.bloc<ScrollPositionCubit>().state.scrollPosition['home'] ?? 0);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: _searchBarColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          SizedBox(width: 5),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 200,
              child: Text(
                'Cari bayam segar',
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

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
