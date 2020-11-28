import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/product_cubit.dart';
import 'package:ayo/model/query/filter.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/model/query/sorting.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/pages/main_category/bloc/sub_category_cubit.dart';
import 'package:ayo/widget/carousel_banner.dart';
import 'package:ayo/widget/error_state.dart';
import 'package:ayo/widget/filter_sort_bar.dart';
import 'package:ayo/widget/product_filter.dart';
import 'package:ayo/widget/scroll_top.dart';
import 'package:ayo/widget/search_bar.dart';
import 'package:ayo/widget/shimmer/banner_shimmer.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:ayo/widget/shopping_cart_icon.dart';
import 'package:ayo/widget/vertical_product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainCategory extends StatefulWidget {
  final String categoryId;

  MainCategory({@required this.categoryId});

  @override
  _MainCategoryState createState() => _MainCategoryState();
}

class _MainCategoryState extends State<MainCategory> {
  final ScrollController _scrollController = ScrollController();

  BannerCubit _bannerCubit;
  AuthenticationCubit _authenticationCubit;
  QueryCubit _queryCubit;
  SubCategoryCubit _subCategoryCubit;
  ProductCubit _productCubit;

  void _fetchBanner() {
    _bannerCubit.fetchBanner(
      id: widget.categoryId,
      target: 'kategori',
      user: _authenticationCubit.state.userData,
    );
  }

  void _fetchSubCategories() {
    _subCategoryCubit.fetchSubCategories(
        userData: _authenticationCubit.state.userData, mainCategoryId: widget.categoryId);
  }

  void _fetchProduct() {
    _productCubit.fetchProduct(
      user: _authenticationCubit.state.userData,
      query: _queryCubit.state.query.copyWith(
        filter: _queryCubit.state.query.filter.copyWith(
          mainCategoryId: widget.categoryId,
        ),
        sorting: _queryCubit.state.query.sorting,
      ),
    );
  }

  void _fetchMoreProduct() {
    _productCubit.fetchMoreProduct(
      user: _authenticationCubit.state.userData,
      query: _queryCubit.state.query.copyWith(
        filter: _queryCubit.state.query.filter.copyWith(
          mainCategoryId: widget.categoryId,
        ),
        sorting: _queryCubit.state.query.sorting,
      ),
    );
  }

  void _setQuery() {
    _queryCubit.setQuery(QueryModel(filter: Filter(mainCategoryId: widget.categoryId), sorting: Sorting()));
  }

  void _scrollListener() {
    var scrollPos = _scrollController.position;

    if (_productCubit.state is! ProductError) {
      if (scrollPos.pixels >= scrollPos.maxScrollExtent - 300 &&
          _productCubit.state.productPaginate.pagination.nextPageUrl != null &&
          _productCubit.state is! ProductPagingLoading) {
        _fetchMoreProduct();
      }
    }
  }

  void _fetchData() {
    //banner
    _fetchBanner();

    //sub categories
    _fetchSubCategories();

    //fetch product
    _fetchProduct();
  }

  Future _refreshData() async {
    _fetchData();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    _authenticationCubit = context.bloc<AuthenticationCubit>();
    _bannerCubit = context.bloc<BannerCubit>();
    _queryCubit = context.bloc<QueryCubit>();
    _subCategoryCubit = context.bloc<SubCategoryCubit>();
    _productCubit = context.bloc<ProductCubit>();

    //inital fetch
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
    return MultiBlocListener(
      listeners: [
        BlocListener<QueryCubit, QueryState>(
          listener: (context, state) {
            if (state is QueryCompleted) {
              _fetchProduct();
            }
          },
        ),
      ],
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    titleSpacing: 0,
                    expandedHeight: 220.0,
                    pinned: true,
                    actions: [
                      SizedBox(width: 15),
                      ShoppingCartIcon(),
                    ],
                    title: SearchBar(
                      scrollController: _scrollController,
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
                    child: Container(
                      height: 250,
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
                                    print('kategori');
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
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: BlocConsumer<SubCategoryCubit, SubCategoryState>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  return GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: (state is SubCategoryLoading) ? 8 : state.subCategories.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 1,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (state is SubCategoryCompleted) {
                                        var subCategory = state.subCategories[index];
                                        return Material(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(20),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pushNamed('/product',
                                                  arguments: Filter(subCategoryId: subCategory.subCategoryId));
                                            },
                                            borderRadius: BorderRadius.circular(20),
                                            splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                                            child: Ink(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.network(
                                                      subCategory.image,
                                                      width: 35,
                                                      height: 35,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      subCategory.title,
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.grey[800],
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      return boxRadiusShimmer(radius: 20);
                                    },
                                  );
                                },
                              ),
                            ),
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
                          value: _queryCubit,
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
                                retryFunction: _fetchProduct,
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
                      height: 10,
                    ),
                  ),
                ],
              ),
              BlocProvider.value(
                value: _queryCubit,
                child: ProductFilter(
                  scrollController: _scrollController,
                  position: 422,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 15),
                  child: ScrollTop(
                    scrollController: _scrollController,
                    position: MediaQuery.of(context).size.height,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
