import 'package:ayo/widget/filter_item.dart';
import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget {
  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: FilterItem(
            icon: Icons.thumb_up,
            title: 'Semua',
          ),
        ),
        Flexible(
          flex: 1,
          child: FilterItem(
            icon: Icons.monetization_on,
            title: 'Diskon',
          ),
        ),
        Flexible(
          flex: 1,
          child: FilterItem(
            icon: Icons.star_half,
            title: 'Rating',
          ),
        ),
        Flexible(
          flex: 1,
          child: FilterItem(
            icon: Icons.remove_red_eye,
            title: 'Populer',
          ),
        ),
        Flexible(
          flex: 1,
          child: FilterItem(
            icon: Icons.new_releases,
            title: 'Terbaru',
          ),
        ),
      ],
    );
  }
}
