import 'package:flutter/material.dart';

headerV3(BuildContext context, Function functionGoBack,
    {String title = '',
    bool isShowLogo = true,
    bool isCenter = false,
    bool isShowButtonCalendar = false,
    bool isButtonCalendar = false,
    bool isShowButtonPoi = false,
    bool isButtonPoi = false,
    Function? callBackClickButtonCalendar,
    bool isButtonRight = false,
    Function? rightButton,
    String menu = ''}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0.0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(color: Colors.white
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   colors: <Color>[
          //     Color(0xFF011895),
          //     Color(0xFF011895),
          //   ],
          // ),
          ),
    ),
    leading: InkWell(
      onTap: () => functionGoBack(),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Container(
          padding: const EdgeInsets.all(6.0),
          // height: height * 7 / 100, // Your Height
          // width: width * 12 / 100, // Your width
          decoration: BoxDecoration(
              color: const Color(0xFF8AD2FF).withOpacity(.25),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: Image.asset(
            "assets/images/back_arrow.png",
            color: const Color(0xFF2D9CED),
            width: 30,
            height: 30,
          ),
        ),
      ),
    ),
    // backgroundColor: Color(0xFF9A1120),
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(fontFamily: 'Kanit', color: Colors.black),
    ),

    actions: [
      if (isShowButtonCalendar)
        InkWell(
          onTap: () {
            callBackClickButtonCalendar!();
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.only(right: 10, top: 12, bottom: 12),
            width: 70,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: isButtonCalendar
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list,
                        color: Color(0xFF2D9CED),
                        size: 15,
                      ),
                      Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF2D9CED),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icon_header_calendar_1.png',
                        color: const Color(0xFF2D9CED),
                      ),
                      const Text(
                        'ปฏิทิน',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF2D9CED),
                        ),
                      ),
                      // widgetText(
                      //     title: 'ปฏิทิน', fontSize: 9, color: 0xFF1B6CA8),
                    ],
                  ),
          ),
        ),
      if (isShowButtonPoi)
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(right: 10.0),
          margin: const EdgeInsets.only(right: 10, top: 12, bottom: 12),
          width: 70,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: InkWell(
            onTap: () {
              callBackClickButtonCalendar!();
            },
            child: isButtonPoi
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list,
                        color: Color(0xFF2D9CED),
                        size: 15,
                      ),
                      Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF2D9CED),
                        ),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF2D9CED),
                        size: 20,
                      ),
                      // Image.asset('assets/icon_header_calendar_1.png'),
                      Text(
                        'แผนที่',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF2D9CED),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      if (isButtonRight)
        menu == 'notification'
            ? Container(
                width: 42.0,
                height: 42.0,
                margin:
                    const EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => rightButton!(),
                  child: Image.asset(
                    'assets/images/task_list.png',
                    color: const Color(0xFF2D9CED),
                  ),
                ),
              )
            : Container(
                width: 42.0,
                height: 42.0,
                margin:
                    const EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => rightButton!(),
                  child: Image.asset(
                    'assets/logo/icons/Group344.png',
                    color: const Color(0xFF2D9CED),
                  ),
                ),
              )
    ],
  );
}
