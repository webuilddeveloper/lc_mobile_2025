import 'package:flutter/material.dart';
import 'package:lc/pages/notification/notification_listV2.dart';
import 'package:lc/pages/search_lawyer/search_lawyer_list.dart';
import 'package:badges/badges.dart' as badges;
import '../../shared/api_provider.dart';
// import 'package:badges/badges.dart';

headerProfileV3(
  BuildContext context, {
  String title = '',
  dynamic userData,
  dynamic lcCategory,
  dynamic idcard,
  int? totalnorti,
  VoidCallback? callback,
}) {
  double heightCalculate = ((MediaQuery.of(context).size.width *
              MediaQuery.of(context).size.height) /
          MediaQuery.of(context).size.height) -
      MediaQuery.of(context).size.width;
  return AppBar(
    centerTitle: false,
    backgroundColor: Colors.white,
    // flexibleSpace: Container(
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     // gradient: LinearGradient(
    //     //   begin: Alignment.centerLeft,
    //     //   end: Alignment.centerRight,
    //     //   colors: <Color>[
    //     //     Color(0XFFE8F6F8),
    //     //     Color(0xFF1B6CA8),
    //     //   ],
    //     // ),
    //   ),
    // ),
    // backgroundColor: Color(0xFF1B6CA8),
    elevation: 0.0,
    // titleSpacing: 45,
    // leadingWidth: 160,
    toolbarHeight: heightCalculate + 150,
    automaticallyImplyLeading: false,
    title: Container(
      // height: 180,
      color: Colors.white,
      // padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        margin: const EdgeInsets.all(1.0),
                        child: Image.asset(
                          "assets/logo/icons/header_icon_v3.png",
                          // fit: BoxFit.fill,
                          // width: 65,
                          // height: 65,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        // width: 65,
                        // height: 65,
                        margin: const EdgeInsets.all(1.0),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: const Text(
                                'สภาทนายความ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Color(
                                      0xFF011895,
                                    ),
                                    height: 1.3),
                              ),
                            ),
                            Container(
                              child: const Text(
                                'On Mobile',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color(0xFF011895),
                                    height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              Flexible(
                flex: 2,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 6.0, right: 15.0, bottom: 6.0),
                        child: badges.Badge(
                          badgeStyle: const badges.BadgeStyle(
                            padding: EdgeInsets.symmetric(
                                horizontal: 7, vertical: 7),
                            badgeColor: Colors.red, // กำหนดสีของ badge
                          ),
                          showBadge: totalnorti! > 0,
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
                                  builder: (context) =>
                                      const NotificationListV2(
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
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          Container(
            height: 40,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2FAFF),
              borderRadius: BorderRadius.circular(30),

              // border: Border.all(
              //   width: 1,
              //   color: Color(0XFF359EEA),
              // ),
            ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // _buildCurrentLocationBar(),
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17.5),
                      // color: Color(0xFF2D9CED),
                    ),
                    // margin: EdgeInsets.only(left: 40),
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/images/search.png',
                      color: const Color(0xFF2D9CED),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ค้นหาทนายความ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF2D9CED),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
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
          title ?? '',
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
