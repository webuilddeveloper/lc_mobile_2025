import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/component/material/check_avatar.dart';
import 'package:lc/component/teacher/text_row.dart';
import 'package:lc/pages/about_us/about_us_form.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/pages/blank_page/toast_fail.dart';
import 'package:lc/pages/e_service/e_service_list.dart';
import 'package:lc/pages/enfranchise/enfrancise_main.dart';
import 'package:lc/pages/event_calendar/event_calendar_form.dart';
import 'package:lc/pages/knowledge/knowledge_form.dart';
import 'package:lc/pages/knowledge/knowledge_list.dart';
import 'package:lc/pages/lawyer/lawyer_list.dart';
import 'package:lc/pages/main_popup/dialog_main_popup.dart';
import 'package:lc/pages/news/news_form.dart';
import 'package:lc/pages/news/news_list.dart';
import 'package:lc/pages/notarial_services_attorney/nsa_main.dart';
import 'package:lc/pages/notification/notification_expireform.dart';
import 'package:lc/pages/poi/poi_form.dart';
import 'package:lc/pages/policy_v2.dart';
import 'package:lc/pages/poll/poll_form.dart';
import 'package:lc/pages/privilege/privilege_form.dart';
import 'package:lc/pages/privilegeSpecial/privilege_special_coming_soon.dart';
import 'package:lc/pages/profile/user_information_v2.dart';
import 'package:lc/pages/search_other/search_other_list.dart';
import 'package:lc/v3/contact/contact_category.dart';
import 'package:lc/v3/event_calendar/event_calendar.dart';
import 'package:lc/v3/privilege_v3/privilege_main_v3.dart';
import 'package:lc/v4/event_calendar_v4/event_calendar_main_v4.dart';
import 'package:lc/v4/profile/user_information_v4.dart';
import 'package:lc/widget/build_modal.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lc/models/user.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../coming_privilege.dart';
import '../pages/cremation/cremation_main.dart';
import '../pages/notarial_services_attorney/nsa_report_policy.dart';
import '../pages/profile/identity_verification_v2.dart';

