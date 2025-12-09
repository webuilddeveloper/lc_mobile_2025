import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lc/component/material/check_avatar.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v4/event_calendar_v4/event_calendar_main_v4.dart';
import 'package:lc/v4/home_v4.dart';
import 'package:lc/v4/notification/notification_listV4.dart';
import 'package:lc/v4/profile/user_information_v4.dart';

class MenuV4 extends StatefulWidget {
  const MenuV4({Key? key, this.pageIndex, this.modelprofile}) : super(key: key);

  final int? pageIndex;
  final modelprofile;

  @override
  State<MenuV4> createState() => _MenuV4State();
}

class _MenuV4State extends State<MenuV4> {
  final storage = new FlutterSecureStorage();
  late Future<dynamic> _futureProfile = Future.value(null);
  int _currentPage = 0;
  var profileCode;
  dynamic modelProfile;
  String imageUrl = '';
  List<Widget> pages = <Widget>[];
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    pages = <Widget>[
      HomeV4(),
      // EventCalendarPageV4(title: 'ปฏิทินกิจกรรม'),
      EventCalendarMainV4(title: 'ปฏิทินกิจกรรม', isBack: false,),
      NotificationListV4(
        title: 'แจ้งเตือน',
      ),
      UserInformationPageV4()
      // Profile(model: modelProfile),
      // Profile(model: modelProfile)
    ];
    setState(() {
      _currentPage = widget.pageIndex ?? 0;
    });
  }

  Future<void> _loadUserProfile() async {
    final storage = FlutterSecureStorage();
    var value = await storage.read(key: 'dataUserLoginLC');
    var data = json.decode(value!);

    if (value != null) {

      setState(() {
        modelProfile = data;
        imageUrl = data['imageUrl'];
        // _futureProfile = postDio(profileReadApi, {"code": data['code']});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      drawerScrimColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: confirmExit,
          child: IndexedStack(index: _currentPage, children: pages),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(29), topRight: Radius.circular(29)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.15),
              blurRadius: 15,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20), // ระยะลอยจากขอบ
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomItem(Icons.home, 0, title: 'หน้าแรก'),
              _bottomItem(Icons.calendar_month, 1, title: 'ปฏิทินกิจกรรม'),
              _bottomItem(Icons.notifications, 2, title: 'แจ้งเตือน'),
              _bottomItem(
                Icons.person,
                3,
                isImageUrl: true,
                title: 'โปรไฟล์',
              ),
            ],
          ),
        ),
        //   ),
        // ),
      ),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'กดอีกครั้งเพื่อออก',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _bottomItem(
    IconData icon,
    int index, {
    bool isImageUrl = false,
    required String title,
  }) {
    final isSelected = _currentPage == index;
    return GestureDetector(
      onTap: () {
        if (index == 2) {
          postTrackClick("แจ้งเตือน");
        }
        setState(() {
          _currentPage = index;
        });
        _loadUserProfile();
      },
      // borderRadius: BorderRadius.circular(50),
      child:
          // AnimatedContainer(
          //   duration: Duration(milliseconds: 500),
          //   curve: Curves.linearToEaseOut,
          //   // padding: EdgeInsets.all(12),
          Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          // color:
          //     isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(45),
          // boxShadow: [
          //   BoxShadow(
          //     color:
          //         isSelected
          //             ? Colors.black.withOpacity(0.2)
          //             : Colors.transparent,
          //     blurRadius: 20,
          //     offset: Offset(0, 10),
          //   ),
          // ],
          // shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isImageUrl
                ? Container(
                    // padding: EdgeInsets.all('${imageUrl}' != '' ? 0.0 : 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      // color: const Color(0xFFFF7900),
                    ),
                    alignment: Alignment.center,
                    height: 30,
                    width: 30,
                    child: imageUrl != ''
                        ? checkAvatar(context, '${imageUrl}')
                        : Icon(
                            icon,
                            size: 30,
                            color: isSelected
                                ? Color(0xFF011895)
                                : Color(0xFF877573),
                          ),
                  )
                : Icon(
                    icon,
                    size: 30,
                    color: isSelected ? Color(0xFF011895) : Color(0xFF877573),
                  ),
            Text(title,
                style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Color(0xFF011895) : Color(0xFF877573))),
          ],
        ),
      ),
    );
    //   ),
    // );
  }
}
