import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ScrollController scrollController;
  final String hint;

  const SearchBar({Key key, @required this.scrollController, this.hint}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Color _searchBarColor = Colors.white;

  void _changeIconColor(double value) {
    setState(() {
      if (value > 120.0) {
        _searchBarColor = Colors.grey[100];
      } else {
        _searchBarColor = Colors.white;
      }
    });
  }

  void _scrollListener() {
    _changeIconColor(widget.scrollController.offset);
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          SizedBox(width: 5),
          Container(
            child: Text(
              widget.hint ?? 'Cari di sini',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
          )
        ],
      ),
    );
  }
}
