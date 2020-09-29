import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/scroll_show_cubit.dart';
import 'package:ayo/model/product/product.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/pages/app/bloc/product_rekomendasi_cubit.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/pages/home/bloc/main_category_cubit.dart';
import 'package:ayo/util/helper.dart';
import 'package:ayo/widget/ayo_appbar.dart';
import 'package:ayo/widget/carousel_banner.dart';
import 'package:ayo/widget/filter_bar.dart';
import 'package:ayo/widget/horizontal_product_list.dart';
import 'package:ayo/widget/shimmer/banner_shimmer.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeMain();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class HomeMain extends StatefulWidget {
  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  GlobalKey _filterWidgetKey = GlobalKey();

  AuthenticationCubit authenticateCubit;
  BannerCubit bannerCubit;
  MainCategoryCubit mainCategoryCubit;
  QueryCubit queryCubit;
  ProductRekomendasiCubit productRekomendasiCubit;

  Future<void> _fetchBanner() async {
    bannerCubit.fetchBanner(
      target: 'home',
      user: authenticateCubit.state.userData,
      id: 'home',
    );
  }

  Future<void> _fetchMainCategory() async {
    mainCategoryCubit.fetchMainCategory(
      user: authenticateCubit.state.userData,
    );
  }

  Future<void> _fetchProdukRekomendasi() async {
    productRekomendasiCubit.fetchProduct(
      user: authenticateCubit.state.userData,
      query: queryCubit.state.query,
    );
  }

  Future<void> _fetchData() async {
    //fetch banner
    if (bannerCubit.state is BannerInitial) {
      await _fetchBanner();
    }

    //fetch category
    if (mainCategoryCubit.state is MainCategoryInitial) {
      await _fetchMainCategory();
    }

    //fetch prodiuct
    if (productRekomendasiCubit.state is ProductRekomendasiInitial) {
      await _fetchProdukRekomendasi();
    }
  }

  Future _refreshData() async {
    //refresh banner
    await _fetchBanner();

    //refresh main category
    await _fetchMainCategory();

    //refresh product
    await _fetchProdukRekomendasi();
  }

  void _getFilterWidgetPosition() {
    final RenderBox renderBoxRed =
        _filterWidgetKey.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);

    context
        .bloc<ScrollShowCubit>()
        .getScrollPosition('filterProd', positionRed.dy);
  }

  void _scrollListener() {
    var scrollPos = _scrollController.position;

    _getFilterWidgetPosition();

    if (scrollPos.pixels == scrollPos.maxScrollExtent) {
      print(_scrollController.position.pixels);
    }
  }

  @override
  void initState() {
    authenticateCubit = context.bloc<AuthenticationCubit>();
    bannerCubit = context.bloc<BannerCubit>();
    mainCategoryCubit = context.bloc<MainCategoryCubit>();
    queryCubit = context.bloc<QueryCubit>();
    productRekomendasiCubit = context.bloc<ProductRekomendasiCubit>();

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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              AyoAppBar(
                scrollController: _scrollController,
                flexibleSpace: FlexibleSpaceBar(
                  background: BlocBuilder<BannerCubit, BannerState>(
                    builder: (context, state) {
                      if (state is BannerCompleted) {
                        return CarouselBanner(banners: state.banners['home']);
                      }

                      return bannerShimmer();
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
                              color: Theme.of(context).primaryColor,
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
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
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
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
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
                  height: 200,
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Kategori',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('kategori');
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lihat Semua',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<MainCategoryCubit, MainCategoryState>(
                        builder: (context, state) {
                          return Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (state is MainCategoryCompleted)
                                  ? state.mainCategories.length
                                  : 2,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          '/main_category',
                                          arguments: state
                                              ?.mainCategories[index]
                                              .categoryId,
                                        );
                                      },
                                      child: Ink(
                                        width: (size.width - 30) / 2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey[100],
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            if (state
                                                is MainCategoryCompleted) {
                                              var category =
                                                  state?.mainCategories[index];
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.network(
                                                      category.image,
                                                      width: 60,
                                                      height: 60,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      category.title,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            return boxRadiusShimmer();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
                  height: 200,
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Promo',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lihat Semua',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Builder(
                        builder: (context) {
                          var images = [
                            'https://image.freepik.com/free-vector/discount-social-media-banner-sale-liquid-background_92715-50.jpg',
                            'https://image.freepik.com/free-vector/abstract-colorful-big-sale-banner_23-2148345098.jpg',
                            'https://image.freepik.com/free-vector/end-season-summer-sale-horizontal-banner_23-2148633748.jpg',
                          ];

                          return Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: size.width - 20,
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        images[index],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
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
                  height: 250,
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Produk Terlaris',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lihat Semua',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<ProductRekomendasiCubit,
                          ProductRekomendasiState>(
                        builder: (context, state) {
                          return Expanded(
                            child: HorizontalProductList(
                              isLoading: (state is ProductRekomendasiCompleted)
                                  ? false
                                  : true,
                              products: state.productPaginate.products,
                            ),
                          );
                        },
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
                  height: 180,
                  color: Colors.white,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: Text(
                                'Paling Dicari',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lihat Semua',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right,
                                    size: 15,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Builder(
                        builder: (context) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              'https://images.unsplash.com/photo-1590165482129-1b8b27698780?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80',
                                                            ),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 3,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Ink(
                                                          height:
                                                              double.infinity,
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Kentang Impor',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 3,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Ink(
                                                          height:
                                                              double.infinity,
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Buncis',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              'https://images.unsplash.com/photo-1567375698348-5d9d5ae99de0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80',
                                                            ),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              'https://images.unsplash.com/photo-1551028150-64b9f398f678?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                                                            ),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 3,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Ink(
                                                          height:
                                                              double.infinity,
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Daging Sirloin',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Material(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      flex: 3,
                                                      child: InkWell(
                                                        onTap: () {},
                                                        child: Ink(
                                                          height:
                                                              double.infinity,
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 4,
                                                            right: 4,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Tomat Merah',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .grey[800],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Flexible(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[200],
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                CachedNetworkImageProvider(
                                                              'https://images.unsplash.com/photo-1444731961956-751ed90465a5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                                                            ),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
                  height: 30,
                  width: double.infinity,
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      child: Text(
                        'Rekomendasi',
                        style: TextStyle(
                          color: Colors.grey[800],
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
              SliverToBoxAdapter(
                child: Container(
                  key: _filterWidgetKey,
                  height: 60,
                  padding: EdgeInsets.only(left: 2.5, right: 2.5),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 2.5, right: 2.5),
                        child: Material(
                          child: InkWell(
                            onTap: () {}, // needed
                            child: Ink(
                              width: (size.width - 30) / 5,
                              padding: EdgeInsets.only(left: 2, right: 2),
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.thumb_up,
                                    size: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Semua',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.5, right: 2.5),
                        child: InkWell(
                          onTap: () {}, // needed
                          child: Ink(
                            width: (size.width - 30) / 5,
                            padding: EdgeInsets.only(left: 2, right: 2),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.monetization_on,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Diskon',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.5, right: 2.5),
                        child: InkWell(
                          onTap: () {}, // needed
                          child: Ink(
                            width: (size.width - 30) / 5,
                            padding: EdgeInsets.only(left: 2, right: 2),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_half,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Rating',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.5, right: 2.5),
                        child: InkWell(
                          onTap: () {}, // needed
                          child: Ink(
                            width: (size.width - 30) / 5,
                            padding: EdgeInsets.only(left: 2, right: 2),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.remove_red_eye,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Populer',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 2.5, right: 2.5),
                        child: InkWell(
                          onTap: () {}, // needed
                          child: Ink(
                            width: (size.width - 30) / 5,
                            padding: EdgeInsets.only(left: 2, right: 2),
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Harga',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                sliver: BlocBuilder<ProductRekomendasiCubit,
                    ProductRekomendasiState>(
                  builder: (context, state) {
                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: ((size.width - 15) / 2) / 230,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (state is ProductRekomendasiCompleted &&
                              index < state.productPaginate.products.length) {
                            Product product =
                                state.productPaginate.products[index];
                            return GestureDetector(
                              onTap: () {
                                print('detail produk');
                              },
                              onDoubleTap: () {
                                print('love it');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 120,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                        ),
                                        image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              product.cover),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            margin: EdgeInsets.only(
                                                top: 6, right: 6),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '1 kg',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 6, right: 10),
                                            child: Icon(
                                              FontAwesomeIcons.solidHeart,
                                              size: 20,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 8, right: 8, top: 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              product.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                (product.discount != null)
                                                    ? Row(
                                                        children: [
                                                          Text(
                                                            Helper()
                                                                .getFormattedNumber(
                                                              double.parse(
                                                                product.price,
                                                              ),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .grey[400],
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          ),
                                                          SizedBox(width: 4),
                                                        ],
                                                      )
                                                    : SizedBox.shrink(),
                                                Text(
                                                  Helper().getFormattedNumber(
                                                    (product.discount != null)
                                                        ? Helper()
                                                            .getDiscountedPrice(
                                                            double.parse(
                                                              product.discount
                                                                  .amount,
                                                            ),
                                                            double.parse(
                                                              product.price,
                                                            ),
                                                          )
                                                        : double.parse(
                                                            product.price,
                                                          ),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            RatingBar(
                                              initialRating: 3,
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              ignoreGestures: true,
                                              itemSize: 15,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (_) {},
                                            ),
                                            Spacer(),
                                            Text(
                                              'Pengiriman Instan',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.green[600],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return boxRadiusShimmer();
                        },
                        childCount: state.productPaginate.products.length > 0
                            ? state.productPaginate.products.length
                            : 2,
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 5,
                ),
              ),
            ],
          ),
          FilterBar(),
        ],
      ),
    );
  }
}
