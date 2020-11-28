import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/product_cubit.dart';
import 'package:ayo/model/query/filter.dart';
import 'package:ayo/model/query/query.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/widget/error_state.dart';
import 'package:ayo/widget/filter_sort_bar.dart';
import 'package:ayo/widget/product_filter.dart';
import 'package:ayo/widget/scroll_top.dart';
import 'package:ayo/widget/search_bar.dart';
import 'package:ayo/widget/shopping_cart_icon.dart';
import 'package:ayo/widget/vertical_product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Product extends StatefulWidget {
  final Filter filter;

  Product({@required this.filter});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final ScrollController _scrollController = ScrollController();

  AuthenticationCubit _authenticationCubit;
  QueryCubit _queryCubit;
  ProductCubit _productCubit;

  void _fetchProduct() {
    _productCubit.fetchProduct(
      user: _authenticationCubit.state.userData,
      query: QueryModel(
        filter: _queryCubit.state.query.filter,
        sorting: _queryCubit.state.query.sorting,
      ),
    );
  }

  void _fetchMoreProduct() {
    _productCubit.fetchMoreProduct(
      user: _authenticationCubit.state.userData,
      query: QueryModel(
        filter: _queryCubit.state.query.filter,
        sorting: _queryCubit.state.query.sorting,
      ),
    );
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
    _queryCubit.setQuery(
      QueryModel(
        filter: _queryCubit.state.query.filter.copyWith(
          subCategoryId: widget.filter.subCategoryId ?? _queryCubit.state.query.filter.subCategoryId,
          mainCategoryId: widget.filter.mainCategoryId ?? _queryCubit.state.query.filter.mainCategoryId,
          keyword: widget.filter.keyword ?? _queryCubit.state.query.filter.keyword,
          terlaris: widget.filter.terlaris ?? _queryCubit.state.query.filter.terlaris,
          diskon: widget.filter.diskon ?? _queryCubit.state.query.filter.diskon,
          search: widget.filter.search ?? _queryCubit.state.query.filter.search,
          view: widget.filter.view ?? _queryCubit.state.query.filter.view,
          rating: widget.filter.rating ?? _queryCubit.state.query.filter.rating,
          pengiriman: widget.filter.pengiriman ?? _queryCubit.state.query.filter.pengiriman,
          hargaMin: widget.filter.hargaMin ?? _queryCubit.state.query.filter.hargaMin,
          hargaMax: widget.filter.hargaMax ?? _queryCubit.state.query.filter.hargaMax,
          favourite: widget.filter.favourite ?? _queryCubit.state.query.filter.favourite,
        ),
        sorting: _queryCubit.state.query.sorting,
      ),
    );
  }

  Future _refreshData() async {
    _fetchData();
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    _authenticationCubit = context.bloc<AuthenticationCubit>();
    _queryCubit = context.bloc<QueryCubit>();
    _productCubit = context.bloc<ProductCubit>();

    //inital fetch
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
                    pinned: true,
                    actions: [
                      SizedBox(width: 15),
                      ShoppingCartIcon(),
                    ],
                    title: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/search'),
                      child: SearchBar(
                        scrollController: _scrollController,
                        hint: widget.filter.keyword,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 56,
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
                  position: 0,
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
