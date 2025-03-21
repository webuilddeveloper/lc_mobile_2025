import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lc/v3/menu_v3.dart';

class PollDialogV3 extends StatefulWidget {
  PollDialogV3({
    Key? key,
    required this.titleHome,
    this.userData,
  }) : super(key: key);

  final dynamic userData;
  final String titleHome;

  @override
  _PollDialogV3State createState() => new _PollDialogV3State();
}

class _PollDialogV3State extends State<PollDialogV3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
        title: Text(
          'บันทึกคำตอบเรียบร้อย',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Kanit',
            color: Color(0XFFED6B2D),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "ระบบจะบันทึกคำตอบของท่าน",
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Kanit',
            color: Color(0XFF000000),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: MaterialButton(
              elevation: 0,
              color: Color(0xFFED6B2D),
              height: 40,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(73)),
              onPressed: () {
                goBack();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'ตกลง',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return WillPopScope(
    //   onWillPop: () {
    //     return Future.value(false);
    //   },
    //   child: Container(
    //     height: double.infinity,
    //     width: double.infinity,
    //     color: Colors.white,
    //     child: CupertinoAlertDialog(
    //       title: new Text(
    //         'บันทึกคำตอบเรียบร้อย',
    //         style: TextStyle(
    //           fontSize: 16,
    //           fontFamily: 'Kanit',
    //           color: Colors.black,
    //           fontWeight: FontWeight.normal,
    //         ),
    //       ),
    //       content: Text(" "),
    //       actions: [
    //         CupertinoDialogAction(
    //           isDefaultAction: true,
    //           child: new Text(
    //             "ตกลง",
    //             style: TextStyle(
    //               fontSize: 13,
    //               fontFamily: 'Kanit',
    //               color: Color(0xFFA9151D),
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           onPressed: () {
    //             goBack();
    //           },
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  void goBack() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => MenuV3()),
      (Route<dynamic> route) => false,
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
