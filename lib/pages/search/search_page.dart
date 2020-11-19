import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/search/popular_search_cubit.dart';
import 'package:ayo/bloc/search/search_cubit.dart';
import 'package:ayo/model/search/search.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AuthenticationCubit _authenticationCubit;
  SearchCubit _searchCubit;
  PopularSearchCubit _popularSearchCubit;
  TextEditingController _searchField = TextEditingController();

  void _searchByKeyword(String keyword) {
    _searchCubit.searchByKeyword(user: _authenticationCubit.state.userData, keyword: keyword);
  }

  void _fetchPopularSearch() {
    _popularSearchCubit.fetchPopularSearch(user: _authenticationCubit.state.userData);
  }

  void _searchFieldListener() {
    _searchByKeyword(_searchField.text);
  }

  @override
  void initState() {
    _authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
    _searchCubit = BlocProvider.of<SearchCubit>(context);
    _popularSearchCubit = BlocProvider.of<PopularSearchCubit>(context);
    _searchField.addListener(_searchFieldListener);

    _fetchPopularSearch();

    super.initState();
  }

  @override
  void dispose() {
    _searchField.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            titleSpacing: 0,
            pinned: true,
            title: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: TextField(
                controller: _searchField,
                style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                cursorColor: Colors.grey[800],
                cursorWidth: 1,
                decoration: InputDecoration(
                  hintText: 'Cari di sini',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(6)),
                  isDense: true, // Added this
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: EdgeInsets.all(10),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  prefixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 32),
                ),
              ),
            ),
          ),
          BlocBuilder<PopularSearchCubit, PopularSearchState>(
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 15,
                      ),
                      child: Text(
                        'Pencarian Populer',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var data = (state is PopularSearchComplete) ? state.searchs[index] : Search();
                        return Material(
                          child: InkWell(
                            onTap: () {},
                            splashColor: Theme.of(context).accentColor.withOpacity(0.3),
                            child: Ink(
                              color: Colors.white,
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (state is PopularSearchComplete)
                                        ? Text(
                                            '${data.keyword}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              color: Colors.grey[800],
                                            ),
                                          )
                                        : boxRadiusShimmer(width: double.infinity, height: 15, radius: 6),
                                    SizedBox(height: 2),
                                    (state is PopularSearchComplete)
                                        ? Text(
                                            '${data.hits} pencarian',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          )
                                        : boxRadiusShimmer(width: 150, height: 15, radius: 6),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: (state is PopularSearchComplete) ? state.searchs.length : 10,
                    ),
                  ],
                ),
              );
            },
          ),
          // BlocBuilder<SearchCubit, SearchState>(
          //   builder: (context, state) {
          //     if (_searchField.text.length == 0) {
          //       return BlocBuilder<PopularSearchCubit, PopularSearchState>(
          //         builder: (context, state) {
          //           return SliverList(
          //             delegate: SliverChildBuilderDelegate(
          //               (context, index) {
          //                 var data = (state is PopularSearchComplete) ? state.searchs[index] : Search();
          //                 return Material(
          //                   child: InkWell(
          //                     onTap: () {},
          //                     splashColor: Theme.of(context).accentColor.withOpacity(0.3),
          //                     child: Ink(
          //                       color: Colors.white,
          //                       height: 60,
          //                       child: Padding(
          //                         padding: const EdgeInsets.only(
          //                           left: 15,
          //                           right: 15,
          //                         ),
          //                         child: Column(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             (state is PopularSearchComplete)
          //                                 ? Text(
          //                                     '${data.keyword}',
          //                                     textAlign: TextAlign.left,
          //                                     style: TextStyle(
          //                                       fontWeight: FontWeight.w800,
          //                                       color: Colors.grey[800],
          //                                     ),
          //                                   )
          //                                 : boxRadiusShimmer(width: double.infinity, height: 15, radius: 6),
          //                             SizedBox(height: 2),
          //                             (state is PopularSearchComplete)
          //                                 ? Text(
          //                                     '${data.hits} pencarian',
          //                                     style: TextStyle(
          //                                       color: Colors.grey[600],
          //                                       fontSize: 12,
          //                                     ),
          //                                   )
          //                                 : boxRadiusShimmer(width: 150, height: 15, radius: 6),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 );
          //               },
          //               childCount: (state is PopularSearchComplete) ? state.searchs.length : 10,
          //             ),
          //           );
          //         },
          //       );
          //     } else {
          //       if (state is SearchComplete) {
          //         return SliverList(
          //           delegate: SliverChildBuilderDelegate(
          //             (context, index) {
          //               var data = state.products[index];
          //               return Material(
          //                 child: InkWell(
          //                   onTap: () {},
          //                   splashColor: Theme.of(context).accentColor.withOpacity(0.3),
          //                   child: Ink(
          //                     color: Colors.white,
          //                     height: 60,
          //                     child: Padding(
          //                       padding: const EdgeInsets.only(
          //                         top: 15,
          //                         left: 15,
          //                         right: 15,
          //                       ),
          //                       child: Row(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           (state is SearchComplete)
          //                               ? Container(
          //                                   height: 100,
          //                                   width: 50,
          //                                   decoration: BoxDecoration(
          //                                     borderRadius: BorderRadius.all(
          //                                       Radius.circular(6),
          //                                     ),
          //                                     image: DecorationImage(
          //                                       fit: BoxFit.cover,
          //                                       image: CachedNetworkImageProvider(data.cover),
          //                                     ),
          //                                   ),
          //                                 )
          //                               : boxRadiusShimmer(height: 100, width: 50, radius: 6),
          //                           SizedBox(
          //                             width: 10,
          //                           ),
          //                           Text('asd'),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             },
          //             childCount: (state is ProductCompleted) ? state.products.length : 10,
          //           ),
          //         );
          //       } else {
          //         return SliverToBoxAdapter(child: SizedBox.shrink());
          //       }
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
