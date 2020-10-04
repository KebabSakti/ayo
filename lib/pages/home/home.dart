import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/product_cubit.dart';
import 'package:ayo/model/query/filter.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/model/query/sorting.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/pages/app/bloc/product_terlaris_home_cubit.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/pages/home/bloc/main_category_cubit.dart';
import 'package:ayo/widget/ayo_appbar.dart';
import 'package:ayo/widget/carousel_banner.dart';
import 'package:ayo/widget/error_state.dart';
import 'package:ayo/widget/filter_sort_bar.dart';
import 'package:ayo/widget/horizontal_product_list.dart';
import 'package:ayo/widget/product_filter.dart';
import 'package:ayo/widget/scroll_top.dart';
import 'package:ayo/widget/shimmer/banner_shimmer.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:ayo/widget/vertical_product_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  ProductCubit productCubit;
  ProductTerlarisHomeCubit productTerlarisHomeCubit;

  QueryModel queryModel = QueryModel(filter: Filter(), sorting: Sorting());

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
    productCubit.fetchProduct(
      user: authenticateCubit.state.userData,
      query: queryCubit.state.query,
    );
  }

  Future<void> _fetchMoreProdukRekomendasi() async {
    productCubit.fetchMoreProduct(
      user: authenticateCubit.state.userData,
      query: queryCubit.state.query,
    );
  }

  Future<void> _fetchProdukTerlarisHome() async {
    productTerlarisHomeCubit.fetchProduct(
      user: authenticateCubit.state.userData,
      query: QueryModel(filter: Filter(terlaris: 1), sorting: Sorting()),
    );
  }

  Future<void> _fetchFilteredProduct(QueryModel queryModel) async {
    queryModel = queryModel;

    productCubit.fetchProduct(
      user: authenticateCubit.state.userData,
      query: queryModel,
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
    if (productCubit.state is ProductInitial) {
      await _fetchProdukRekomendasi();
    }

    //fetch product terlaris home
    if (productTerlarisHomeCubit.state is ProductTerlarisHomeInitial) {
      await _fetchProdukTerlarisHome();
    }
  }

  Future _refreshData() async {
    //refresh banner
    await _fetchBanner();

    //refresh main category
    await _fetchMainCategory();

    //refresh product
    await _fetchProdukRekomendasi();

    await _fetchProdukTerlarisHome();
  }

  void _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(
          milliseconds: 1000,
        ),
        curve: Curves.easeIn);
  }

  void _scrollListener() async {
    var scrollPos = _scrollController.position;

    if (productCubit.state is! ProductError) {
      if (scrollPos.pixels >= scrollPos.maxScrollExtent - 300 &&
          productCubit.state.productPaginate.pagination.nextPageUrl != null &&
          productCubit.state is! ProductPagingLoading) {
        await _fetchMoreProdukRekomendasi();
      }
    }
  }

  @override
  void initState() {
    authenticateCubit = context.bloc<AuthenticationCubit>();
    bannerCubit = context.bloc<BannerCubit>();
    mainCategoryCubit = context.bloc<MainCategoryCubit>();
    queryCubit = context.bloc<QueryCubit>();
    productCubit = context.bloc<ProductCubit>();
    productTerlarisHomeCubit = context.bloc<ProductTerlarisHomeCubit>();

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

    return MultiBlocListener(
      listeners: [
        BlocListener<QueryCubit, QueryState>(
          listener: (context, state) {
            if (state is! QueryLoading) {
              _fetchProdukRekomendasi();
            }
          },
        ),
      ],
      child: RefreshIndicator(
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
                          return CarouselBanner(banners: state.banners);
                        }

                        if (state is BannerError) {
                          return Center(
                            child: ErrorState(
                              retryFunction: _fetchBanner,
                            ),
                          );
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
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Ink(
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
                                splashColor: Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.3),
                                icon: Icon(
                                  FontAwesomeIcons.qrcode,
                                  size: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () async {
                                  String cameraScanResult =
                                      await scanner.scan();
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
                                        borderRadius: BorderRadius.circular(10),
                                        splashColor: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.3),
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
                                                var category = state
                                                    ?.mainCategories[index];
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[800],
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
                  child: Container(
                    height: 10,
                    color: Colors.grey[100],
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
                                  return Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Material(
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.circular(10),
                                        splashColor: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.3),
                                        child: Ink(
                                          width: size.width - 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                images[index],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
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
                  child: Container(
                    height: 10,
                    color: Colors.grey[100],
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
                        BlocBuilder<ProductTerlarisHomeCubit,
                            ProductTerlarisHomeState>(
                          builder: (context, state) {
                            if (state is ProductTerlarisHomeError) {
                              return Center(
                                child: Align(
                                  child: ErrorState(
                                    retryFunction: _fetchProdukTerlarisHome,
                                  ),
                                ),
                              );
                            }

                            //
                            // if (state is ProductTerlarisHomeLoading) {
                            //   return Center(
                            //     child: CircularProgressIndicator(),
                            //   );
                            // }

                            return Expanded(
                              child: HorizontalProductList(
                                isLoading: (state is ProductTerlarisHomeLoading)
                                    ? true
                                    : false,
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
                  child: Container(
                    height: 10,
                    color: Colors.grey[100],
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                splashColor: Theme.of(context)
                                                    .accentColor
                                                    .withOpacity(0.3),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.grey[300],
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex: 2,
                                                        child: Ink(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  CachedNetworkImageProvider(
                                                                'https://images.unsplash.com/photo-1590165482129-1b8b27698780?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=564&q=80',
                                                              ),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 3,
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                splashColor: Theme.of(context)
                                                    .accentColor
                                                    .withOpacity(0.3),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.grey[300],
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        flex: 3,
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
                                                      Flexible(
                                                        flex: 2,
                                                        child: Ink(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  CachedNetworkImageProvider(
                                                                'https://images.unsplash.com/photo-1567375698348-5d9d5ae99de0?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=675&q=80',
                                                              ),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
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
                                                        BorderRadius.circular(
                                                            10),
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
                                                            color: Colors
                                                                .grey[200],
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  CachedNetworkImageProvider(
                                                                'https://images.unsplash.com/photo-1551028150-64b9f398f678?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                                                              ),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
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
                                                        BorderRadius.circular(
                                                            10),
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                          .grey[
                                                                      800],
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
                                                            color: Colors
                                                                .grey[200],
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  CachedNetworkImageProvider(
                                                                'https://images.unsplash.com/photo-1444731961956-751ed90465a5?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                                                              ),
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
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
                  child: Container(
                    height: 10,
                    color: Colors.grey[100],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    key: _filterWidgetKey,
                    height: 56,
                    // padding: EdgeInsets.only(left: 10, right: 10),
                    child: Ink(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                      child: FilterSortBar(
                        filterCallback: _fetchFilteredProduct,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  sliver: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      if (state is ProductError) {
                        return SliverToBoxAdapter(
                          child: Center(
                            child: ErrorState(
                              retryFunction: _fetchProdukRekomendasi,
                            ),
                          ),
                        );
                      }

                      // if (state is ProductRekomendasiLoading) {
                      //   return SliverToBoxAdapter(
                      //     child: Center(
                      //       child: CircularProgressIndicator(),
                      //     ),
                      //   );
                      // }

                      return VerticalProductList(
                        isLoading: (state is ProductLoading) ? true : false,
                        moreLoading:
                            (state is ProductPagingLoading) ? true : false,
                        products: state.productPaginate.products,
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
            ProductFilter(
              scrollController: _scrollController,
              position: 1100,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 15),
                child: ScrollTop(
                  scrollController: _scrollController,
                  scrollToTop: _scrollToTop,
                  position: size.height,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
