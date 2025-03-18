// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lc/shared/api_provider.dart';

dialog(BuildContext context,
    {String? title,
    String? description,
    bool? isYesNo = false,
    String? btnOk = 'ตกลง',
    String? btnCancel = 'ยกเลิก',
    Function? callBack}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title!,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            description!,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            Container(
              color: Color(0xFFFF7514),
              child: CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  btnOk!,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  if (isYesNo!) {
                    Navigator.pop(context, false);
                    callBack!(isYesNo);
                  } else {
                    Navigator.pop(context, false);
                  }
                },
              ),
            ),
            if (isYesNo!)
              Container(
                color: Color(0xFF707070),
                child: CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    btnCancel!,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
              ),
          ],
        );
      });
}

dialogVersion(BuildContext context,
    {required String title,
    required String description,
    bool isYesNo = false,
    Function? callBack}) {
  return CupertinoAlertDialog(
    title: Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'Kanit',
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    ),
    content: Column(
      children: [
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'เวอร์ชั่นปัจจุบัน $versionName',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
    actions: [
      Container(
        color: Color(0xFFFF7514),
        child: CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(
            "อัพเดท",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.normal,
            ),
          ),
          onPressed: () {
            if (isYesNo) {
              callBack!(true);
              // Navigator.pop(context, false);
            } else {
              callBack!(true);
              // Navigator.pop(context, false);
            }
          },
        ),
      ),
      if (isYesNo)
        Container(
          color: Color(0xFF707070),
          child: CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              "ภายหลัง",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              callBack!(false);
              Navigator.pop(context, false);
            },
          ),
        ),
    ],
  );
}
