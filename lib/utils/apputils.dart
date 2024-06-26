import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:instagram_clone/theme/app_theme.dart';

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: Colors.blueGrey.shade800.withOpacity(0.8),
      fontSize: 16.0);
}

showLoaderDialog(BuildContext context) {
  final appTheme = AppTheme.of(context);
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor:
            appTheme!.theme.isDark ? Colors.grey.shade800 : Colors.white,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CircularProgressIndicator(
              color: Colors.blue.shade600,
            ),
            Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  "Loading...",
                  style: TextStyle(
                      fontSize: 16, color: appTheme.theme.primaryTextColor),
                )),
          ],
        ),
      );
    },
  );
}
