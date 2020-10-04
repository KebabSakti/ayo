import 'package:flutter/material.dart';

class FilterItem extends StatefulWidget {
  final IconData icon;
  final String title;

  FilterItem({@required this.icon, @required this.title});

  @override
  _FilterItemState createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  bool active = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {
            active = !active;
          });
        },
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: (active) ? Theme.of(context).primaryColor : Colors.grey,
              ),
              SizedBox(height: 4),
              Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color:
                      (active) ? Theme.of(context).primaryColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
