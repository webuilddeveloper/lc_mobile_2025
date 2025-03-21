// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:lc/component/carousel_banner.dart';
// import 'package:lc/component/link_url_in.dart';
// import 'package:lc/component/teacher/text_row.dart';
// import 'package:lc/pages/about_us/about_us_form.dart';
// import 'package:lc/pages/auth/login_new.dart';
// import 'package:lc/pages/blank_page/toast_fail.dart';
// import 'package:lc/pages/contact/contact_list_category.dart';
// import 'package:lc/pages/e_service/e_service_list.dart';
// import 'package:lc/pages/enfranchise/enfrancise_main.dart';
// import 'package:lc/pages/event_calendar/event_calendar_main.dart';
// import 'package:lc/pages/knowledge/knowledge_list.dart';
// import 'package:lc/pages/lawyer/lawyer_list.dart';
// import 'package:lc/pages/main_popup/dialog_main_popup.dart';
// import 'package:lc/pages/news/news_list.dart';
// import 'package:lc/pages/policy_v2.dart';
// import 'package:lc/pages/privilege/privilege_main.dart';
// import 'package:lc/pages/privilegeSpecial/privilege_special_list.dart';
// import 'package:lc/pages/profile/user_information_v2.dart';
// import 'package:lc/pages/search_other/search_other_list.dart';
// import 'package:lc/widget/build_modal.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:lc/component/sso/profile.dart';
// import 'package:lc/models/user.dart';
// import 'package:lc/shared/api_provider.dart';
// import 'package:lc/component/carousel_form.dart';
// import 'widget/header_v2.dart';

// class MenuV2 extends StatefulWidget {
//   @override
//   _MenuV2 createState() => _MenuV2();
// }

