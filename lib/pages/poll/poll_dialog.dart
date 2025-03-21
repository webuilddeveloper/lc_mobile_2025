import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../menu_v2.dart';

class PollDialog extends StatefulWidget {
  const PollDialog({
    super.key,
    this.titleHome,
    this.userData,
  });

  final dynamic userData;
  final String? titleHome;

  @override
  // ignore: library_private_types_in_public_api
  _PollDialogState createState() => _PollDialogState();
}

class _PollDialogState extends State<PollDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: CupertinoAlertDialog(
          title: const Text(
            'บันทึกคำตอบเรียบร้อย',
            style: TextStyle(
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
                goBack();
              },
            ),
          ],
        ),
      ),
    );
  }

  void goBack() async {
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(builder: (context) => MenuV2()),
    //   (Route<dynamic> route) => false,
    // );
  }
}
