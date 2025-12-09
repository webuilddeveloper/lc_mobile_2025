import 'package:lc/component/header.dart';
import 'package:lc/pages/event_calendar/calendar.dart';
import 'package:lc/pages/event_calendar/event_calendar_list.dart';
import 'package:flutter/material.dart';
import 'package:lc/v4/widget/header_v4.dart';
import 'package:lc/widget/header.dart';

class EventCalendarMainV4 extends StatefulWidget {
  EventCalendarMainV4({Key? key, required this.title, this.isBack}) : super(key: key);
  final String title;
  bool? isBack;
  @override
  _EventCalendarMainV4 createState() => _EventCalendarMainV4();
}

class _EventCalendarMainV4 extends State<EventCalendarMainV4> {
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
        appBar: headerV4Calendar(
          context,
          () => {Navigator.pop(context)},
          // goBack,
          isShowLogo: false,
          isCenter: true,
          isShowButtonCalendar: false,
          isButtonBack: widget.isBack!,
          isButtonCalendar: false,
          isShowButtonPoi: false,
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
          child: CalendarPage()
          // showCalendar
          //     ? CalendarPage()
          //     : EventCalendarList(title: widget.title),
        ),
      ),
    );
  }
}
