import 'dart:async';

import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/bloc/search/history_search_cubit.dart';
import 'package:ayo/bloc/search/popular_search_cubit.dart';
import 'package:ayo/bloc/search/search_cubit.dart';
import 'package:ayo/bloc/search/search_process_cubit.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchField = TextEditingController();

  AuthenticationCubit _authenticationCubit;
  SearchCubit _searchCubit;
  PopularSearchCubit _popularSearchCubit;
  HistorySearchCubit _historySearchCubit;
  SearchProcessCubit _searchProcessCubit;

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
    _popularSearchCubit.fetchPopularSearch(user: _authenticationCubit.state.userData);
  }

  void _fetchSearchHistory() {
    _historySearchCubit.fetchSearchHistory(user: _authenticationCubit.state.userData);
  }

  void _searchFieldListener() {
    _searchByKeyword(_searchField.text);
  }

  void _saveSearchKeyword(String keyword) {
    _searchProcessCubit.saveSearchKeyword(userData: _authenticationCubit.state.userData, keyword: keyword);
  }

  void _clearSerchKeyword() {
    _searchProcessCubit.clearSearchKeyword(userData: _authenticationCubit.state.userData);
  }

  void _navigateToProductPage(String keyword) {
    //save search keyword
    _saveSearchKeyword(keyword);

    //navigate
    Navigator.of(context).pushNamed("/product_page", arguments: keyword);
  }

  @override
  void initState() {
    _authenticationCubit = BlocProvider.of<AuthenticationCubit>(context);
    _searchCubit = BlocProvider.of<SearchCubit>(context);
    _popularSearchCubit = BlocProvider.of<PopularSearchCubit>(context);
    _historySearchCubit = BlocProvider.of<HistorySearchCubit>(context);
    _searchProcessCubit = BlocProvider.of<SearchProcessCubit>(context);

    _searchField.addListener(_searchFieldListener);

    _fetchPopularSearch();
    _fetchSearchHistory();

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
                autofocus: true,
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
                            //
                          },
                          child: Icon(Icons.close),
                        )
                      : SizedBox.shrink(),
                  suffixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 32),
                ),
                onSubmitted: (value) => _navigateToProductPage(_searchField.text),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return MediaQuery.removePadding(
                    removeTop: true,
                    removeBottom: false,
                    removeLeft: false,
                    removeRight: false,
                    context: context,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: boxRadiusShimmer(
                                  width: double.infinity,
                                  height: 15,
                                  radius: 6,
                                ),
                              ),
                              SizedBox(width: 10),
                              boxRadiusShimmer(
                                width: 15,
                                height: 15,
                                radius: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                if (state is SearchComplete) {
                  return (state.searches.length > 0)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                              child: Text(
                                'Hasil Pencarian',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            MediaQuery.removePadding(
                              removeTop: true,
                              removeBottom: false,
                              removeLeft: false,
                              removeRight: false,
                              context: context,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.searches.length,
                                itemBuilder: (context, index) {
                                  var data = state.searches[index];
                                  return ListTile(
                                    onTap: () {
                                      _navigateToProductPage(data.keyword);
                                    },
                                    dense: true,
                                    trailing: Icon(
                                      Icons.search,
                                      size: 20,
                                    ),
                                    title: Text(
                                      '${data.keyword}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        )
                      : SizedBox.shrink();
                }

                return SizedBox.shrink();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<HistorySearchCubit, HistorySearchState>(
              builder: (context, state) {
                if (state is HistorySearchLoading) {
                  return MediaQuery.removePadding(
                    removeTop: true,
                    removeBottom: false,
                    removeLeft: false,
                    removeRight: false,
                    context: context,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: boxRadiusShimmer(
                                  width: double.infinity,
                                  height: 15,
                                  radius: 6,
                                ),
                              ),
                              SizedBox(width: 10),
                              boxRadiusShimmer(
                                width: 15,
                                height: 15,
                                radius: 10,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                if (state is HistorySearchComplete) {
                  return (state.searches.length > 0)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Riwayat Pencarian',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  BlocListener<SearchProcessCubit, SearchProcessState>(
                                    listener: (context, state) {
                                      if (state is SearchProcessComplete) _fetchSearchHistory();
                                    },
                                    child: GestureDetector(
                                      onTap: () => _clearSerchKeyword(),
                                      child: Text(
                                        'Hapus',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MediaQuery.removePadding(
                              removeTop: true,
                              removeBottom: false,
                              removeLeft: false,
                              removeRight: false,
                              context: context,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.searches.length,
                                itemBuilder: (context, index) {
                                  var data = state.searches[index];
                                  return ListTile(
                                    onTap: () {
                                      _navigateToProductPage(data.keyword);
                                    },
                                    dense: true,
                                    trailing: Icon(
                                      Icons.history,
                                      size: 20,
                                    ),
                                    title: Text(
                                      '${data.keyword}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.grey[800],
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        )
                      : SizedBox.shrink();
                }

                return SizedBox.shrink();
              },
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<PopularSearchCubit, PopularSearchState>(
              builder: (context, state) {
                if (state is PopularSearchLoading) {
                  return MediaQuery.removePadding(
                    removeTop: true,
                    removeBottom: false,
                    removeLeft: false,
                    removeRight: false,
                    context: context,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              boxRadiusShimmer(
                                width: double.infinity,
                                height: 15,
                                radius: 6,
                              ),
                              SizedBox(height: 10),
                              boxRadiusShimmer(
                                width: 150,
                                height: 15,
                                radius: 6,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                if (state is PopularSearchComplete) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: Text(
                          'Pencarian Populer',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      MediaQuery.removePadding(
                        removeTop: true,
                        removeBottom: false,
                        removeLeft: false,
                        removeRight: false,
                        context: context,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.searchs.length,
                          itemBuilder: (context, index) {
                            var data = state.searchs[index];
                            return ListTile(
                              onTap: () {
                                _navigateToProductPage(data.keyword);
                              },
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
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
