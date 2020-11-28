import 'package:ayo/bloc/authentication_cubit.dart';
import 'package:ayo/model/query/filter.dart';
import 'package:ayo/pages/home/bloc/main_category_cubit.dart';
import 'package:ayo/pages/main_category/bloc/sub_category_cubit.dart';
import 'package:ayo/widget/shimmer/box_radius_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  AuthenticationCubit _authenticationCubit;
  MainCategoryCubit _mainCategoryCubit;
  SubCategoryCubit _subCategoryCubit;

  String _categoryId;

  void _fetchMainCategory() {
    _mainCategoryCubit.fetchMainCategory(user: _authenticationCubit.state.userData);
  }

  void _fetchSubCategory() {
    _subCategoryCubit.fetchSubCategories(userData: _authenticationCubit.state.userData, mainCategoryId: _categoryId);
  }

  void _setSubCategory(String categoryId) {
    _categoryId = categoryId;
    _fetchSubCategory();
  }

  @override
  void initState() {
    _authenticationCubit = context.bloc<AuthenticationCubit>();
    _mainCategoryCubit = context.bloc<MainCategoryCubit>();
    _subCategoryCubit = context.bloc<SubCategoryCubit>();

    //init
    _fetchMainCategory();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainCategoryCubit, MainCategoryState>(
      listener: (context, state) {
        if (state is MainCategoryCompleted) {
          _setSubCategory(state.mainCategories[0].categoryId);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Semua Kategori'),
        ),
        body: Row(
          children: [
            Container(
              color: Colors.grey[200],
              width: 80,
              child: BlocBuilder<MainCategoryCubit, MainCategoryState>(
                builder: (context, state) {
                  return MainCategoryWidget(context: context, state: state, setSubCategoryid: _setSubCategory);
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: BlocBuilder<SubCategoryCubit, SubCategoryState>(
                  builder: (context, state) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                      ),
                      itemCount: (state is SubCategoryCompleted) ? state.subCategories.length : 50,
                      itemBuilder: (context, index) {
                        return (state is SubCategoryCompleted)
                            ? Material(
                                child: Ink(
                                  color: Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed('/product',
                                          arguments: Filter(subCategoryId: state.subCategories[index].subCategoryId));
                                    },
                                    splashColor: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.network(
                                            state.subCategories[index].image,
                                            width: 30,
                                            height: 30,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            state.subCategories[index].title,
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : boxRadiusShimmer(radius: 0);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainCategoryWidget extends StatefulWidget {
  final BuildContext context;
  final MainCategoryState state;
  final ValueSetter<String> setSubCategoryid;

  MainCategoryWidget({@required this.context, @required this.state, @required this.setSubCategoryid});

  @override
  _MainCategoryWidgetState createState() => _MainCategoryWidgetState();
}

class _MainCategoryWidgetState extends State<MainCategoryWidget> {
  int _active = 0;

  @override
  Widget build(BuildContext context) {
    var state = widget.state;
    return ListView.builder(
      itemCount: (state is MainCategoryCompleted) ? state.mainCategories.length : 10,
      itemBuilder: (context, index) {
        return (state is MainCategoryCompleted)
            ? Material(
                child: Ink(
                  height: 80,
                  color: (_active == index) ? Colors.white : Colors.grey[200],
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _active = index;
                      });

                      widget.setSubCategoryid(state.mainCategories[index].categoryId);
                    },
                    splashColor: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.network(
                            state.mainCategories[index].image,
                            width: 30,
                            height: 30,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            state.mainCategories[index].title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : boxRadiusShimmer(width: 70, height: 70, radius: 0);
      },
    );
  }
}
