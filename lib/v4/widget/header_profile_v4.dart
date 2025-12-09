import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lc/component/material/check_avatar.dart';
import 'package:lc/pages/lawyer/lawyer_list.dart';
import 'package:lc/pages/notification/notification_listV2.dart';
import 'package:lc/pages/search_lawyer/search_lawyer_list.dart';
import 'package:badges/badges.dart' as badges;
import 'package:lc/v4/profile/identity_verification_v4.dart';
import 'package:lc/v4/profile/user_information_v4.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../shared/api_provider.dart';
// import 'package:badges/badges.dart';

headerProfileV4(BuildContext context,
    {String title = '',
    dynamic userData,
    dynamic lcCategory,
    dynamic idcard,
    int? totalnorti,
    VoidCallback? callback,
    Future<dynamic>? futureProfile,
    String profileCode = ''}) {
  double heightCalculate = ((MediaQuery.of(context).size.width *
              MediaQuery.of(context).size.height) /
          MediaQuery.of(context).size.height) -
      MediaQuery.of(context).size.width;
  dynamic modelProfile;
  futureProfile!.then((x) => {modelProfile = x});
  return AppBar(
    centerTitle: false,
    backgroundColor: Colors.transparent,
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
    toolbarHeight: heightCalculate + 120,
    automaticallyImplyLeading: false,
    title: Container(
      // height: 180,
      // color: Colors.white,
      // padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      margin: const EdgeInsets.all(1.0),
                      child: checkAvatar(
                        context,
                        userData?.imageUrl?.toString() ?? '',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      // left: 0,
                      child: Image.asset(
                        'assets/profile_symbol.png',
                        fit: BoxFit.contain,
                        height: 18,
                        width: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    // width: 65,
                    // height: 65,
                    margin: const EdgeInsets.all(1.0),
      
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            // 'สภาทนายความ',
                            '${userData?.firstName ?? 'สภาทนายความ'} ${userData?.lastName ?? ''}',
                            // userData?.imageUrl?.toString() ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Colors.white,
                              overflow: TextOverflow.fade,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          child: const Text(
                            'ทนายความ',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              lcCategory != '1'
                  ? {
                      _dialogQR(context, modelProfile['com_no'])
                      // postTrackClick("บริการอื่นๆหน้าแรก"),
                      // _readCheckIn(),
                      // buildModalVolunteeLawyer(
                      //   context,
                      //   _futureProfile,
                      //   'กรุณาเลือกบริการ',
                      //   hasCheckIn,
                      //   hasCheckOut,
                      //   'MenuV2',
                      // )
                    }
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserInformationPageV4(lcCategory: lcCategory),
                      ),
                    );
            },
            child: Container(
              width: 76.0,
              height: 80.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                // color: const Color(0xFF2D9CED),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/my_qrcode.png',
                // color: Colors.white,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

_dialogQR(context, code) {
  return showDialog(
    // barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(true);
        },
        child: CupertinoAlertDialog(
          content: Container(
            height: 200,
            color: Colors.white,
            alignment: Alignment.center,
            child: QrImageView(
              data: code,
              version: QrVersions.auto,
              size: 200,
              gapless: false,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: Container(
                width: 250,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFED6B2D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Kanit',
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
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
