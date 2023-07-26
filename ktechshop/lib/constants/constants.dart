import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showMessage(String message) {
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(content: Builder(builder: (context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
          SizedBox(
            height: 18,
          ),
          Container(
            margin: EdgeInsets.only(left: 7),
            child: Text('Loading...'),
          )
        ],
      ),
    );
  }));
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
