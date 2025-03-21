import 'package:flutter/material.dart';
import 'package:lc/pages/training/training_list.dart';
import 'package:lc/pages/training/training.dart';

import '../../component/header.dart';

class TrainingMain extends StatefulWidget {
  const TrainingMain({super.key, required this.title, this.isCategory = false});
  final String title;
  final bool isCategory;
  @override
  // ignore: library_private_types_in_public_api
  _TrainingMain createState() => _TrainingMain();
}

class _TrainingMain extends State<TrainingMain> {
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
        appBar: header(
          context,
          () => {Navigator.pop(context)},
          // goBack,
          isShowLogo: false,
          isCenter: true,
          isShowButtonCalendar: true,
          isButtonCalendar: showCalendar,
          title: widget.title,
          callBackClickButtonCalendar: () => setState(
            () {
              showCalendar = !showCalendar;
            },
          ),
          // rightButton: () => changeTab(),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: showCalendar
              ? TrainingPage(title: widget.title, isCategory: widget.isCategory)
              : TrainingList(
                  title: widget.title, isCategory: widget.isCategory),
        ),
      ),
    );
  }
}
