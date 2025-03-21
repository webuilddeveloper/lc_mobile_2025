import 'package:flutter/material.dart';

header(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isShowLogo = true,
  bool isCenter = false,
  bool isShowButtonCalendar = false,
  bool isButtonCalendar = false,
  bool isShowButtonPoi = false,
  bool isButtonPoi = false,
  Function? callBackClickButtonCalendar,
  bool? isButtonRight,
  Future<void> Function()? rightButton,
  String? menu,
}) {
  return AppBar(
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Color(0xFF011895),
            Color(0xFF011895),
          ],
        ),
      ),
    ),
    leading: InkWell(
      onTap: () => functionGoBack(),
      child: Image.asset(
        "assets/images/back_arrow.png",
        color: Colors.white,
        width: 40,
        height: 40,
      ),
    ),
    // backgroundColor: Color(0xFF9A1120),
    centerTitle: isCenter,
    title: isCenter
        ? Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
            ),
          )
        : Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isShowLogo)
                Image.asset(
                  'assets/logo.png',
                  height: 50,
                ),
              // Image.asset(
              //   'assets/logo/logo.png',
              //   height: 50,
              // ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Kanit',
                  ),
                ),
              )
            ],
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
    ],
  );
}
