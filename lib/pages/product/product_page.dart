import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/product_cubit.dart';
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

class ProductPage extends StatefulWidget {
  final String keyword;

  ProductPage({@required this.keyword});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ScrollController _scrollController = ScrollController();

  AuthenticationCubit _authenticationCubit;
  QueryCubit _queryCubit;
  ProductCubit _productCubit;

  void _fetchProduct() {
    _productCubit.fetchProduct(
      user: _authenticationCubit.state.userData,
      query: QueryModel(
        filter: _queryCubit.state.query.filter.copyWith(
          keyword: widget.keyword,
        ),
        sorting: _queryCubit.state.query.sorting,
      ),
    );
  }

  void _fetchMoreProduct() {
    _productCubit.fetchMoreProduct(
      user: _authenticationCubit.state.userData,
      query: QueryModel(
        filter: _queryCubit.state.query.filter.copyWith(
          keyword: widget.keyword,
        ),
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
    _queryCubit = context.bloc<QueryCubit>();
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
                    pinned: true,
                    actions: [
                      SizedBox(width: 15),
                      ShoppingCartIcon(),
                    ],
                    title: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SearchBar(
                        scrollController: _scrollController,
                        hint: widget.keyword,
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
                        child: FilterSortBar(
                          queryCubit: _queryCubit,
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
              ProductFilter(
                scrollController: _scrollController,
                position: 0,
                queryCubit: _queryCubit,
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
