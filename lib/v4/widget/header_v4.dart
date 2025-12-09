import 'package:flutter/material.dart';

headerV4(BuildContext context, Function functionGoBack,
    {String title = '',
    bool isShowLogo = true,
    bool isCenter = false,
    bool isShowButtonCalendar = false,
    bool isButtonCalendar = false,
    bool isShowButtonPoi = false,
    bool isButtonPoi = false,
    Function? callBackClickButtonCalendar,
    bool isButtonRight = false,
    bool isButtonBack = true,
    Function? rightButton,
    String menu = ''}) {
  return AppBar(
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.35),
    surfaceTintColor: Colors.transparent, // ปิดการทับสีเพื่อให้เงาชัด
    backgroundColor: Colors.white,
    bottomOpacity: 10,
    automaticallyImplyLeading: false,
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
    leading: isButtonBack
        ? GestureDetector(
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
          )
        : Container(),
    // backgroundColor: Color(0xFF9A1120),
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'Kanit',
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
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

headerV4Notification(BuildContext context, Function functionGoBack,
    {String title = '',
    bool isButtonRight = false,
    Function? rightButton,
    String menu = '',
    int? notiCount}) {
  return AppBar(
    centerTitle: true,
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.35),
    surfaceTintColor: Colors.transparent, // ปิดการทับสีเพื่อให้เงาชัด
    backgroundColor: Colors.white,
    bottomOpacity: 10,
    automaticallyImplyLeading: false,
    title: Text(
      '${title} (${notiCount})',
      textAlign: TextAlign.left,
      style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kanit',
          color: Colors.black),
    ),
    // leading: InkWell(
    //   onTap: () => functionGoBack(),
    //   child: Container(
    //     child: Image.asset(
    //       "assets/images/arrow_left.png",
    //       color: Color(0xFF2D9CED),
    //       width: 20,
    //       height: 20,
    //     ),
    //   ),
    // ),
    actions: <Widget>[
      isButtonRight == true
          ? menu == 'notification'
              ? Container(
                  child: Container(
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      margin: const EdgeInsets.only(
                          top: 6.0, right: 10.0, bottom: 6.0),
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => rightButton!(),
                        child: Image.asset(
                          'assets/noti_list.png',
                          color: const Color(0xFF2D9CED),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  child: Container(
                    child: Container(
                      width: 24.0,
                      height: 24.0,
                      margin: const EdgeInsets.only(
                          top: 6.0, right: 10.0, bottom: 6.0),
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => rightButton!(),
                        child: Image.asset('assets/logo/icons/Group344.png'),
                      ),
                    ),
                  ),
                )
          : Container(),
    ],
  );
}

headerV4Calendar(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isShowLogo = true,
  bool isCenter = false,
  bool isShowButtonCalendar = false,
  bool isButtonCalendar = false,
  bool isShowButtonPoi = false,
  bool isButtonPoi = false,
  bool isButtonBack = true,
  Function? callBackClickButtonCalendar,
  bool? isButtonRight,
  Future<void> Function()? rightButton,
  String? menu,
  Color? color,
}) {
  return AppBar(
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.35),
    surfaceTintColor: Colors.transparent, // ปิดการทับสีเพื่อให้เงาชัด
    backgroundColor: Colors.white,
    bottomOpacity: 10,
    automaticallyImplyLeading: false,

    leading: isButtonBack
        ? GestureDetector(
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
          )
        : Container(),
    // backgroundColor: Color(0xFF9A1120),
    centerTitle: isCenter,
    title: isCenter
        ? Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
              color: color,
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

headerV4Cremation(BuildContext context, Function functionGoBack,
    {String title = '',
    bool isShowLogo = true,
    bool isCenter = true,
    bool isShowButtonCalendar = false,
    bool isButtonCalendar = false,
    bool isShowButtonPoi = false,
    bool isButtonPoi = false,
    bool isButtonBack = true,
    Function? callBackClickButtonCalendar,
    bool? isButtonRight,
    String? menu,
    Color? color,
    List<Widget>? actions}) {
  return AppBar(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.35),
      surfaceTintColor: Colors.transparent, // ปิดการทับสีเพื่อให้เงาชัด
      backgroundColor: Colors.white,
      bottomOpacity: 10,
      automaticallyImplyLeading: false,
      leading: isButtonBack
          ? GestureDetector(
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
            )
          : Container(),
      // backgroundColor: Color(0xFF9A1120),
      centerTitle: isCenter,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Kanit',
          color: color,
        ),
      ),
      actions: actions);
}