class HomeV4 extends StatefulWidget {
  const HomeV4({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeV4 createState() => _HomeV4();
}

class _HomeV4 extends State<HomeV4> with WidgetsBindingObserver {
  bool loadingModel = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _addBadger();
    });
  }

  final storage = const FlutterSecureStorage();
  DateTime? currentBackPressTime = DateTime(0);

  // Profile profile = new Profile(model: Future.value({}));
  // Profile profile;

  Future<dynamic> _futureProfile = Future.value();
  late Future<dynamic> _futureOrganizationImage;
  late Future<dynamic> _futureNews;
  late Future<dynamic> _futureAboutUs;
  late Future<dynamic> _futureEventCalendar;
  late Future<dynamic> _futureMainPopUp;
  late Future<dynamic> _futureKnowledge;
  late Future<dynamic> _futurePrivilege;
  late Future<dynamic> _futurePoi;
  late Future<dynamic> _futureNotification;

  LatLng latLng = const LatLng(0, 0);
  late Future<dynamic> _futureNoti;
  // Future<dynamic> _futureKnowledge;
  // Future<dynamic> _futurePoll;
  // Future<dynamic> _futureFaq;
  // Future<dynamic> _futurePrivilege;

  String currentLocation = '-';
  final seen = <String>{};
  List unique = [];
  List resultImageLv0 = [];
  List imageLv0 = [];
  bool hasCheckIn = false;
  bool hasCheckOut = false;

  String profileCode = "";
  User? userData;
  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;

  String userCode = '';
  late String _imageUrl;
  String ocategory = '';

  dynamic _newsCount;
  dynamic _eventCount;
  dynamic _pollCount;
  dynamic _isNewsCount = false;
  dynamic _isEventCount = false;
  dynamic _isPollCount = false;
  dynamic _isPrivilegeCount = false;
  dynamic lcCategory = false;
  dynamic idcard;
  dynamic _newsPage;
  dynamic _eventPage;
  dynamic _privilegePage;
  dynamic _knowledgePage;
  dynamic _poiPage;
  dynamic _mainPage;
  dynamic _notificationPage;

  int nortiCount = 0;

  int add_badger = 0;

  dynamic profileLawyer;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // late StreamSubscription<Map> _notificationSubscription;
  late final StreamSubscription _notificationSubscription =
      const Stream.empty().listen((event) {});

  List<dynamic> mockBannerList = [];
  int _currentBanner = 1;

  bool? canPop = false;

  @override
  void initState() {
    // canPop = false;
    _callRead();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _notificationSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: headerProfileV4(
      //   context,
      //   title: "สภาทนายความ",
      //   userData: userData,
      //   lcCategory: lcCategory,
      //   idcard: idcard,
      //   totalnorti: nortiCount,
      //   callback: _readNoti,
      //   futureProfile: _futureProfile,
      //   profileCode: profileCode
      // ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white, // เห็นภาพชัด
                    Colors.transparent, // ค่อย ๆ หายไป
                  ],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/background/bg_home.png',
                width: double.infinity,
                fit: BoxFit.contain,
                // height: 200, // ปรับความยาวของ fade ได้
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (value, result) => confirmExit(),
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowIndicator();
                    return false;
                  },
                  child: Column(
                    children: [
                      _buildCardProfile(userData),
                      Expanded(child: _buildBackground()),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  heightCalculate(double height) {
    return (((MediaQuery.of(context).size.width *
                    MediaQuery.of(context).size.height) /
                MediaQuery.of(context).size.height) -
            MediaQuery.of(context).size.width) +
        height;
  }

  _buildBackground() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: _buildNotificationListener(),
    );
  }

  _buildNotificationListener() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowIndicator();
        return false;
      },
      child: _buildSmartRefresher(),
    );
  }

  _buildSmartRefresher() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(
        complete: Container(
          child: const Text(''),
        ),
        completeDuration: const Duration(milliseconds: 0),
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      // onLoading: _onLoading,
      child: FutureBuilder<dynamic>(
        future: _futureProfile,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return _buildListView(model: snapshot.data);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildListView({dynamic model}) {
    return ListView(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 110),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
            ),
            // color: Color(0XFFE8F6F8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ////////////////////////// ///banner/// ///////////////////////////////////////////////
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                // child: Expanded(child: _buildBanner()),
                child: SizedBox(
                  height: heightCalculate(150),
                  child: _buildBanner(),
                ),
              ),
              ////////////////////////// ///banner/// ///////////////////////////////////////////////

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   child: Row(
              //     children: [
              //       Expanded(child: _buildBanner()),
              //     ],
              //   ),
              // ),

              // SizedBox(
              //     height: (((MediaQuery.of(context).size.width *
              //                     MediaQuery.of(context).size.height) /
              //                 MediaQuery.of(context).size.height) -
              //             MediaQuery.of(context).size.width) +
              //         15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: const Text(
                      'บริการ',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildMenuGrid({
                    'code': 'E_SERVICE',
                    'title': 'บริการอิเล็กทรอนิกส์ / ทนายความอาสา',
                    'imageUrl': 'assets/images/menu1.png'
                  }, true),
                ),
                const SizedBox(width: 13),
                Expanded(
                  flex: 1,
                  child: _buildMenuGrid({
                    'code': 'NEWS',
                    'title': 'ข่าวประชาสัมพันธ์',
                    'imageUrl': 'assets/images/menu2.png'
                  }, true),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildMenuGrid({
                    'code': 'KNOWLEDGE',
                    'title': 'สืบค้นฐานข้อมูล',
                    'imageUrl': 'assets/images/menu3.png'
                  }, true),
                ),
                const SizedBox(width: 13),
                Expanded(
                  flex: 2,
                  child: _buildMenuGrid({
                    'code': 'LAWYERS_COUNCIL',
                    'title': 'สารสภาทนายความ',
                    'imageUrl': 'assets/images/menu4.png'
                  }, true),
                )
              ],
            ),
            const SizedBox(height: 13),
            _buildMenuBtm({
              'code': 'EVENT',
              'title': 'ปฏิทินกิจกรรม',
              'imageUrl': 'assets/images/menu_btm_1.png'
            }, true),
            const SizedBox(height: 13),
            cardMenuBtm(
              image: 'assets/images/menu_btm_2.png',
              title: 'ทนายความผู้ทำคำรับรอง\nลายมือชื่อและเอกสาร',
              onTap: () {
                _callReadPolicyNsa();
              },
            ),
            const SizedBox(height: 13),
            _buildMenuBtm({
              'code': 'CREMATION',
              'title': 'ฌาปนกิจ',
              'imageUrl': 'assets/images/menu_btm_3.jpg'
            }, true),
            const SizedBox(height: 13),
            _buildMenuBtm({
              'code': 'CONTACT',
              'title': 'เบอร์ติดต่อ',
              'imageUrl': 'assets/images/menu_btm_4.png'
            }, true),
            const SizedBox(height: 13),
            _buildMenuBtm({
              'code': 'PRIVILEGE',
              'title': 'สิทธิประโยชน์',
              'imageUrl': 'assets/images/menu_btm_5.png'
            }, true),
          ],
        ),
      ],
    );

    // FutureBuilder<dynamic>(
    //   future: _futureMenu, // function where you call your api
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.hasData) {
    //       return

    //     } else if (snapshot.hasError) {
    //       return Container();
    //     } else {
    //       return Container();
    //     }
    //   },
    // );
  }

  cardMenuBtm({
    required VoidCallback onTap,
    required String image,
    required String title,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: Container(
                  width: 182,
                  height: 47,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  decoration: BoxDecoration(
                      color: Color(0xFF011895),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16))),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ))),
        ],
      ),
    );
  }

  _buildProfileRight({dynamic model}) {
    return Container(
      // padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      height: 200,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  model["lcCategory"] != '1'
                      ? {
                          postTrackClick(
                              "ตรวจสอบข้อมูลใบอนุญาตทนายความหน้าแรก"),
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LawyerList(model: _futureProfile),
                            ),
                          )
                        }
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IdentityVerificationV2Page(
                              title: '',
                            ),
                          ),
                        ).then(
                          (value) => _futureProfile =
                              postDio(profileReadApi, {'code': profileCode}),
                        );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xFF2D9CED)),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Container(
                                  width: 35,
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Container(
                                    width: 20,
                                    height: 15.49,
                                    padding: const EdgeInsets.all(1.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF2D9CED),
                                            width: 1,
                                            style: BorderStyle.solid)),
                                    child: Image.asset(
                                      "assets/logo/icons/check_licens.png",
                                      // width: 14.29,
                                      // height: 9.14,
                                    ),
                                  )),
                            ),
                            Container(
                              child: Text(
                                model["lcCategory"] == '1'
                                    ? 'ยืนยันตัวตน'
                                    : 'ตรวจสอบข้อมูลใบอนุญาต\nทนายความ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      model["lcCategory"] == '1' ? 15.0 : 12.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Kanit',
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  model["lcCategory"] != '1'
                      ? {
                          _dialogQR(model['com_no'])
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
                                UserInformationPageV2(lcCategory: lcCategory),
                          ),
                        );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(0xFFF2FAFF)),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Container(
                                  width: 35,
                                  height: 35,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Image.asset(
                                        model["lcCategory"] == '1'
                                            ? "assets/logo/icons/setting_v3.png"
                                            : "assets/logo/icons/qr_code.png"),
                                  )),
                            ),
                            Container(
                              child: Text(
                                model["lcCategory"] == '1'
                                    ? 'ตั้งค่าอื่นๆ'
                                    : 'แสดงใบอนุญาตทนายความ',
                                // บริการอื่นๆ
                                style: TextStyle(
                                  color: const Color(0xFF2D9CED),
                                  fontSize:
                                      model["lcCategory"] == '1' ? 15.0 : 12.0,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Kanit',
                                  // height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ]),
    );
  }

  // ignore: unused_element
  _buildBottomProfile(dynamic model, bool isCategory) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF1B6CA8),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    child: InkWell(
                      onTap: () {
                        postTrackClick("ตรวจสอบข้อมูลใบอนุญาตทนายความหน้าแรก");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                LawyerList(model: _futureProfile),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF011895),
                        radius: 30,
                        child: Image.asset(
                          "assets/logo/icons/Group6697.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          child: const Text(
                            'ตรวจสอบข้อมูล',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                        Container(
                          child: const Text(
                            'ใบอนุญาตทนายความ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    child: InkWell(
                      onTap: () {
                        postTrackClick("บริการอื่นๆหน้าแรก");
                        _readCheckIn();
                        buildModalVolunteeLawyer(
                          context,
                          _futureProfile,
                          'กรุณาเลือกบริการ',
                          hasCheckIn,
                          hasCheckOut,
                          'MenuV2',
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF011895),
                        radius: 30,
                        child: Image.asset(
                          "assets/logo/icons/dotsmenu.png",
                          width: 25,
                          height: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: const Text(
                      'บริการอื่นๆ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
    );
  }

  _buildMenuGrid(
    dynamic model,
    bool isCategory,
  ) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            switch (model['code']) {
              case 'LAWYERS_COUNCIL':
                postTrackClick("สารสภาทนายความหน้าแรก");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KnowledgeList(
                      title: model['title'],
                    ),
                  ),
                );
                break;
              case 'E_SERVICE':
                postTrackClick("บริการอิเล็กทรอนิกส์หน้าแรก");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EserviceList(
                        title: model['title'], isCategory: isCategory),
                  ),
                );
                break;
             
              case 'KNOWLEDGE':
                postTrackClick("สืบค้นฐานข้อมูลต่างๆหน้าแรก");
                storage.write(
                  key: 'isBadgerPoll',
                  value: '0', //_pollCount.toString(),
                );
                setState(() {
                  _isPollCount = false;
                  _addBadger();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchOtherList(
                      title: model['title'],
                      model: _futureProfile,
                    ),
                  ),
                ).then((value) => _callRead());
                break;
              case 'NEWS':
                postTrackClick("ข่าวประชาสัมพันธ์หน้าแรก");
                storage.write(
                  key: 'isBadgerNews', value: '0', //_newsCount.toString(),
                );
                setState(() {
                  _isNewsCount = false;
                  _addBadger();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsList(
                      title: model['title'],
                    ),
                  ),
                ).then((value) => _callRead());
                break;
              case 'CONTACT':
                postTrackClick("เบอร์ติดต่อเร่งด่วนหน้าแรก");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactCategoryPage(
                      title: model['title'],
                    ),
                  ),
                );
                break;
              case 'ABOUT_US':
                postTrackClick("เกี่ยวกับเราหน้าแรก");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutUsForm(
                      model: _futureAboutUs,
                      title: model['title'],
                    ),
                  ),
                );
                break;
              case 'CREMATION':
                postTrackClick("ฌาปนกิจ");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CremationMainForm(title: model['title']),
                  ),
                );
                break;
              case 'NSA':
                postTrackClick("รับรองลายมือชื่อ");
                _callReadPolicyNsa();
                break;
              default:
            }
          },
          child: (model['code'] != '')
              ? Stack(
                  children: [
                    Image.asset(
                      model['imageUrl'],
                      fit: BoxFit.cover,
                      height: 130,
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFF2D9CED),
                        ),
                        child: Text(
                          model['title'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
        Positioned(
          top: 5,
          right: 15,
          child: (model['code'] == "NEWS" && _isNewsCount) ||
                  (model['code'] == "EVENT" && _isEventCount) ||
                  (model['code'] == "KNOWLEDGE" && _isPollCount) ||
                  (model['code'] == "OTHERBENFITS" && _isPrivilegeCount)
              ? Container(
                  alignment: Alignment.center,
                  width: 30,
                  // height: 90.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red),
                  child: const Text(
                    'N',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  _buildMenuBtm(
    dynamic model,
    bool isCategory,
  ) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            switch (model['code']) {
              case 'EVENT':
                postTrackClick("ปฏิทินกิจกรรมหน้าแรก");
                storage.write(
                  key: 'isBadgerEvent',
                  value: '0', //_eventCount.toString(),
                );
                setState(() {
                  _isEventCount = false;
                  _addBadger();
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventCalendarMainV4(
                      title: model['title'],
                      isBack: true,
                    ),
                  ),
                ).then((value) => _callRead());
                break;
              case 'NSA':
                postTrackClick("รับรองลายมือชื่อ");
                _callReadPolicyNsa();
                break;
              case 'CREMATION':
                postTrackClick("ฌาปนกิจ");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CremationMainForm(title: model['title']),
                  ),
                );
                break;
              case 'CONTACT':
                postTrackClick("เบอร์ติดต่อเร่งด่วนหน้าแรก");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactCategoryPage(
                      title: model['title'],
                    ),
                  ),
                );
                break;
              case 'PRIVILEGE':
                if (loadingModel) break;
                postTrackClick("สิทธิประโยชน์หน้าแรก");
                storage.write(
                  key: 'isBadgerPrivilege',
                  value: '0', //_isPrivilegeCount.toString(),
                );
                setState(() {
                  _isPrivilegeCount = false;
                  _addBadger();
                });
                _callReadPolicyPrivilege(model['title']);
                break;

              default:
            }
          },
          child: (model['code'] != '')
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        model['imageUrl'],
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                            width: 182,
                            height: 47,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                            decoration: BoxDecoration(
                                color: Color(0xFF011895),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(16),
                                    bottomLeft: Radius.circular(16))),
                            child: Center(
                              child: Text(
                                model['title'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                            ))),
                  ],
                )
              : Container(),
        ),
        Positioned(
          top: 5,
          right: 15,
          child: (model['code'] == "NEWS" && _isNewsCount) ||
                  (model['code'] == "EVENT" && _isEventCount) ||
                  (model['code'] == "KNOWLEDGE" && _isPollCount) ||
                  (model['code'] == "OTHERBENFITS" && _isPrivilegeCount)
              ? Container(
                  alignment: Alignment.center,
                  width: 30,
                  // height: 90.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.red),
                  child: const Text(
                    'N',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  void _onRefresh() async {
    // getCurrentUserData();
    // _getLocation();
    _callRead();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    // _refreshController.loadComplete();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  // _performActionOnNotification(Map<String, dynamic> message) async {
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //     builder: (context) => NotificationList(
  //   //       title: 'แจ้งเตือน',
  //   //     ),
  //   //   ),
  //   // );
  // }

  _performActionOnNotificationV2(Map<String, dynamic> message) async {
    switch (message['page']) {
      case 'NEWS':
        {
          _futureNews = postDio('${newsApi}read',
              {'skip': 0, 'limit': 1, 'code': message['code']});
          _newsPage = await _futureNews;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsForm(
                code: message['code'],
                model: _newsPage[0],
              ),
            ),
          );
        }
        break;

      case 'EVENTTCALENDAR':
        {
          _futureEventCalendar = postDio('${eventCalendarApi}read',
              {'skip': 0, 'limit': 1, 'code': message['code']});
          _eventPage = await _futureEventCalendar;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCalendarFormPage(
                code: message['code'],
                model: _eventPage[0],
              ),
            ),
          );
        }
        break;

      case 'PRIVILEGE':
        {
          _futurePrivilege = postDio('${privilegeApi}read',
              {'skip': 0, 'limit': 1, 'code': message['code']});
          _privilegePage = await _futurePrivilege;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivilegeForm(
                code: message['code'],
                model: _privilegePage[0],
              ),
            ),
          );
        }
        break;

      case 'KNOWLEDGE':
        {
          _futureKnowledge = postDio('${knowledgeApi}read',
              {'skip': 0, 'limit': 1, 'code': message['code']});
          _knowledgePage = await _futureKnowledge;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnowledgeForm(
                code: message['code'],
                model: _knowledgePage[0],
              ),
            ),
          );
        }
        break;

      case 'POI':
        {
          _futurePoi = postDio('${poiApi}read',
              {'skip': 0, 'limit': 1, 'code': message['code']});
          _poiPage = await _futurePoi;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoiForm(
                url: poiApi + 'read',
                code: message['code'],
                model: _poiPage[0],
                urlComment: poiCommentApi,
                urlGallery: poiGalleryApi,
              ),
            ),
          );
        }
        break;

      case 'POLL':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PollForm(
                code: message['code'],
                // model: message,
              ),
            ),
          );
        }
        break;
      case 'VETEXAM':
        {
          _futureNotification = postDio('${notificationApi}read',
              {'skip': 0, 'limit': 1, 'reference': message['code']});
          _notificationPage = await _futureNotification;
          if (_notificationPage != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationExpireForm(
                  code: message['code'],
                  model: _notificationPage[0],
                  url: '',
                  urlGallery: '',
                  urlComment: '',
                ),
              ),
            );
          }
        }
        break;
      default:
    }
  }

  _buildBanner() {
    return Stack(
      children: [
        Container(
          child: CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 3,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1,
              enlargeFactor: 1,
              // enlargeCenterPage: false,
              // viewportFraction: 0.8,
              autoPlay: true,
              // enlargeFactor: 0.4,
              // enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              onPageChanged: (index, reason) {
                setState(() {
                  reason != null ? _currentBanner = index : _currentBanner = 0;
                  // _currentBanner = (index ?? 0);
                });
              },
            ),
            items: mockBannerList.map(
              (item) {
                int index = mockBannerList.indexOf(item);
                return

                    // Text( item['imageUrl']);
                    GestureDetector(
                        onTap: () {
                          postTrackClick("แบนเนอร์หน้าแรก");
                          if (item['action'] == 'out') {
                            launchInWebViewWithJavaScript(item['path']);
                            // launchURL(path);
                          } else if (item['action'] == 'in') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarouselForm(
                                  code: item['code'],
                                  model: item,
                                  url: mainBannerApi,
                                  urlGallery: bannerGalleryApi,
                                ),
                              ),
                            );
                          } else if (item['action'].toUpperCase() == 'P') {
                            postDio('${server}m/Rotation/innserlog', item);
                            _callReadPolicyPrivilegeAtoZ(item['code']);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: NetworkImage(item['imageUrl']),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                const Color.fromARGB(133, 70, 70, 70)
                                    .withOpacity(0.5), // ความจางของสี
                                BlendMode.srcATop, // โหมดการผสมสี
                              ),
                            ),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: item['imageUrl'],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ));
              },
            ).toList(),
          ),
        ),
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: mockBannerList.map<Widget>((url) {
              int index = mockBannerList.indexOf(url);
              return Container(
                width: _currentBanner == index ? 17.5 : 7.0,
                height: 7.0,
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  _buildCardProfile(dynamic model) {
    return Container(
      height: 118,
      // color: Colors.white,
      child: GestureDetector(
        onTap: () {
          postTrackClick("โปรไฟล์หน้าแรก");
          profileLawyer["lcCategory"] != '1'
              ? {
                  postTrackClick("บริการอื่นๆหน้าแรก"),
                  _readCheckIn(),
                  buildModalVolunteeLawyer(
                    context,
                    _futureProfile,
                    'กรุณาเลือกบริการ',
                    hasCheckIn,
                    hasCheckOut,
                    'MenuV2',
                  )
                }
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserInformationPageV2(lcCategory: lcCategory),
                  ),
                );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            // margin: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,

              // gradient: LinearGradient(
              //   colors: [Color(0xFFAF86B5), Color(0xFF7948AD)],
              //   begin: Alignment.centerLeft,
              //   // end: new Alignment(1, 0.0),
              //   end: Alignment.centerRight,
              // ),
            ),
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
                                child: Text(
                                  profileLawyer?["lcCategory"] == '1'
                                      ? 'บุคคลทั่วไป'
                                      : 'ทนายความ',
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
                            _dialogQR(profileLawyer['com_no'])
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
        ),
      ),
    );
  }

  _readNoti() async {
    var _profile = await _futureProfile;
    dynamic _username = _profile["username"];
    dynamic _category = _profile["category"];
    _futureNoti = postDio(
      notificationApi + 'count',
      {
        "username": _username,
        "category": _category,
      },
    );
    var _norti = await _futureNoti;
    setState(() {
      nortiCount = _norti['total'];
    });
  }

  _readCheckIn() async {
    // read checkIn
    var now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    var dateString = DateFormat('yyyyMMdd').format(date).toString();
    var resCheckIn =
        await postDio(server + 'm/v2/volunteeLawyer/checkIn/read', {
      "reference": profileCode + '-' + dateString + '070000',
      "profileCode": profileCode
    });
    if (resCheckIn != null) {
      if (resCheckIn.length > 0) {
        setState(() {
          if (resCheckIn.length > 1) {
            hasCheckOut = true;
          }
          hasCheckIn = true;
        });
      }
    }
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    setState(() {
      loadingModel = false;
      if (profileCode != '' && profileCode != null) {
        _futureProfile = postDio(profileReadApi, {'code': profileCode});
        _futureOrganizationImage =
            postDio(organizationImageReadApi, {"code": profileCode});
        _futureProfile.then((x) => {
              profileLawyer = x,
            });
      } else {
        logout(context);
      }
    });

    var token = await storage.read(key: 'token');
    if (token != '' && token != null)
      postDio('${server}m/v2/register/token/create',
          {'token': token, 'profileCode': profileCode});

    var imageUrlSocial = await storage.read(key: 'profileImageUrl');
    if (imageUrlSocial != '' && imageUrlSocial != null)
      setState(() {
        _imageUrl = imageUrlSocial;
      });
    var value = await storage.read(key: 'dataUserLoginLC');
    if (value == '' || value == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
    var data = json.decode(value!);

    userCode = data['code'];
    var profile = await _futureProfile;
    dynamic _username = profile["username"];
    dynamic _category = profile["category"];
    _futureNoti = postDio(
      notificationApi + 'count',
      {
        "username": _username,
        "category": _category,
        // "category": "line", //แก้เวอร์ชั่นหน้า
      },
    );
    var _norti = await _futureNoti;
    print('notificationApi/count');
    nortiCount = _norti['total'];

    setState(() {
      lcCategory = profile['lcCategory'] == "1" ? true : false;
      idcard = profile['idcard'] != '' ? profile['idcard'] : '';
      ocategory = profile['ocategory'];
      userData = User(
          username: data['username'] != '' ? data['username'] : '',
          password: data['password'] != '' ? data['password'].toString() : '',
          firstName: data['firstName'] != '' ? data['firstName'] : '',
          lastName: data['lastName'] != '' ? data['lastName'] : '',
          imageUrl: data['imageUrl'] != '' ? data['imageUrl'] : '',
          category: data['category'] != '' ? data['category'] : '',
          countUnit: data['countUnit'] != '' ? data['countUnit'] : '',
          address: data['address'] ?? '',
          status: data['status'] ?? '',
          idcard: data['idcard'] ?? '');
    });

    _futurePrivilege = postDio('${privilegeApi}read', {'skip': 0, 'limit': 10});
    postDio('${mainBannerApi}read', {'skip': 0, 'limit': 10})
        .then((value) async => {
              setState(() {
                mockBannerList = value;
              })
            });
    _futureMainPopUp =
        postDio('${mainPopupHomeApi}read', {'skip': 0, 'limit': 10});
    _futureKnowledge = postDio('${knowledgeApi}read', {
      'skip': 0,
      'limit': 10,
      'isHighlight': true,
      'category': '',
      'isPublic': userData!.status == "N" ? true : false,
    });
    _futureNews = postDio('${newsApi}read', {
      'skip': 0,
      'limit': 10,
      'isHighlight': true,
      'category': '',
      'isPublic': userData!.status == "N" ? true : false,
    });
    _futureEventCalendar = postDio('${eventCalendarApi}read', {
      'skip': 0,
      'limit': 10,
      'isHighlight': true,
      'category': '',
      'isPublic': userData!.status == "N" ? true : false,
    });
    _futureAboutUs = postDio('${aboutUsApi}read', {});

    _addBadger();
    // getMainPopUp();
    _getLocation();
    getImageLv0();
    _callReadPolicy();
    _readCheckIn();
  }

  _addBadger() async {
    String? storageNewsCount = await storage.read(key: 'isBadgerNews');
    String? storageEventCount = await storage.read(key: 'isBadgerEvent');
    String? storagePollCount = await storage.read(key: 'isBadgerPoll');
    String? storagePrivilegeCount =
        await storage.read(key: 'isBadgerPrivilege');

    _isNewsCount = storageNewsCount == '1' ? true : false;
    _isEventCount = storageEventCount == '1' ? true : false;
    _isPollCount = storagePollCount == '1' ? true : false;
    _isPrivilegeCount = storagePrivilegeCount == '1' ? true : false;

    if (_isNewsCount && _isEventCount && _isPollCount && _isPrivilegeCount)
      add_badger = 4;
    else if ((_isNewsCount && _isEventCount && _isPollCount) ||
        (_isNewsCount && _isEventCount && _isPrivilegeCount) ||
        (_isNewsCount && _isPollCount && _isPrivilegeCount) ||
        (_isEventCount && _isPollCount && _isPrivilegeCount))
      add_badger = 3;
    else if ((_isNewsCount && _isEventCount) ||
        (_isNewsCount && _isPollCount) ||
        (_isNewsCount && _isPrivilegeCount) ||
        (_isPollCount && _isEventCount) ||
        (_isPollCount && _isPrivilegeCount) ||
        (_isEventCount && _isPrivilegeCount))
      add_badger = 2;
    else if (_isNewsCount || _isEventCount || _isPollCount || _isPrivilegeCount)
      add_badger = 1;
    else
      add_badger = 0;

    // FlutterAppBadger.updateBadgeCount(add_badger);
    // badges.FlutterAppBadge.updateBadge(add_badger);
    FlutterAppBadge.count(add_badger);

    _updateBadgerStorage('isBadgerNews', _isNewsCount ? '1' : '0');
    _updateBadgerStorage('isBadgerEvent', _isEventCount ? '1' : '0');
    _updateBadgerStorage('isBadgerPoll', _isPollCount ? '1' : '0');
    _updateBadgerStorage('isBadgerPrivilege', _isPrivilegeCount ? '1' : '0');
  }

  _updateBadgerStorage(String keyTitle, String isActive) {
    storage.write(
      key: keyTitle,
      value: isActive,
    );
  }

  getImageLv0() async {
    await storage.delete(key: 'imageLv0');

    var value = await storage.read(key: 'dataUserLoginLC');
    if (value == null || value == '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
      return; // return เพื่อหยุดการทำงานหากไม่มีข้อมูล
    }

    var data =
        json.decode(value); // value! ไม่ควรใช้ตรงนี้เพราะเราได้ตรวจสอบค่าแล้ว
    if (data['countUnit'] == null) {
      // หากไม่มี countUnit ใน data ก็หยุดการทำงาน
      return;
    }
    var countUnit = json.decode(data['countUnit']);
    var rawLv0 = [];

    if (rawLv0.isEmpty) {
      countUnit.forEach((e) {
        if (e['status'] != null && e['status'] == 'A') {
          rawLv0.add(e['lv0'].toString());
        }
      });
    }

    var unique = rawLv0.toSet().toList(); // ใช้ Set เพื่อหลีกเลี่ยงค่าซ้ำ

    // ใช้ for-in loop เพื่อทำงานแบบ asynchronous อย่างถูกต้อง
    for (var element in unique) {
      var response =
          await postDio(server + 'organization/read', {'code': element});
      if (response != null && response.isNotEmpty) {
        imageLv0.add(response[0]['imageUrl']);
      } else {
        print('No response or empty data for code: $element');
      }
    }

    // เก็บค่าผลลัพธ์ใน storage
    await storage.write(
      key: 'imageLv0',
      value: jsonEncode(imageLv0),
    );

    // อ่านค่า imageLv0 จาก storage
    var image0 = await storage.read(key: 'imageLv0');
    if (image0 != null) {
      resultImageLv0 = json.decode(image0);
    } else {
      print("No image data found");
    }

    unique.clear();
    imageLv0.clear();
  }

  _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        currentLocation = placemarks.first.administrativeArea ?? '';
      });
    } catch (e) {
      print('Get location error: $e');
    }
  }

  Future<Null> _callReadPolicy() async {
    var policy = await postDio(server + "m/policy/read", {
      "category": "application",
    });

    if (policy.length > 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => PolicyV2Page(
            category: 'application',
            navTo: () {
              // Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeV4(),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
        (Route<dynamic> route) => false,
      );

      // if (!isPolicyFasle) {
      //   logout(context);
      //   _onRefresh();
      // }
    } else {
      getMainPopUp();
    }
  }

  Future<Null> _callReadPolicyNsa() async {
    var policy = await postDio(server + "m/policy/readAccept", {
      "category": "nsa",
    });

    if (policy.length > 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NSAMainForm(
            title: '',
          ),
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NsaReportPolicy(
            title: '',
          ),
        ),
      );
    }
  }

  Future<Null> _callReadPolicyPrivilege(String title) async {
    setState(() {
      loadingModel = true;
    });
    var policy = await postDio(server + "m/policy/read",
        {"category": "marketing", "skip": 0, "limit": 10});

    setState(() {
      loadingModel = false;
    });

    if (policy.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder: (context) => PolicyV2Page(
            category: 'marketing',
            navTo: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivilegeMainV3(
                    title: title,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivilegeMainV3(
            title: title,
          ),
        ),
      );
    }
  }

  Future<Null> _callReadPolicyPrivilegeV2(String title) async {
    var policy = await postDio(server + "m/policy/read", {
      "category": "marketing",
    });

    if (policy.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder: (context) => PolicyV2Page(
            category: 'marketing',
            navTo: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ComingPrivilege(),
                ),
              );
            },
          ),
        ),
      );

      // if (!isPolicyFasle) {
      //   logout(context);
      //   _onRefresh();
      // }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComingPrivilege(),
        ),
      );
    }
  }

  getMainPopUp() async {
    var result =
        await postDio('${mainPopupHomeApi}read', {'skip': 0, 'limit': 100});

    if (result.length > 0) {
      var valueStorage = await storage.read(key: 'mainPopupLC');
      var dataValue;
      if (valueStorage != null) {
        dataValue = json.decode(valueStorage);
      } else {
        dataValue = null;
      }

      var now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      if (dataValue != null) {
        var index = dataValue.indexWhere(
          (c) =>
              c['username'] == userData!.username &&
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index == -1) {
          setState(() {
            hiddenMainPopUp = false;
          });
          return showDialog(
            barrierDismissible: false, // close outside
            context: context,
            builder: (_) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: MainPopupDialog(
                  model: _futureMainPopUp,
                  type: 'mainPopup',
                  username: userData!.username,
                  url: '',
                  urlGallery: '',
                ),
              );
            },
          );
        } else {
          setState(() {
            hiddenMainPopUp = true;
          });
        }
      } else {
        setState(() {
          hiddenMainPopUp = false;
        });
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: MainPopupDialog(
                model: _futureMainPopUp,
                type: 'mainPopup',
                username: userData!.username,
                url: '',
                urlGallery: '',
              ),
            );
          },
        );
      }
    }
  }

  confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastFail(
        context,
        text: 'กดอีกครั้งเพื่อออก',
        color: Colors.black,
        fontColor: Colors.white,
      );
    } else {
      SystemNavigator.pop();
    }
  }

  Future<Null> _callReadPolicyPrivilegeAtoZ(code) async {
    var policy =
        await postDio(server + "m/policy/readAtoZ", {"reference": "AtoZ"});
    if (policy.length <= 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder: (context) => PolicyV2Page(
            category: 'AtoZ',
            navTo: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => EnfranchiseMain(
                    reference: code,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnfranchiseMain(
            reference: code,
          ),
        ),
      );
    }
  }

  _buildModalVote() {
    return showCupertinoModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0.4),
        backgroundColor: Colors.white.withOpacity(0.4),
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0.75, 0),
                      color: Colors.grey.withOpacity(0.4),
                    )
                  ]),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        const Center(
                          child: Text(
                            'ข้อมูลการเลือกตั้ง',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF011895),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        textRowButtonGo(
                          context,
                          title: 'ข้อมูลผู้สมัคร',
                          // typeBtn: 'pageCI',
                          fontSize: 17.0,
                          value: 'http://lawyerselection2565.com/#/applicant',
                          typeBtn: 'link',
                        ),
                        textRowButtonGo(
                          context,
                          title: 'ติดตามผลการเลือกตั้ง',
                          // typeBtn: 'pageRVOC',
                          fontSize: 17.0,
                          value: 'http://lawyerselection2565.com/#/count-votes',
                          typeBtn: 'link',
                        ),
                        textRowButtonGo(
                          context,
                          title: 'ติดต่อศูนย์อำนวยการเลือกตั้ง',
                          value:
                              'https://www.facebook.com/lawyerselection2565/',
                          typeBtn: 'link',
                          fontSize: 17.0,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF28A34),
                        ),
                        child: const Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _dialogQR(code) {
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
}
