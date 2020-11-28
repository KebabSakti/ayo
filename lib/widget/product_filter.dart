import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/widget/filter_sort_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductFilter extends StatefulWidget {
  final ScrollController scrollController;
  final double position;

  ProductFilter({@required this.scrollController, @required this.position});

  @override
  _ProductFilterState createState() => _ProductFilterState();
}

class _ProductFilterState extends State<ProductFilter> {
  QueryCubit _queryCubit;
  bool show = false;

  void _scrollListener() {
    setState(() {
      show = widget.scrollController.position.pixels > widget.position ? true : false;
    });
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);
    _queryCubit = context.bloc<QueryCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 56),
              // padding: EdgeInsets.only(left: 10, right: 10),
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200],
                  ),
                  top: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
                color: Colors.white,
              ),
              child: BlocProvider.value(
                value: _queryCubit,
                child: FilterSortBar(),
              ),
            ),
          )
        : SizedBox.shrink();
  }
}
