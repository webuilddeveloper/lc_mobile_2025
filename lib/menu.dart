import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lc/component/carousel_banner.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/loadingImageNetwork.dart';
import 'package:lc/component/menu/build_about_us.dart';
import 'package:lc/component/menu/build_event_calendar.dart';
import 'package:lc/component/menu/build_grid.dart';
import 'package:lc/component/menu/build_news.dart';
import 'package:lc/menu/build_knowledge.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:lc/pages/blank_page/toast_fail.dart';
import 'package:lc/pages/main_popup/dialog_main_popup.dart';
import 'package:lc/pages/notification/notification_list.dart';
import 'package:lc/pages/policy_v2.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/component/sso/profile.dart';
import 'package:lc/models/user.dart';
import 'package:lc/pages/profile/user_information.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/component/carousel_form.dart';
import 'pages/search_list.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {
  final storage = const FlutterSecureStorage();
  late DateTime currentBackPressTime;

  // Profile profile = new Profile(model: Future.value({}));
  // Profile profile;

  late Future<dynamic> _futureProfile;
  late Future<dynamic> _futureOrganizationImage;
  late Future<dynamic> _futureVerify;
  late Future<dynamic> _futureNews;
  late Future<dynamic> _futureBanner;
  late Future<dynamic> _futureContact;
  late Future<dynamic> _futureMenu;
  late Future<dynamic> _futureEventCalendar;
  late Future<dynamic> _futureMainPopUp;
  late Future<dynamic> _futureRotation;
  late Future<dynamic> _futureKnowledge;
  LatLng latLng = const LatLng(0, 0);
  // Future<dynamic> _futureKnowledge;
  // Future<dynamic> _futurePoll;
  // Future<dynamic> _futureFaq;
  // Future<dynamic> _futurePrivilege;

  String currentLocation = '-';
  final seen = <String>{};
  List unique = [];
  List resultImageLv0 = [];
  List imageLv0 = [];

  String profileCode = "";

  late User userData;
  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;

  String userCode = '';

  var loadingModel = {
    'title': '',
    'imageUrl': '',
  };

  late StreamSubscription<Map> _notificationSubscription;

  @override
  void initState() {
    _callRead();
    super.initState();
    // NotificationService.instance.start();
    // _notificationSubscription = NotificationsBloc.instance.notificationStream
    //     .listen(_performActionOnNotification);
  }

  @override
  void dispose() {
    _notificationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //     preferredSize:
      //         Size.fromHeight(70 + MediaQuery.of(context).padding.top),
      //     child: AppBar(
      //       flexibleSpace: profileBar(),
      //     )),
      backgroundColor: Colors.white,
      body: WillPopScope(
          onWillPop: confirmExit,
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowIndicator();
              return false;
            },
            child: checkRegister(context),
          )),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastFail(
        context,
        text: 'กดอีกครั้งเพื่อออก',
        color: Colors.black,
        fontColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  FutureBuilder<dynamic> checkRegister(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<dynamic>(
      future: postDio('${registerApi}read', {'skip': 0, 'limit': 1}),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return refreshPage(status: snapshot.data[0]['status'] ?? '');
          // return Stack(
          //   children: [
          //     Positioned.fill(
          //       child: Container(
          //         child: refreshPage(
          //             status: snapshot.data[0]['status'] != null
          //                 ? snapshot.data[0]['status']
          //                 : ''),
          //       ),
          //     ),
          //     Container(
          //         alignment: Alignment.bottomCenter, child: _buildFooter()),
          //   ],
          // );
        } else if (snapshot.hasError) {
          postLineNoti();
          return SizedBox(
            width: double.infinity,
            height: height,
            child: dialogFail(context, reloadApp: true),
          );
        } else {
          return refreshPage(status: '');
        }
      },
    );
  }

  // void logout() async {
  //   var category = await storage.read(key: 'profileCategory');

  //   final GoogleSignIn _googleSignIn = GoogleSignIn(
  //     scopes: <String>[
  //       'email',
  //       'https://www.googleapis.com/auth/contacts.readonly',
  //     ],
  //   );

  //   if (category == 'google') {
  //     _googleSignIn.disconnect();
  //   } else if (category == 'facebook') {
  //     await facebookSignIn.logOut();
  //   }

  //   // delete
  //   await storage.deleteAll();

  //   Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(
  //       builder: (context) => LoginPage(),
  //     ),
  //     (Route<dynamic> route) => false,
  //   );
  // }

  refreshPage({String status = ''}) {
    return Stack(
      children: [
        // Positioned.fill(
        //   child: _listViewmenu(),
        //   // child: SmartRefresher(
        //   //   enablePullDown: false,
        //   //   enablePullUp: false,
        //   //   header: WaterDropHeader(
        //   //     complete: Container(
        //   //       child: Text('dasdsa'),
        //   //     ),
        //   //     completeDuration: Duration(milliseconds: 0),
        //   //   ),
        //   //   controller: _refreshController,
        //   //   onRefresh: _onRefresh,
        //   //   onLoading: _onLoading,
        //   //   child: _listViewmenu(),
        //   // ),
        // ),
      ],
    );
  }

  Profile profileBar() {
    return Profile(
      model: _futureProfile,
      organizationImage: _futureOrganizationImage,
      imageLv0: resultImageLv0,
      nav: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserInformationPage(),
          ),
        );
      },
      nav1: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationList(
              userData: userData,
              title: 'แจ้งเตือน',
            ),
          ),
        );
      },
    );
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    // print('------------------------$profileCode----------------------');
    if (profileCode != '' && profileCode != null) {
      _futureProfile = postDio(profileReadApi, {'code': profileCode});
      _futureOrganizationImage =
          postDio(organizationImageReadApi, {"code": profileCode});
      _futureVerify = postDio(organizationImageReadApi, {"code": profileCode});
    } else {
      logout(context);
    }

    var token = await storage.read(key: 'token');
    if (token != '' && token != null)
      postDio('${server}m/v2/register/token/create',
          {'token': token, 'profileCode': profileCode});

    var imageUrlSocial = await storage.read(key: 'profileImageUrl');
    if (imageUrlSocial != '' && imageUrlSocial != null) setState(() {});

    // print('-------------start response------------');
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

    // final result = await postObjectData("m/policy/read", {
    //   "category": "marketing",
    //   "username": data['username'],
    // });

    // if (result['status'] == 'S') {
    //   if (result['objectData'].length > 0) {
    //     setState(() {
    //       _dataPolicy = result['objectData'];
    //     });
    //   }
    // }

    setState(() {
      userData = User(
        username: data['username'] != '' ? data['username'] : '',
        password: data['password'] != '' ? data['password'].toString() : '',
        firstName: data['firstName'] != '' ? data['firstName'] : '',
        lastName: data['lastName'] != '' ? data['lastName'] : '',
        imageUrl: data['imageUrl'] != '' ? data['imageUrl'] : '',
        category: data['category'] != '' ? data['category'] : '',
        countUnit: data['countUnit'] != '' ? data['countUnit'] : '',
        address: data['address'] != '' ? data['address'] : '',
        status: data['status'] != '' ? data['status'] : '',
      );
    });

    if (value != '' && value != null) {
      // var api =
      //     data['category'] == 'guest' ? 'login' : data['category'] + '/login';

      // _futureProfile = postLogin(registerApi + api, {
      //   'category': data['category'],
      //   'username': data['username'],
      //   'password': data['password'],
      //   'email': data['email'],
      // });
    }

    _futureRotation =
        postDio('${mainRotationApi}read', {'skip': 0, 'limit': 10});
    _futureMenu = postDio('${menuApi}read', {'skip': 0, 'limit': 100});
    _futureBanner = postDio('${mainBannerApi}read', {'skip': 0, 'limit': 10});
    _futureMainPopUp =
        postDio('${mainPopupHomeApi}read', {'skip': 0, 'limit': 10});
    _futureKnowledge = postDio('${knowledgeApi}read', {
      'skip': 0,
      'limit': 10,
      'isHighlight': true,
      'category': '',
      'isPublic': userData.status == "N" ? true : false,
    });
    _futureNews = postDio('${newsApi}read', {
      'skip': 0,
      'limit': 10,
      'isHighlight': true,
      'category': '',
      'isPublic': userData.status == "N" ? true : false,
    });
    _futureEventCalendar = postDio('${eventCalendarApi}read', {
      'skip': 0,
      'limit': 10,
      'isHighlight': true,
      'category': '',
      'isPublic': userData.status == "N" ? true : false,
    });
    _futureContact = postDio('${contactApi}read', {
      'skip': 0,
      'limit': 10,
      // 'isHighlight': true,
      // 'category': '',
      // 'isPublic': userData.status == "N" ? true : false,
    });

    // getMainPopUp();
    _getLocation();
    getImageLv0();
    _callReadPolicy();
    // print('-------------end response------------');
  }

  getImageLv0() async {
    await storage.delete(key: 'imageLv0');
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
    var countUnit = json.decode(data['countUnit']);
    var rawLv0 = [];

    if (rawLv0.isEmpty) {
      countUnit
          .map((e) => {
                if (e['status'] != null)
                  {
                    if (e['status'] == 'A')
                      {
                        rawLv0.add(e['lv0'].toString()),
                      }
                  }
              })
          .toList();
    }

    unique = rawLv0.where((str) => seen.add(str)).toList();

    // ignore: avoid_function_literals_in_foreach_calls
    rawLv0.forEach((element) async {
      await postDio(server + 'organization/read', {'code': element})
          .then((value) => {
                if (value.length > 0) {imageLv0.add(value[0]['imageUrl'])}
              });
    });

    storage.write(
      key: 'imageLv0',
      value: jsonEncode(imageLv0),
    );
    var image0 = await storage.read(key: 'imageLv0');
    resultImageLv0 = json.decode(image0!);
    unique = [];
    imageLv0 = [];
  }

  getMainPopUp() async {
    var result =
        await postDio('${mainPopupHomeApi}read', {'skip': 0, 'limit': 100});

    if (result.length > 0) {
      var valueStorage = await storage.read(key: 'mainPopupLC');
      // ignore: prefer_typing_uninitialized_variables
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
              c['username'] == userData.username &&
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
                  username: userData.username,
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
                username: userData.username,
                url: '',
                urlGallery: '',
              ),
            );
          },
        );
      }
    }
  }

  getCurrentUserData() async {
    if (userData == null || userData.category == null) {
      return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }

    await postDio(registerApi + 'read', {
      "username": userData.username,
    }).then((data) => {
          if (userData.username == data[0]['username'])
            {
              storage.write(
                key: 'dataUserLoginLC',
                value: jsonEncode(data[0]),
              ),
              setState(() {
                userData = User(
                  username:
                      data[0]['username'] != '' ? data[0]['username'] : '',
                  password:
                      data[0]['password'] != '' ? data[0]['password'] : '',
                  firstName:
                      data[0]['firstName'] != '' ? data[0]['firstName'] : '',
                  lastName:
                      data[0]['lastName'] != '' ? data[0]['lastName'] : '',
                  imageUrl:
                      data[0]['imageUrl'] != '' ? data[0]['imageUrl'] : '',
                  category:
                      data[0]['category'] != '' ? data[0]['category'] : '',
                  countUnit:
                      data[0]['countUnit'] != '' ? data[0]['countUnit'] : '',
                  address: data[0]['address'] != '' ? data[0]['address'] : '',
                  status: data[0]['status'] != '' ? data[0]['status'] : '',
                );
              })
            }
        });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // getCurrentUserData();
    _getLocation();
    _callRead();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    // _refreshController.loadComplete();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
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
                  builder: (context) => const Menu(),
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
  //.end

  _listViewmenu() {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxScrolled) => [
        SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 190,
          pinned: !true,
          floating: !true,
          snap: !true,
          flexibleSpace: _header(),
        ),
      ],
      body: SmartRefresher(
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
        onLoading: _onLoading,
        child: ListView(
          children: [
            // _header(),
            // CarouselBanner(
            //   model: _futureBanner,
            //   nav: (String path, String action, dynamic model, String code,
            //       String urlGallery) {
            //     if (action == 'out') {
            //       launchInWebViewWithJavaScript(path);
            //       // launchURL(path);
            //     } else if (action == 'in') {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => CarouselForm(
            //             code: code,
            //             model: model,
            //             url: mainBannerApi,
            //             urlGallery: bannerGalleryApi,
            //           ),
            //         ),
            //       );
            //     }
            //   },
            // ),
            // _buildCurrentLocationBar(),
            // SmartRefresher(
            //   enablePullDown: false,
            //   enablePullUp: false,
            //   header: WaterDropHeader(
            //     complete: Container(
            //       child: Text(''),
            //     ),
            //     completeDuration: Duration(milliseconds: 0),
            //   ),
            //   controller: _refreshController,
            //   onRefresh: _onRefresh,
            //   onLoading: _onLoading,
            //   child: ListView(
            //     children: [],
            //   ),
            // ),

            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 27),
            //   child: Row(
            //     children: [
            //       Text(
            //         'ใบประกอบของท่านสามารถใช้ได้ถึงวันที่ : ',
            //         style: TextStyle(
            //           fontSize: 8,
            //           color: Color(0xFF000000),
            //         ),
            //         // textAlign: TextAlign.center,
            //       ),
            //       Text(
            //         'n/a',
            //         style: TextStyle(
            //             fontSize: 10,
            //             color: Color(0xFF000000),
            //             fontWeight: FontWeight.bold),
            //         // textAlign: TextAlign.center,
            //       ),
            //     ],
            //   ),
            // ),
            BuildGrid(
              model: _futureContact,
              menuModel: _futureMenu,
              userData: userData,
            ),
            const SizedBox(
              height: 5.0,
            ),
            BuildNews(
              model: _futureNews,
              menuModel: _futureMenu,
            ),
            const SizedBox(
              height: 5,
            ),
            CarouselRotation(
              model: _futureRotation,
              nav: (String path, String action, dynamic model, String code) {
                if (action == 'out') {
                  launchInWebViewWithJavaScript(path);
                  // launchURL(path);
                } else if (action == 'in') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarouselForm(
                        code: code,
                        model: model,
                        url: mainBannerApi,
                        urlGallery: bannerGalleryApi,
                      ),
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 5.0,
            ),
            BuildEventCalendar(
              model: _futureEventCalendar,
              menuModel: _futureMenu,
            ),
            const SizedBox(
              height: 5.0,
            ),
            BuildKnowledge(
              model: _futureKnowledge,
              menuModel: _futureMenu,
            ),
            const SizedBox(
              height: 5.0,
            ),
            BuildAboutUs(
              // model: _futureAboutUs,
              menuModel: _futureMenu, model: null,
            ),
            const SizedBox(height: 5),
            // InkWell(
            //   onTap: () {
            //     logout(context);
            //   },
            //   child: Container(
            //     height: 100,
            //     alignment: Alignment.center,
            //     child: Text(
            //       '1.0.4',
            //       style: TextStyle(fontSize: 8),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: status == 'N' ? 135.0 : 5,
            // )
          ],
        ),
      ),
    );
  }

  _header() {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: 200.0 + MediaQuery.of(context).padding.top - 15,
          child: CarouselBanner(
            isHideRow: true,
            height: 200,
            model: _futureBanner,
            nav: (String path, String action, dynamic model, String code,
                String urlGallery) {
              if (action == 'out') {
                if (model['isPostHeader'] ?? false) {
                  if (profileCode != '') {
                    var splitCheck = path.split('').reversed.join();
                    if (splitCheck[0] != "/") {
                      path = path + "/";
                    }
                    var codeReplae = "B" +
                        profileCode.replaceAll('-', '') +
                        code.replaceAll('-', '');
                    launchInWebViewWithJavaScript('$path$codeReplae');
                    // launchURL('$path$codeReplae');
                  }
                } else
                  launchInWebViewWithJavaScript(path);
                // launchURL(path);
              } else if (action == 'in') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarouselForm(
                      code: code,
                      model: model,
                      url: mainBannerApi,
                      urlGallery: bannerGalleryApi,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 50, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInformationPage(),
                    ),
                  );
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FutureBuilder<dynamic>(
                      future: _futureProfile,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return loadingImageNetwork(
                            snapshot.data['imageUrl'],
                            fit: BoxFit.fill,
                            isProfile: true,
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),

                    // loadingImageNetwork(
                    //   _imageUrl,
                    //   fit: BoxFit.fill,
                    //   isProfile: true,
                    // ),
                  ),
                ),
              )
            ],
          ),
        ),
        // Container(
        //   padding: EdgeInsets.only(
        //     top: 200,
        //   ),
        //   child: BuildGrid(
        //     model: _futureContact,
        //     menuModel: _futureMenu,
        //     userData: userData,
        //   ),
        // ),
        Positioned(
          // bottom: 0,
          child: Container(
            alignment: Alignment.center,
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            // height: 90.0,
            margin: const EdgeInsets.only(top: 150),
            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(45), color: Colors.white70),
            child: Container(
              // color: Colors.red,
              height: 40,
              margin: const EdgeInsets.only(top: 7),
              // child: KeySearch(),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchListPage(),
                    ),
                  );
                },
                child: Container(
                  // height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: const Color(0XFF216DA6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // _buildCurrentLocationBar(),
                      const Text(
                        'ใส่คำที่ต้องการค้นหา ...',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 13,
                          color: Color(0xFF707070),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 25,
                        color: Colors.transparent,
                        child: Image.asset(
                          'assets/images/search.png',
                          height: 18.0,
                          width: 18.0,
                          color: const Color(0xFF216DA6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                padding: const EdgeInsets.only(right: 20, left: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(48.0),
                      bottomRight: Radius.circular(48.0)),
                  color: Color(0xFF011895),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    'สภาทนายความ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFFFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )),
        ),
      ],
    );
  }
}
