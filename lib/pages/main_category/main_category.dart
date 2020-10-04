import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_cubit.dart';
import 'package:ayo/pages/app/bloc/banner_state.dart';
import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/widget/ayo_appbar.dart';
import 'package:ayo/widget/carousel_banner.dart';
import 'package:ayo/widget/shimmer/banner_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _fetchBanner() {
    _bannerCubit.fetchBanner(
      id: widget.categoryId,
      target: 'kategori',
      user: _authenticationCubit.state.userData,
    );
  }

  void _scrollListener() {
    //
  }

  void _fetchData() {
    //banner
    _fetchBanner();
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
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: Stack(
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

                        return bannerShimmer();
                      },
                    ),
                  ),
                  titleSpacing: 0,
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: GridView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(color: Colors.grey[100]),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
