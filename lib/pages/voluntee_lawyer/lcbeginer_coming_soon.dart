import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/component/button_close_back.dart';
import 'package:lc/component/content_with_out_share.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:flutter/material.dart';

class LCBeginerComingSoon extends StatefulWidget {
  const LCBeginerComingSoon({Key? key, this.code = 'image', required this.title})
      : super(key: key);

  final String code;
  final String title;
  @override
  _LCBeginerComingSoon createState() => _LCBeginerComingSoon();
}

class _LCBeginerComingSoon extends State<LCBeginerComingSoon> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
          // appBar: header(context, _goBack, title: widget.title),
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Container(
                child: Image.asset(
                  'assets/lcbeginer.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
              Container(
                color: Colors.transparent,
                width: 150,
                height: 150,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )),
    );
  }
}
