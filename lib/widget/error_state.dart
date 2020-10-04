import 'package:flutter/material.dart';

class ErrorState extends StatefulWidget {
  final VoidCallback retryFunction;
  final String errorMessage;

  ErrorState({@required this.retryFunction, this.errorMessage});

  @override
  _ErrorStateState createState() => _ErrorStateState();
}

class _ErrorStateState extends State<ErrorState> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.cloud_off,
          color: Colors.red,
          size: 40,
        ),
        Text(
          widget.errorMessage ?? 'Terjadi kesalahan',
          style: TextStyle(fontSize: 10),
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Colors.grey[600],
          ),
          onPressed: () {
            widget.retryFunction();
          },
        ),
      ],
    );
  }
}
