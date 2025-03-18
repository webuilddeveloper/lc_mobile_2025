// ignore_for_file: unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../splash.dart';

dialogFail(
  BuildContext context, {
  bool reloadApp = false,
  String title = 'การเชื่อมต่อมีปัญหากรุณาลองใหม่อีกครั้ง',
  Color background = Colors.white,
}) {
  return WillPopScope(
    onWillPop: () {
      return Future.value(reloadApp);
    },
    child: Container(
      height: double.infinity,
      width: double.infinity,
      color: background,
      child: CupertinoAlertDialog(
        title: new Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: const Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
              "ตกลง",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFFA9151D),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              reloadApp
                  ? Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => SplashPage(),
                      ),
                      (Route<dynamic> route) => false,
                    )
                  : Navigator.pop(context, false);
            },
          ),
        ],
      ),
    ),
  );
}
