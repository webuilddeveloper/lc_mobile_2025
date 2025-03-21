import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:lc/pages/notification/notification_listV2.dart';
import 'package:lc/pages/search_lawyer/search_lawyer_list.dart';
// import 'package:badges/badges.dart';
import 'package:lc/shared/api_provider.dart';

headerV2(
  BuildContext context,
  void Function() goBack, {
  String title = '',
  dynamic userData,
  dynamic lcCategory,
  dynamic idcard,
  int? totalnorti,
  Function? callback,
}) {
  return AppBar(
    centerTitle: false,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        color: Color(0XFFE8F6F8),
        // gradient: LinearGradient(
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        //   colors: <Color>[
        //     Color(0XFFE8F6F8),
        //     Color(0xFF1B6CA8),
        //   ],
        // ),
      ),
    ),
    backgroundColor: const Color(0xFF1B6CA8),
    elevation: 0.0,
    titleSpacing: 15,
    automaticallyImplyLeading: false,
    title: SizedBox(
      // color: Colors.red,
      height: 40,
      // margin: EdgeInsets.only(top: 7),
      // child: KeySearch(),
      child: InkWell(
        onTap: () {
          postTrackClick("ตรวจสอบรายชื่อทนายความ");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchLawyerList(
                keySearch: '$idcard',
                lcCategory: lcCategory,
              ),
            ),
          );
        },
        child: Container(
          // height: 30,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: const Color(0XFF359EEA),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // _buildCurrentLocationBar(),
              const Text(
                'ตรวจสอบรายชื่อทนายความ',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 13,
                  color: Color(0xFF707070),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: const Color(0xFF2D9CED),
                ),
                // margin: EdgeInsets.only(left: 40),
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/search.png',
                  color: Colors.white,
                ),
              ),
              // Container(
              //   width: 25,
              //   color: Colors.transparent,
              //   child: Image.asset(
              //     'assets/images/search.png',
              //     height: 18.0,
              //     width: 18.0,
              //     color: Color(0xFF216DA6),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ),
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 6.0, right: 15.0, bottom: 6.0),
        child: badges.Badge(
          badgeStyle: const badges.BadgeStyle(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            badgeColor: Colors.red, // กำหนดสีของ badge
          ),
          showBadge: (totalnorti ?? 0) > 0,
          badgeContent: Text(
            totalnorti.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: InkWell(
            onTap: () {
              postTrackClick("แจ้งเตือน");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationListV2(
                    title: 'แจ้งเตือน',
                  ),
                ),
              ).then((value) => callback!());
            },
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFF2D9CED),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/logo/icons/Group103.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

headerV2Notification(BuildContext context, Function functionGoBack,
    {String title = '',
    bool isButtonRight = false,
    Function? rightButton,
    String menu = '',
    int? notiCount}) {
  return AppBar(
    centerTitle: false,
    flexibleSpace: Container(),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleSpacing: 5,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        InkWell(
          onTap: () => functionGoBack(),
          child: Container(
            child: Image.asset(
              "assets/images/arrow_left.png",
              color: const Color(0xFF2D9CED),
              width: 35,
              height: 50,
            ),
          ),
        ),
        // SizedBox(width: 15),
        Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
              color: Color(0xFF707070)),
        ),
        const SizedBox(width: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.red,
          ),
          height: 30,
          width: 30,
          child: Text(
            notiCount.toString(),
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                color: Colors.white),
          ),
        ),
      ],
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

headerNSA(
  BuildContext context, {
  String title = '',
  Function? callback,
  Color backgroundColor = const Color(0xFFFFFFFF),
  bool isBgColor = true,
  Widget? contentRight,
}) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: isBgColor ? backgroundColor : const Color(0xFFff7f7f7),
    flexibleSpace: Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 15,
        right: 15,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => callback!(),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDCF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF758C29),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          contentRight!
        ],
      ),
    ),
  );
}

headerNSAV2(
  BuildContext context, {
  String title = '',
  Function? callback,
}) {
  return AppBar(
    elevation: 0,
    automaticallyImplyLeading: false,
    backgroundColor: const Color(0xFFF7F7F7),
    flexibleSpace: Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 15,
        right: 15,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => callback!(),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDCF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF758C29),
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 30),
        ],
      ),
    ),
  );
}
