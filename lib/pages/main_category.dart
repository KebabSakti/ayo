import 'package:ayo/widget/ayo_appbar.dart';
import 'package:flutter/material.dart';

class MainCategory extends StatelessWidget {
  final String categoryId;

  MainCategory({@required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return MainCategoryApp(categoryId: categoryId);
  }
}

class MainCategoryApp extends StatefulWidget {
  final String categoryId;

  MainCategoryApp({@required this.categoryId});

  @override
  _MainCategoryAppState createState() => _MainCategoryAppState();
}

class _MainCategoryAppState extends State<MainCategoryApp> {
  final ScrollController _scrollController = ScrollController();

  void _scrollListener() {
    //
  }

  Future _refreshData() async {
    //
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                AyoAppBar(
                  scrollController: _scrollController,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
