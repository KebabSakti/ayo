import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/product_cubit.dart';
import 'package:ayo/bloc/search/popular_search_cubit.dart';
import 'package:ayo/model/query/filter.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/model/query/sorting.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/pages/app/bloc/product_terlaris_home_cubit.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/pages/home/bloc/main_category_cubit.dart';
import 'package:ayo/widget/carousel_banner.dart';
import 'package:ayo/widget/error_state.dart';
import 'package:ayo/widget/filter_sort_bar.dart';
import 'package:ayo/widget/horizontal_product_list.dart';
import 'package:ayo/widget/product_filter.dart';
import 'package:ayo/widget/scroll_top.dart';
import 'package:ayo/widget/search_bar.dart';
import 'package:ayo/widget/shimmer/banner_shimmer.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:ayo/widget/shopping_cart_icon.dart';
import 'package:ayo/widget/vertical_product_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  ScrollController _scrollController = ScrollController();
  GlobalKey _filterWidgetKey = GlobalKey();

  AuthenticationCubit authenticateCubit;
  BannerCubit bannerCubit;
  MainCategoryCubit mainCategoryCubit;
  QueryCubit queryCubit;
  ProductCubit productCubit;
  PopularSearchCubit _popularSearchCubit;
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

  Future<void> _fetchPopularSearches() async {
    _popularSearchCubit.fetchPopularSearch(user: authenticateCubit.state.userData);
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

    //fetch product
    if (productCubit.state is ProductInitial) {
      await _fetchProdukRekomendasi();
    }

    //fetch product terlaris home
    if (productTerlarisHomeCubit.state is ProductTerlarisHomeInitial) {
      await _fetchProdukTerlarisHome();
    }

    //fetch popular searches
    if (_popularSearchCubit.state is PopularSearchInitial) {
      await _fetchPopularSearches();
    }
  }

  Future _refreshData() async {
    //refresh banner
    await _fetchBanner();

    //refresh main category
    await _fetchMainCategory();

    //refresh product
    await _fetchProdukRekomendasi();

    await _fetchPopularSearches();

    await _fetchProdukTerlarisHome();
  }

  void _navigateToSearch(String keyword) {
    Navigator.of(context).pushNamed('/product', arguments: Filter(keyword: keyword));
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
    _popularSearchCubit = context.bloc<PopularSearchCubit>();
    productTerlarisHomeCubit = context.bloc<ProductTerlarisHomeCubit>();

    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //fetch data
      _fetchData();
    });

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
                SliverAppBar(
                  expandedHeight: 220.0,
                  pinned: true,
                  actions: [
                    ShoppingCartIcon(),
                  ],
                  title: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/search'),
                    child: SearchBar(
                      scrollController: _scrollController,
                    ),
                  ),
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
                                splashColor: Theme.of(context).accentColor.withOpacity(0.3),
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
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
                                  Navigator.of(context).pushNamed('/category');
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                itemCount: (state is MainCategoryCompleted) ? state.mainCategories.length : 2,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Material(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            '/main_category',
                                            arguments: state?.mainCategories[index].categoryId,
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                                        child: Ink(
                                          width: (size.width - 30) / 2,
                                          child: Builder(
                                            builder: (context) {
                                              if (state is MainCategoryCompleted) {
                                                var category = state?.mainCategories[index];
                                                return Padding(
                                                  padding: EdgeInsets.only(left: 10, right: 10),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                        textAlign: TextAlign.center,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          color: Colors.grey[800],
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }

                                              return boxRadiusShimmer(radius: 20);
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
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                                        child: Ink(
                                          width: size.width - 20,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
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
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
                                onTap: () {
                                  Navigator.of(context).pushNamed('/product', arguments: Filter(terlaris: 1));
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        BlocBuilder<ProductTerlarisHomeCubit, ProductTerlarisHomeState>(
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

                            return Expanded(
                              child: HorizontalProductList(
                                isLoading: (state is ProductTerlarisHomeLoading) ? true : false,
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
                BlocBuilder<PopularSearchCubit, PopularSearchState>(
                  builder: (context, state) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 180,
                        color: Colors.white,
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
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
                                    onTap: () {
                                      _navigateToSearch(state.searchs[0].keyword);
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: _fetchPopularSearches,
                                          child: Text(
                                            'Refresh',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.refresh,
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
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: (state is PopularSearchComplete)
                                                ? Material(
                                                    child: InkWell(
                                                      onTap: () {
                                                        _navigateToSearch(state.searchs[0].keyword);
                                                      },
                                                      borderRadius: BorderRadius.circular(10),
                                                      splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                                                      child: Ink(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(
                                                            color: Colors.grey[300],
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            (state.searchs[0].image != null)
                                                                ? Flexible(
                                                                    flex: 2,
                                                                    child: Ink(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.grey[200],
                                                                        image: DecorationImage(
                                                                          fit: BoxFit.cover,
                                                                          image: CachedNetworkImageProvider(
                                                                              state.searchs[0].image),
                                                                        ),
                                                                        borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(10),
                                                                          bottomLeft: Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox.shrink(),
                                                            Flexible(
                                                              flex: 3,
                                                              child: Ink(
                                                                height: double.infinity,
                                                                padding: EdgeInsets.only(
                                                                  left: 4,
                                                                  right: 4,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    '${state.searchs[0].keyword}',
                                                                    textAlign: TextAlign.center,
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.grey[800],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : boxRadiusShimmer(),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: (state is PopularSearchComplete)
                                                ? Material(
                                                    child: InkWell(
                                                      onTap: () {
                                                        _navigateToSearch(state.searchs[1].keyword);
                                                      },
                                                      borderRadius: BorderRadius.circular(10),
                                                      splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                                                      child: Ink(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(
                                                            color: Colors.grey[300],
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              flex: 3,
                                                              child: Ink(
                                                                height: double.infinity,
                                                                padding: EdgeInsets.only(
                                                                  left: 4,
                                                                  right: 4,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    '${state.searchs[1].keyword}',
                                                                    textAlign: TextAlign.center,
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.grey[800],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            (state.searchs[1].image != null)
                                                                ? Flexible(
                                                                    flex: 2,
                                                                    child: Ink(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.grey[200],
                                                                        image: DecorationImage(
                                                                          fit: BoxFit.cover,
                                                                          image: CachedNetworkImageProvider(
                                                                              state.searchs[1].image),
                                                                        ),
                                                                        borderRadius: BorderRadius.only(
                                                                          topRight: Radius.circular(10),
                                                                          bottomRight: Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox.shrink(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : boxRadiusShimmer(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: (state is PopularSearchComplete)
                                                ? Material(
                                                    child: InkWell(
                                                      onTap: () {
                                                        _navigateToSearch(state.searchs[2].keyword);
                                                      },
                                                      borderRadius: BorderRadius.circular(10),
                                                      splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                                                      child: Ink(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(
                                                            color: Colors.grey[300],
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            (state.searchs[2].image != null)
                                                                ? Flexible(
                                                                    flex: 2,
                                                                    child: Ink(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.grey[200],
                                                                        image: DecorationImage(
                                                                          fit: BoxFit.cover,
                                                                          image: CachedNetworkImageProvider(
                                                                              state.searchs[2].image),
                                                                        ),
                                                                        borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(10),
                                                                          bottomLeft: Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox.shrink(),
                                                            Flexible(
                                                              flex: 3,
                                                              child: Ink(
                                                                height: double.infinity,
                                                                padding: EdgeInsets.only(
                                                                  left: 4,
                                                                  right: 4,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    '${state.searchs[2].keyword}',
                                                                    textAlign: TextAlign.center,
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.grey[800],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : boxRadiusShimmer(),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: (state is PopularSearchComplete)
                                                ? Material(
                                                    child: InkWell(
                                                      onTap: () {
                                                        _navigateToSearch(state.searchs[3].keyword);
                                                      },
                                                      borderRadius: BorderRadius.circular(10),
                                                      splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                                                      child: Ink(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(
                                                            color: Colors.grey[300],
                                                          ),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              flex: 3,
                                                              child: Ink(
                                                                height: double.infinity,
                                                                padding: EdgeInsets.only(
                                                                  left: 4,
                                                                  right: 4,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    '${state.searchs[3].keyword}',
                                                                    textAlign: TextAlign.center,
                                                                    maxLines: 3,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: TextStyle(
                                                                      fontSize: 12,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.grey[800],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            (state.searchs[3].image != null)
                                                                ? Flexible(
                                                                    flex: 2,
                                                                    child: Ink(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.grey[200],
                                                                        image: DecorationImage(
                                                                          fit: BoxFit.cover,
                                                                          image: CachedNetworkImageProvider(
                                                                              state.searchs[3].image),
                                                                        ),
                                                                        borderRadius: BorderRadius.only(
                                                                          topRight: Radius.circular(10),
                                                                          bottomRight: Radius.circular(10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox.shrink(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : boxRadiusShimmer(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                      child: BlocProvider.value(
                        value: queryCubit,
                        child: FilterSortBar(),
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

                      return VerticalProductList(
                        isLoading: (state is ProductLoading) ? true : false,
                        moreLoading: (state is ProductPagingLoading) ? true : false,
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
            BlocProvider.value(
              value: queryCubit,
              child: ProductFilter(
                scrollController: _scrollController,
                position: 1100,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 15),
                child: ScrollTop(
                  scrollController: _scrollController,
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
