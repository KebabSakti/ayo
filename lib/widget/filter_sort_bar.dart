import 'package:ayo/model/query/query.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FilterSortBar extends StatefulWidget {
  final ValueSetter<QueryModel> filterCallback;

  FilterSortBar({@required this.filterCallback});

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
                await Navigator.of(context).pushNamed('/filter_page');
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
                await Navigator.of(context).pushNamed('/sorting_page');
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