// class _MenuV2 extends State<MenuV2> with WidgetsBindingObserver {
//   bool loadingModel = false;

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     setState(() {
//       _addBadger();
//     });
//   }

//   final storage = new FlutterSecureStorage();
//   DateTime currentBackPressTime;

//   // Profile profile = new Profile(model: Future.value({}));
//   // Profile profile;

//   Future<dynamic> _futureProfile;
//   Future<dynamic> _futureOrganizationImage;
//   Future<dynamic> _futureBanner;
//   Future<dynamic> _futureMenu;
//   Future<dynamic> _futureAboutUs;
//   Future<dynamic> _futureMainPopUp;

//   LatLng latLng = LatLng(0, 0);
//   Future<dynamic> _futureNoti;
//   // Future<dynamic> _futureKnowledge;
//   // Future<dynamic> _futurePoll;
//   // Future<dynamic> _futureFaq;
//   // Future<dynamic> _futurePrivilege;

//   String currentLocation = '-';
//   final seen = Set<String>();
//   List unique = [];
//   List resultImageLv0 = [];
//   List imageLv0 = [];
//   bool hasCheckIn = false;
//   bool hasCheckOut = false;

//   String profileCode = "";

//   User userData;
//   bool notShowOnDay = false;
//   bool hiddenMainPopUp = false;

//   String userCode = '';
//   String ocategory = '';

//   dynamic _isNewsCount = false;
//   dynamic _isEventCount = false;
//   dynamic _isPollCount = false;
//   dynamic _isPrivilegeCount = false;
//   dynamic lcCategory = false;
//   dynamic idcard;

//   int nortiCount = 0;

//   int add_badger = 0;

//   RefreshController _refreshController =
//       RefreshController(initialRefresh: false);

//   StreamSubscription<Map> _notificationSubscription;

//   @override
//   void initState() {
//     _callRead();
//     super.initState();
//     // NotificationService.instance.start();
//     // _notificationSubscription = NotificationsBloc.instance.notificationStream
//     //     .listen(_performActionOnNotification);

//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     _notificationSubscription.cancel();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.transparent,
//       // floatingActionButton: InkWell(
//       //   child: Image.asset(
//       //     'assets/images/buttonVote.png',
//       //     height: 50,
//       //   ),
//       //   //lcCategory เป็นtrue คือ 1=สมาชิก เป็นfalse คือ 2=ทนายอาสา
//       //   onTap: () => lcCategory
//       //       ? _buildModalVote()
//       //       : Navigator.push(
//       //           context,
//       //           MaterialPageRoute(
//       //             builder: (context) => LawyerList(
//       //               model: _futureProfile,
//       //               selectedVote: true,
//       //             ),
//       //           ),
//       //         ),
//       // ),
//       appBar: headerV2(
//         context,
//         title: "สภาทนายความ",
//         userData: userData,
//         lcCategory: lcCategory,
//         idcard: idcard,
//         totalnorti: nortiCount,
//         callback: _readNoti,
//       ),
//       body: WillPopScope(
//         child: NotificationListener<OverscrollIndicatorNotification>(
//           onNotification: (OverscrollIndicatorNotification overScroll) {
//             overScroll.disallowIndicator();
//             return false;
//           },
//           child: _buildBackground(),
//         ),
//         onWillPop: confirmExit,
//       ),
//     );
//   }

//   _buildBackground() {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFF7F7F7),
//         // gradient: LinearGradient(
//         //   colors: [
//         //     Color(0xFF1B6CA8),
//         //     Color(0xFF1B6CA8),
//         //     Color(0xFFFFFFFF),
//         //   ],
//         //   begin: Alignment.topCenter,
//         //   // end: new Alignment(1, 0.0),
//         //   end: Alignment.bottomCenter,
//         // ),
//       ),
//       child: _buildNotificationListener(),
//     );
//   }

//   _buildNotificationListener() {
//     return NotificationListener<OverscrollIndicatorNotification>(
//       onNotification: (OverscrollIndicatorNotification overScroll) {
//         overScroll.disallowIndicator();
//         return false;
//       },
//       child: _buildSmartRefresher(),
//     );
//   }

//   _buildSmartRefresher() {
//     return SmartRefresher(
//       enablePullDown: true,
//       enablePullUp: false,
//       header: WaterDropHeader(
//         complete: Container(
//           child: Text(''),
//         ),
//         completeDuration: Duration(milliseconds: 0),
//       ),
//       controller: _refreshController,
//       onRefresh: _onRefresh,
//       // onLoading: _onLoading,
//       child: FutureBuilder<dynamic>(
//         future: _futureProfile,
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           if (snapshot.hasData) {
//             return _buildListView(model: snapshot.data);
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }

//   _buildListView({dynamic model}) {
//     return FutureBuilder<dynamic>(
//       future: _futureMenu, // function where you call your api
//       builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.hasData) {
//           return ListView(
//             shrinkWrap: true,
//             physics: BouncingScrollPhysics(),
//             children: [
//               Container(
//                 //height: 270,
//                 // height: model['lcCategory'] == '1'
//                 //     ? (MediaQuery.of(context).size.height / 100) * 39
//                 //     : (MediaQuery.of(context).size.height / 100) * 45,
//                 decoration: BoxDecoration(
//                   borderRadius: new BorderRadius.only(
//                     bottomLeft: const Radius.circular(15.0),
//                     bottomRight: const Radius.circular(15.0),
//                   ),
//                   color: Color(0XFFE8F6F8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(left: 10, right: 10, top: 10),
//                       child: _buildProfile(model: model),
//                     ),
//                     model['lcCategory'] == '1'
//                         ? Padding(
//                             padding: EdgeInsets.only(left: 10, right: 10),
//                           )
//                         : Padding(
//                             padding: EdgeInsets.only(left: 10, right: 10),
//                             child: _buildBottomProfile(),
//                           ),
//                     SizedBox(height: 15),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Text(
//                         'ประชาสัมพันธ์',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: _buildBanner(),
//                     ),
//                     SizedBox(height: 15),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       child: Text(
//                         'บริการทั้งหมด',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // SizedBox(height: 5),
//               _buildButtonMenu(
//                   snapshot.data[0], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 3),
//               _buildButtonMenu(
//                   snapshot.data[1], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 3),
//               _buildButtonMenu(
//                   snapshot.data[2], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 3),
//               _buildButtonMenu(
//                   snapshot.data[3], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 3),
//               _buildButtonMenu(
//                   snapshot.data[4], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 3),
//               _buildButtonMenu(
//                   snapshot.data[5], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 3),
//               _buildButtonMenu(
//                   snapshot.data[6], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 3),
//               _buildButtonMenu(
//                   snapshot.data[7], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 3),
//               _buildButtonMenu(
//                   snapshot.data[8], model['lcCategory'] == '1' ? false : true),
//               SizedBox(height: 20),
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Container();
//         } else {
//           return Container();
//         }
//       },
//     );
//   }

//   _buildBottomProfile() {
//     return Container(
//       padding: EdgeInsets.all(10.0),
//       alignment: Alignment.center,
//       height: 60,
//       decoration: BoxDecoration(
//         color: Color(0xFF1B6CA8),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(15),
//           bottomRight: Radius.circular(15),
//         ),
//       ),
//       child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   Container(
//                     child: InkWell(
//                       onTap: () {
//                         postTrackClick("ตรวจสอบข้อมูลใบอนุญาตทนายความหน้าแรก");
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 LawyerList(model: _futureProfile),
//                           ),
//                         );
//                       },
//                       child: CircleAvatar(
//                         backgroundColor: Color(0xFF011895),
//                         radius: 30,
//                         child: Image.asset(
//                           "assets/logo/icons/Group6697.png",
//                           width: 35,
//                           height: 35,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Container(
//                           child: Text(
//                             'ตรวจสอบข้อมูล',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'Kanit',
//                             ),
//                           ),
//                         ),
//                         Container(
//                           child: Text(
//                             'ใบอนุญาตทนายความ',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'Kanit',
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Row(
//                 children: [
//                   Container(
//                     child: InkWell(
//                       onTap: () {
//                         postTrackClick("บริการอื่นๆหน้าแรก");
//                         _readCheckIn();
//                         buildModalVolunteeLawyer(
//                           context,
//                           _futureProfile,
//                           'กรุณาเลือกบริการ',
//                           hasCheckIn,
//                           hasCheckOut,
//                           'MenuV2',
//                         );
//                       },
//                       child: CircleAvatar(
//                         backgroundColor: Color(0xFF011895),
//                         radius: 30,
//                         child: Image.asset(
//                           "assets/logo/icons/dotsmenu.png",
//                           width: 25,
//                           height: 25,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Container(
//                     child: Text(
//                       'บริการอื่นๆ',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 12.0,
//                         fontWeight: FontWeight.w500,
//                         fontFamily: 'Kanit',
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ]),
//     );
//   }

//   _buildButtonMenu(dynamic model, bool isCategory) {
//     return Stack(
//       children: <Widget>[
//         InkWell(
//           onTap: () {
//             switch (model['code']) {
//               case 'LAWYERS_COUNCIL':
//                 postTrackClick("สารสภาทนายความหน้าแรก");
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => KnowledgeList(
//                       title: model['title'],
//                     ),
//                   ),
//                 );
//                 break;
//               case 'E_SERVICE':
//                 postTrackClick("บริการอิเล็กทรอนิกส์หน้าแรก");
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EserviceList(
//                         title: model['title'], isCategory: isCategory),
//                   ),
//                 );
//                 break;
//               case 'PRIVILEGE':
//                 if (loadingModel) break;
//                 postTrackClick("สิทธิประโยชน์หน้าแรก");
//                 storage.write(
//                   key: 'isBadgerPrivilege',
//                   value: '0', //_isPrivilegeCount.toString(),
//                 );
//                 setState(() {
//                   _isPrivilegeCount = false;
//                   _addBadger();
//                 });
//                 _callReadPolicyPrivilege(model['title']);
//                 break;
//               case 'OTHERBENFITS':
//                 postTrackClick("สิทธิพิเศษหน้าแรก");
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PrivilegeSpecialList(
//                       title: model['title'],
//                     ),
//                   ),
//                 );
//                 break;
//               case 'EVENT':
//                 postTrackClick("ปฏิทินกิจกรรมหน้าแรก");
//                 storage.write(
//                   key: 'isBadgerEvent',
//                   value: '0', //_eventCount.toString(),
//                 );
//                 setState(() {
//                   _isEventCount = false;
//                   _addBadger();
//                 });
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => EventCalendarMain(
//                       title: model['title'],
//                     ),
//                   ),
//                 ).then((value) => _callRead());
//                 break;
//               case 'KNOWLEDGE':
//                 postTrackClick("สืบค้นฐานข้อมูลต่างๆหน้าแรก");
//                 storage.write(
//                   key: 'isBadgerPoll',
//                   value: '0', //_pollCount.toString(),
//                 );
//                 setState(() {
//                   _isPollCount = false;
//                   _addBadger();
//                 });
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SearchOtherList(
//                       title: model['title'],
//                       model: _futureProfile,
//                     ),
//                   ),
//                 ).then((value) => _callRead());
//                 break;
//               case 'NEWS':
//                 postTrackClick("ข่าวประชาสัมพันธ์หน้าแรก");
//                 storage.write(
//                   key: 'isBadgerNews', value: '0', //_newsCount.toString(),
//                 );
//                 setState(() {
//                   _isNewsCount = false;
//                   _addBadger();
//                 });
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => NewsList(
//                       title: model['title'],
//                     ),
//                   ),
//                 ).then((value) => _callRead());
//                 break;
//               case 'CONTACT':
//                 postTrackClick("เบอร์ติดต่อเร่งด่วนหน้าแรก");
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ContactListCategory(
//                       title: model['title'],
//                     ),
//                   ),
//                 );
//                 break;
//               case 'ABOUT_US':
//                 postTrackClick("เกี่ยวกับเราหน้าแรก");
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AboutUsForm(
//                       model: _futureAboutUs,
//                       title: model['title'],
//                     ),
//                   ),
//                 );
//                 break;
//               default:
//             }
//           },
//           child: (model['code'] != '')
//               ? Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   width: MediaQuery.of(context).size.width,
//                   height: (MediaQuery.of(context).size.height / 100) * 12,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(5.0),
//                     child: Image.network(
//                       model['imageUrl'],
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 )
//               : Container(),
//         ),
//         Positioned(
//           top: 5,
//           right: 15,
//           child: (model['code'] == "NEWS" && _isNewsCount) ||
//                   (model['code'] == "EVENT" && _isEventCount) ||
//                   (model['code'] == "KNOWLEDGE" && _isPollCount) ||
//                   (model['code'] == "OTHERBENFITS" && _isPrivilegeCount)
//               ? Container(
//                   alignment: Alignment.center,
//                   width: 30,
//                   // height: 90.0,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       color: Colors.red),
//                   child: Text(
//                     'N',
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )
//               : Container(),
//         ),
//       ],
//     );
//   }

//   void _onRefresh() async {
//     // getCurrentUserData();
//     // _getLocation();
//     _callRead();

//     // if failed,use refreshFailed()
//     _refreshController.refreshCompleted();
//     // _refreshController.loadComplete();
//   }

//   // _performActionOnNotification(Map<String, dynamic> message) async {
//   //   // Navigator.push(
//   //   //   context,
//   //   //   MaterialPageRoute(
//   //   //     builder: (context) => NotificationList(
//   //   //       title: 'แจ้งเตือน',
//   //   //     ),
//   //   //   ),
//   //   // );
//   // }

//   _buildBanner() {
//     return CarouselBanner(
//       model: _futureBanner,
//       //height: 100,
//       height: (MediaQuery.of(context).size.height / 100) * 20,
//       nav: (String path, String action, dynamic model, String code,
//           String urlGallery) {
//         postTrackClick("แบนเนอร์หน้าแรก");
//         if (action == 'out') {
//           launchInWebViewWithJavaScript(path);
//           // launchURL(path);
//         } else if (action == 'in') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CarouselForm(
//                 code: code,
//                 model: model,
//                 url: mainBannerApi,
//                 urlGallery: bannerGalleryApi,
//               ),
//             ),
//           );
//         } else if (action.toUpperCase() == 'P') {
//           postDio('${server}m/Rotation/innserlog', model);
//           _callReadPolicyPrivilegeAtoZ(code);
//         }
//       },
//     );
//   }

//   _buildProfile({dynamic model}) {
//     return Profile(
//       model: _futureProfile,
//       organizationImage: _futureOrganizationImage,
//       nav: () {
//         postTrackClick("โปรไฟล์หน้าแรก");
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => UserInformationPageV2(lcCategory: lcCategory),
//           ),
//         );
//       },
//       nav1: () {
//         postTrackClick("โปรไฟล์หน้าแรก");
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: model['lcCategory'] == '1'
//                 ? (context) => UserInformationPageV2(lcCategory: lcCategory)
//                 : (context) => LawyerList(model: _futureProfile),
//           ),
//         );
//       },
//     );
//   }

//   _readNoti() async {
//     var _profile = await _futureProfile;
//     dynamic _username = _profile["username"];
//     _futureNoti = postDio(
//       notificationApi + 'count',
//       {
//         "username": _username,
//       },
//     );
//     var _norti = await _futureNoti;
//     setState(() {
//       nortiCount = _norti['total'];
//     });
//   }

//   _readCheckIn() async {
//     // read checkIn
//     var now = new DateTime.now();
//     DateTime date = new DateTime(now.year, now.month, now.day);
//     var dateString = DateFormat('yyyyMMdd').format(date).toString();
//     var resCheckIn =
//         await postDio(server + 'm/v2/volunteeLawyer/checkIn/read', {
//       "reference": profileCode + '-' + dateString + '070000',
//       "profileCode": profileCode
//     });
//     if (resCheckIn != null) {
//       if (resCheckIn.length > 0) {
//         setState(() {
//           if (resCheckIn.length > 1) {
//             hasCheckOut = true;
//           }
//           hasCheckIn = true;
//         });
//       }
//     }
//   }

//   _callRead() async {
//     profileCode = await storage.read(key: 'profileCode18');
//     // print('------------------------$profileCode----------------------');
//     if (profileCode != '' && profileCode != null) {
//       _futureProfile = postDio(profileReadApi, {'code': profileCode});
//       _futureOrganizationImage =
//           postDio(organizationImageReadApi, {"code": profileCode});
//     } else {
//       logout(context);
//     }

//     setState(() {
//       loadingModel = false;
//     });

//     var token = await storage.read(key: 'token');
//     if (token != '' && token != null)
//       postDio('${server}m/v2/register/token/create',
//           {'token': token, 'profileCode': profileCode});

//     var imageUrlSocial = await storage.read(key: 'profileImageUrl');
//     if (imageUrlSocial != '' && imageUrlSocial != null) setState(() {});

//     // print('-------------start response------------');
//     var value = await storage.read(key: 'dataUserLoginLC');
//     if (value == '' || value == null) {
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (context) => LoginPage(),
//         ),
//         (Route<dynamic> route) => false,
//       );
//     }
//     var data = json.decode(value);

//     userCode = data['code'];
//     // final result = await postObjectData("m/policy/read", {
//     //   "category": "marketing",
//     //   "username": data['username'],
//     // });

//     // if (result['status'] == 'S') {
//     //   if (result['objectData'].length > 0) {
//     //     setState(() {
//     //       _dataPolicy = result['objectData'];
//     //     });
//     //   }
//     // }

//     var profile = await _futureProfile;
//     dynamic _username = profile["username"];
//     _futureNoti = postDio(
//       notificationApi + 'count',
//       {
//         "username": _username,
//       },
//     );
//     var _norti = await _futureNoti;
//     nortiCount = _norti['total'];

//     setState(() {
//       lcCategory = profile['lcCategory'] == "1" ? true : false;
//       idcard = profile['idcard'] != '' ? profile['idcard'] : '';
//       ocategory = profile['ocategory'];
//       userData = new User(
//         username: data['username'] != '' ? data['username'] : '',
//         password: data['password'] != '' ? data['password'].toString() : '',
//         firstName: data['firstName'] != '' ? data['firstName'] : '',
//         lastName: data['lastName'] != '' ? data['lastName'] : '',
//         imageUrl: data['imageUrl'] != '' ? data['imageUrl'] : '',
//         category: data['category'] != '' ? data['category'] : '',
//         countUnit: data['countUnit'] != '' ? data['countUnit'] : '',
//         address: data['address'] != '' ? data['address'] : '',
//         status: data['status'] != '' ? data['status'] : '',
//         idcard: data['idcard'] != '' ? data['idcard'] : '',
//       );
//     });

//     if (value != '' && value != null) {
//       // var api =
//       //     data['category'] == 'guest' ? 'login' : data['category'] + '/login';

//       // _futureProfile = postLogin(registerApi + api, {
//       //   'category': data['category'],
//       //   'username': data['username'],
//       //   'password': data['password'],
//       //   'email': data['email'],
//       // });
//     }
//     _futureMenu = postDio('${menuApi}read', {'skip': 0, 'limit': 100});
//     _futureBanner = postDio('${mainBannerApi}read', {'skip': 0, 'limit': 10});
//     _futureMainPopUp =
//         postDio('${mainPopupHomeApi}read', {'skip': 0, 'limit': 10});
//     _futureAboutUs = postDio('${aboutUsApi}read', {});

// //get api Count
//     // _newsCount = await postDio(newsApi + 'count', {});
//     // _eventCount = await postDio(eventCalendarApi + 'count', {});
//     // _pollCount = await postDio(pollApi + 'count', {});
//     //get storage
//     // int storageNewsCount =
//     //     int.parse(await storage.read(key: 'newsCount') ?? '0');
//     // int storageEventCount =
//     //     int.parse(await storage.read(key: 'eventCount') ?? '0');
//     // int storagePollCount =
//     //     int.parse(await storage.read(key: 'pollCount') ?? '0');

//     // _isNewsCount = _newsCount != storageNewsCount ? true : false;
//     // _isEventCount = _eventCount != storageEventCount ? true : false;
//     // _isPollCount = _pollCount != storagePollCount ? true : false;

//     _addBadger();
//     // getMainPopUp();
//     _getLocation();
//     getImageLv0();
//     _callReadPolicy();
//     _readCheckIn();
//     // print('-------------end response------------');
//   }

//   _addBadger() async {
//     String storageNewsCount = await storage.read(key: 'isBadgerNews');
//     String storageEventCount = await storage.read(key: 'isBadgerEvent');
//     String storagePollCount = await storage.read(key: 'isBadgerPoll');
//     String storagePrivilegeCount = await storage.read(key: 'isBadgerPrivilege');

//     _isNewsCount = storageNewsCount == '1' ? true : false;
//     _isEventCount = storageEventCount == '1' ? true : false;
//     _isPollCount = storagePollCount == '1' ? true : false;
//     _isPrivilegeCount = storagePrivilegeCount == '1' ? true : false;

//     if (_isNewsCount && _isEventCount && _isPollCount && _isPrivilegeCount)
//       add_badger = 4;
//     else if ((_isNewsCount && _isEventCount && _isPollCount) ||
//         (_isNewsCount && _isEventCount && _isPrivilegeCount) ||
//         (_isNewsCount && _isPollCount && _isPrivilegeCount) ||
//         (_isEventCount && _isPollCount && _isPrivilegeCount))
//       add_badger = 3;
//     else if ((_isNewsCount && _isEventCount) ||
//         (_isNewsCount && _isPollCount) ||
//         (_isNewsCount && _isPrivilegeCount) ||
//         (_isPollCount && _isEventCount) ||
//         (_isPollCount && _isPrivilegeCount) ||
//         (_isEventCount && _isPrivilegeCount))
//       add_badger = 2;
//     else if (_isNewsCount || _isEventCount || _isPollCount || _isPrivilegeCount)
//       add_badger = 1;
//     else
//       add_badger = 0;

//     FlutterAppBadger.updateBadgeCount(add_badger);

//     _updateBadgerStorage('isBadgerNews', _isNewsCount ? '1' : '0');
//     _updateBadgerStorage('isBadgerEvent', _isEventCount ? '1' : '0');
//     _updateBadgerStorage('isBadgerPoll', _isPollCount ? '1' : '0');
//     _updateBadgerStorage('isBadgerPrivilege', _isPrivilegeCount ? '1' : '0');
//   }

//   _updateBadgerStorage(String keyTitle, String isActive) {
//     storage.write(
//       key: keyTitle,
//       value: isActive,
//     );
//   }

//   getImageLv0() async {
//     await storage.delete(key: 'imageLv0');
//     var value = await storage.read(key: 'dataUserLoginLC');
//     if (value == '' || value == null) {
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (context) => LoginPage(),
//         ),
//         (Route<dynamic> route) => false,
//       );
//     }
//     var data = json.decode(value);
//     var countUnit = json.decode(data['countUnit']);
//     var rawLv0 = [];

//     if (rawLv0.length == 0) {
//       countUnit
//           .map((e) => {
//                 if (e['status'] != null)
//                   {
//                     if (e['status'] == 'A')
//                       {
//                         rawLv0.add(e['lv0'].toString()),
//                       }
//                   }
//               })
//           .toList();
//     }

//     unique = rawLv0.where((str) => seen.add(str)).toList();

//     rawLv0.forEach((element) async {
//       await postDio(server + 'organization/read', {'code': element})
//           .then((value) => {
//                 if (value.length > 0) {imageLv0.add(value[0]['imageUrl'])}
//               });
//     });

//     storage.write(
//       key: 'imageLv0',
//       value: jsonEncode(imageLv0),
//     );
//     var image0 = await storage.read(key: 'imageLv0');
//     resultImageLv0 = json.decode(image0);
//     unique = [];
//     imageLv0 = [];
//   }

//   _getLocation() async {
//     // print('currentLocation');
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best);

//     // print('------ Position -----' + position.toString());

//     List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude, position.longitude,
//         localeIdentifier: 'th');
//     // print('----------' + placemarks.toString());

//     setState(() {
//       latLng = LatLng(position.latitude, position.longitude);
//       currentLocation = placemarks.first.administrativeArea;
//     });
//   }

//   Future<Null> _callReadPolicy() async {
//     var policy = await postDio(server + "m/policy/read", {
//       "category": "application",
//     });

//     if (policy.length > 0) {
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (context) => PolicyV2Page(
//             category: 'application',
//             navTo: () {
//               // Navigator.pop(context);
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(
//                   builder: (context) => MenuV2(),
//                 ),
//                 (Route<dynamic> route) => false,
//               );
//             },
//           ),
//         ),
//         (Route<dynamic> route) => false,
//       );

//       // if (!isPolicyFasle) {
//       //   logout(context);
//       //   _onRefresh();
//       // }
//     } else {
//       getMainPopUp();
//     }
//   }

//   Future<Null> _callReadPolicyPrivilege(String title) async {
//     setState(() {
//       loadingModel = true;
//     });
//     var policy = await postDio(server + "m/policy/read",
//         {"category": "marketing", "skip": 0, "limit": 10});

//     setState(() {
//       loadingModel = false;
//     });

//     if (policy.length > 0) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           // ignore: missing_required_param
//           // builder: (context) => PolicyIdentityVerificationPage(),
//           builder: (context) => PolicyV2Page(
//             category: 'marketing',
//             navTo: () {
//               Navigator.pop(context);
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PrivilegeMain(
//                     title: title,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PrivilegeMain(
//             title: title,
//           ),
//         ),
//       );
//     }
//   }

//   getMainPopUp() async {
//     var result =
//         await postDio('${mainPopupHomeApi}read', {'skip': 0, 'limit': 100});

//     if (result.length > 0) {
//       var valueStorage = await storage.read(key: 'mainPopupLC');
//       var dataValue;
//       if (valueStorage != null) {
//         dataValue = json.decode(valueStorage);
//       } else {
//         dataValue = null;
//       }

//       var now = new DateTime.now();
//       DateTime date = new DateTime(now.year, now.month, now.day);

//       if (dataValue != null) {
//         var index = dataValue.indexWhere(
//           (c) =>
//               c['username'] == userData.username &&
//               c['date'].toString() ==
//                   DateFormat("ddMMyyyy").format(date).toString() &&
//               c['boolean'] == "true",
//         );

//         if (index == -1) {
//           this.setState(() {
//             hiddenMainPopUp = false;
//           });
//           return showDialog(
//             barrierDismissible: false, // close outside
//             context: context,
//             builder: (_) {
//               return WillPopScope(
//                 onWillPop: () {
//                   return Future.value(false);
//                 },
//                 child: MainPopupDialog(
//                   model: _futureMainPopUp,
//                   type: 'mainPopup',
//                   username: userData.username,
//                 ),
//               );
//             },
//           );
//         } else {
//           this.setState(() {
//             hiddenMainPopUp = true;
//           });
//         }
//       } else {
//         this.setState(() {
//           hiddenMainPopUp = false;
//         });
//         return showDialog(
//           barrierDismissible: false, // close outside
//           context: context,
//           builder: (_) {
//             return WillPopScope(
//               onWillPop: () {
//                 return Future.value(false);
//               },
//               child: MainPopupDialog(
//                 model: _futureMainPopUp,
//                 type: 'mainPopup',
//                 username: userData.username,
//               ),
//             );
//           },
//         );
//       }
//     }
//   }

//   Future<bool> confirmExit() {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       toastFail(
//         context,
//         text: 'กดอีกครั้งเพื่อออก',
//         color: Colors.black,
//         fontColor: Colors.white,
//       );
//       return Future.value(false);
//     }
//     return Future.value(true);
//   }

//   Future<Null> _callReadPolicyPrivilegeAtoZ(code) async {
//     var policy =
//         await postDio(server + "m/policy/readAtoZ", {"reference": "AtoZ"});
//     if (policy.length <= 0) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           // ignore: missing_required_param
//           // builder: (context) => PolicyIdentityVerificationPage(),
//           builder: (context) => PolicyV2Page(
//             category: 'AtoZ',
//             navTo: () {
//               Navigator.pop(context);
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => EnfranchiseMain(
//                     reference: code,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       );
//     } else {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => EnfranchiseMain(
//             reference: code,
//           ),
//         ),
//       );
//     }
//   }

//   _buildModalVote() {
//     return showCupertinoModalBottomSheet(
//         context: context,
//         barrierColor: Colors.white.withOpacity(0.4),
//         backgroundColor: Colors.white.withOpacity(0.4),
//         builder: (context) {
//           return Material(
//             type: MaterialType.transparency,
//             child: new Container(
//               height: 300,
//               width: double.infinity,
//               margin: EdgeInsets.only(top: 2),
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(
//                     top: Radius.circular(15),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 6,
//                       offset: Offset(0.75, 0),
//                       color: Colors.grey.withOpacity(0.4),
//                     )
//                   ]),
//               child: Stack(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(15),
//                     child: Column(
//                       children: [
//                         Center(
//                           child: Text(
//                             'ข้อมูลการเลือกตั้ง',
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Color(0xFF011895),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 40),
//                         textRowButtonGo(
//                           context,
//                           title: 'ข้อมูลผู้สมัคร',
//                           // typeBtn: 'pageCI',
//                           fontSize: 17.0,
//                           value: 'http://lawyerselection2565.com/#/applicant',
//                           typeBtn: 'link',
//                         ),
//                         textRowButtonGo(
//                           context,
//                           title: 'ติดตามผลการเลือกตั้ง',
//                           // typeBtn: 'pageRVOC',
//                           fontSize: 17.0,
//                           value: 'http://lawyerselection2565.com/#/count-votes',
//                           typeBtn: 'link',
//                         ),
//                         textRowButtonGo(
//                           context,
//                           title: 'ติดต่อศูนย์อำนวยการเลือกตั้ง',
//                           value:
//                               'https://www.facebook.com/lawyerselection2565/',
//                           typeBtn: 'link',
//                           fontSize: 17.0,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     top: 15,
//                     right: 15,
//                     child: InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: Container(
//                         height: 35,
//                         width: 35,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xFFF28A34),
//                         ),
//                         child: Icon(
//                           Icons.clear,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//   //
// }
