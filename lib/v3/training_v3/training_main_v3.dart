import 'package:flutter/material.dart';
// import 'package:lc/pages/training/training_list.dart';
import 'package:lc/pages/training/training.dart';
import 'package:lc/v3/training_v3/training_list_v3.dart';
// import 'package:lc/widget/header.dart';

import '../widget/header_v3.dart';

class TrainingMainV3 extends StatefulWidget {
  const TrainingMainV3(
      {super.key, required this.title, this.isCategory = false});
  final String title;
  final bool isCategory;
  @override
  _TrainingMainV3 createState() => _TrainingMainV3();
}

class _TrainingMainV3 extends State<TrainingMainV3> {
  bool showCalendar = true;
  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  void changeTab() async {
    // Navigator.pop(context, false);
    setState(() {
      showCalendar = !showCalendar;
    });
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
        backgroundColor: Colors.white,
        // appBar: headerCalendar(
        //   context,
        //   goBack,
        //   showCalendar,
        //   title: widget.title,
        //   rightButton: () => changeTab(),
        // ),
        appBar: headerV3(
          context,
          goBack,
          title: widget.title,
          isShowButtonCalendar: true,
          isButtonCalendar: showCalendar,
          callBackClickButtonCalendar: () => setState(
            () {
              showCalendar = !showCalendar;
            },
          ),
        ),
        // header(
        //   context,
        //   () => {Navigator.pop(context)},
        //   // goBack,
        //   isShowLogo: false,
        //   isCenter: true,
        //   isShowButtonCalendar: true,
        //   isButtonCalendar: showCalendar,
        //   title: widget.title,
        //   callBackClickButtonCalendar: () => setState(
        //     () {
        //       showCalendar = !showCalendar;
        //     },
        //   ),
        //   // rightButton: () => changeTab(),
        // ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: showCalendar
              ? TrainingPage(title: widget.title, isCategory: widget.isCategory)
              : TrainingListV3(
                  title: widget.title, isCategory: widget.isCategory),
        ),
      ),
    );
  }
}
