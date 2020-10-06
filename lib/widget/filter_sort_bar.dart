import 'package:ayo/pages/app/bloc/query_cubit.dart';
import 'package:ayo/pages/filter/filter_page.dart';
import 'package:ayo/pages/sorting/sorting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FilterSortBar extends StatefulWidget {
  final QueryCubit queryCubit;

  FilterSortBar({@required this.queryCubit});

  @override
  _FilterSortBarState createState() => _FilterSortBarState();
}

class _FilterSortBarState extends State<FilterSortBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () async {
                showMaterialModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  duration: Duration(milliseconds: 200),
                  builder: (context, scrollController) => BlocProvider.value(
                      value: widget.queryCubit, child: FilterPage()),
                );
              },
              child: Ink(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.filter_list,
                        color: Colors.grey[600],
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(width: 1, color: Colors.grey[100]),
        Flexible(
          flex: 1,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () async {
                showMaterialModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  duration: Duration(milliseconds: 200),
                  builder: (context, scrollController) => BlocProvider.value(
                      value: widget.queryCubit, child: SortingPage()),
                );
              },
              splashColor: Theme.of(context).accentColor.withOpacity(0.3),
              child: Ink(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        FontAwesomeIcons.sort,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      Text(
                        'Sorting',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
