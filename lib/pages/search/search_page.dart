import 'dart:async';

import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/search/search_cubit.dart';
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
  TextEditingController _searchField = TextEditingController();

  Timer _timer;

  void _searchByKeyword(String keyword) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(
      Duration(milliseconds: 800),
      () => _searchCubit.searchByKeyword(
        user: _authenticationCubit.state.userData,
        keyword: keyword,
      ),
    );
  }

  void _fetchPopularSearch() {
    _searchCubit.fetchPopularSearch(user: _authenticationCubit.state.userData);
  }

  void _searchFieldListener() {
    _searchByKeyword(_searchField.text);
  }

  @override
  void initState() {
    _authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
    _searchCubit = BlocProvider.of<SearchCubit>(context);
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
                  suffixIcon: (_searchField.text.length > 0)
                      ? GestureDetector(
                          onTap: () {
                            print('tap tap');
                          },
                          child: Icon(Icons.close),
                        )
                      : SizedBox.shrink(),
                  suffixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 32),
                ),
              ),
            ),
          ),
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is PopularSearchLoading || state is SearchLoading) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ListTile(
                      onTap: () {},
                      dense: true,
                      title: boxRadiusShimmer(width: double.infinity, height: 15, radius: 6),
                      subtitle: boxRadiusShimmer(width: 1, height: 15, radius: 6),
                    );
                  },
                  childCount: 10,
                ));
              }

              if (state is PopularSearchComplete) {
                return SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var data = state.searchs[index];
                    return ListTile(
                      onTap: () {},
                      dense: true,
                      title: Text(
                        '${data.keyword}',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        '${data.hits} pencarian',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                  childCount: state.searchs.length,
                ));
              } else if (state is SearchComplete) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var data = state.products[index];
                      return ListTile(
                        onTap: () {},
                        dense: true,
                        trailing: Icon(
                          Icons.search,
                          size: 20,
                        ),
                        title: Text(
                          '${data.name}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                    childCount: state.products.length,
                  ),
                );
              }

              return SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}
