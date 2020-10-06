import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog myProgressDialog(BuildContext context) {
  ProgressDialog progress = ProgressDialog(context, isDismissible: false);
  progress.style(
      message: 'Loading',
      messageTextStyle: TextStyle(
        color: Colors.grey[800],
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      progressWidget: Container(
        padding: EdgeInsets.all(15),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.grey[100],
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      ));

  return progress;
}
