import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lc/component/header.dart';
import 'package:lc/component/key_search.dart';
import 'package:lc/pages/main_popup/dialog_main_popup.dart';
import 'package:lc/pages/privilege/list_content_horizontal_privilege.dart';
import 'package:lc/pages/privilege/list_content_horizontal_privlege_suggested.dart';
import 'package:lc/pages/privilege/privilege_form.dart';
import 'package:lc/pages/privilege/privilege_list.dart';
import 'package:lc/pages/privilege/privilege_list_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';

class PrivilegeMain extends StatefulWidget {
  PrivilegeMain(
      {Key? key, required this.title, this.fromPolicy, this.checkShowDialog})
      : super(key: key);
  final String title;
  final bool? fromPolicy;
  final bool? checkShowDialog;

  @override
  _PrivilegeMain createState() => _PrivilegeMain();
}

class _PrivilegeMain extends State<PrivilegeMain> {
  final storage = new FlutterSecureStorage();

  late PrivilegeList privilegeList;
  late PrivilegeListVertical gridView;
  bool hideSearch = true;
  late Future<dynamic> _futurePromotion;
  late Future<dynamic> _futurePrivilegeCategory;
  late Future<dynamic> _futureForceAds;

  List<dynamic> listData = [];
  List<dynamic> category = [];
  bool isMain = true;
  String categorySelected = '';
  String keySearch = '';
  bool isHighlight = false;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _futurePromotion = postDio(
        '${privilegeApi}read', {'skip': 0, 'limit': 10, 'isHighlight': true});
    _futurePrivilegeCategory =
        postDio('${privilegeCategoryApi}read', {'skip': 0, 'limit': 100});
    _futureForceAds = postDio('${forceAdsApi}read', {'skip': 0, 'limit': 10});
    categoryRead();
    getForceAds();
    // if (widget.checkShowDialog) {
    //   openDialog();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              children: [
                const SizedBox(
                  height: 5.0,
                ),
                tabCategory(),
                const SizedBox(
                  height: 10.0,
                ),
                KeySearch(
                  show: hideSearch,
                  onKeySearchChange: (String val) {
                    setState(() {
                      keySearch = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    footer: const ClassicFooter(
                      loadingText: ' ',
                      canLoadingText: ' ',
                      idleText: ' ',
                      idleIcon:
                          Icon(Icons.arrow_upward, color: Colors.transparent),
                    ),
                    controller: _refreshController,
                    onLoading: _onLoading,
                    child: keySearch == ''
                        ? isMain
                            ? ListView(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(), // 2nd
                                children: [
                                  ListContentHorizontalPrivilegeSuggested(
                                    title: 'แนะนำ',
                                    url: privilegeApi + 'read',
                                    model: _futurePromotion,
                                    urlComment: '',
                                    navigationList: () {
                                      setState(() {
                                        keySearch = '';
                                        isMain = false;
                                        categorySelected = '';
                                      });
                                    },
                                    navigationForm: (
                                      String code,
                                      dynamic model,
                                    ) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PrivilegeForm(
                                            code: code,
                                            model: model,
                                            urlRotation: rotationPrivilegeApi,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  for (int i = 0; i < listData.length; i++)
                                    new ListContentHorizontalPrivilege(
                                      code: category[i]['code'],
                                      title: category[i]['title'],
                                      model: listData[i],
                                      navigationList: () {
                                        setState(() {
                                          keySearch = '';
                                          isMain = false;
                                          categorySelected =
                                              category[i]['code'];
                                        });
                                      },
                                      navigationForm: (
                                        String code,
                                        dynamic model,
                                      ) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PrivilegeForm(
                                              code: code,
                                              model: model,
                                              urlRotation: rotationPrivilegeApi,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              )
                            : reloadList()
                        : reloadList(),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  tabCategory() {
    return FutureBuilder<dynamic>(
      future: postCategory(
        '${privilegeCategoryApi}read',
        {'skip': 0, 'limit': 100},
      ), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (snapshot.data[index]['code'] != '') {
                      setState(() {
                        keySearch = '';
                        isMain = false;
                        isHighlight = false;
                        categorySelected = snapshot.data[index]['code'];
                      });
                    } else {
                      setState(() {
                        isHighlight = true;
                        categorySelected = '';
                        isMain = true;
                      });
                    }
                    setState(() {
                      categorySelected = snapshot.data[index]['code'];
                      // selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      snapshot.data[index]['title'],
                      style: TextStyle(
                        color: categorySelected == snapshot.data[index]['code']
                            ? Colors.black
                            : Colors.grey,
                        decoration:
                            categorySelected == snapshot.data[index]['code']
                                ? TextDecoration.underline
                                : null,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  openDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: new CupertinoAlertDialog(
              title: new Text(
                'บันทึกข้อมูลเรียบร้อย',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: const Text(''),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF9A1120),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Future<dynamic> showForceAds() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    var valueStorage = await storage.read(key: 'privilegeLC');
    var dataValue;
    if (valueStorage != null) {
      dataValue = json.decode(valueStorage);
    } else {
      dataValue = null;
    }

    var now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);

    if (dataValue != null) {
      var index = dataValue.indexWhere(
        (c) =>
            c['username'] == user['username'] &&
            c['date'] == DateFormat("ddMMyyyy").format(date).toString() &&
            c['boolean'] == "true",
      );

      if (index == -1) {
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: MainPopupDialog(
                model: _futureForceAds,
                type: 'privilege',
                username: user['username'],
                url: '',
                urlGallery: '',
              ),
            );
          },
        );
      }
    } else {
      return showDialog(
        barrierDismissible: false, // close outside
        context: context,
        builder: (_) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: MainPopupDialog(
              model: _futureForceAds,
              type: 'privilege',
              username: user['username'],
              url: '',
              urlGallery: '',
            ),
          );
        },
      );
    }
  }

  getForceAds() async {
    var result = await post('${forceAdsApi}read', {'skip': 0, 'limit': 100});
    if (result.length > 0) {
      showForceAds();
    }
  }

  Future<dynamic> categoryRead() async {
    var body = json.encode({
      "permission": "all",
      "skip": 0,
      "limit": 999 // integer value type
    });
    var response = await http.post(Uri.parse(privilegeCategoryApi + 'read'),
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });

    var data = json.decode(response.body);
    setState(() {
      category = data['objectData'];
    });

    if (category.length > 0) {
      for (int i = 0; i <= category.length - 1; i++) {
        var res = postDio('${privilegeApi}read',
            {'skip': 0, 'limit': 10, 'category': category[i]['code']});
        listData.add(res);
      }
    }
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      gridView = new PrivilegeListVertical(
        site: 'CIO',
        model: postDio('${privilegeApi}read', {
          'skip': 0,
          'limit': _limit,
        }),
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  reloadList() {
    return gridView = new PrivilegeListVertical(
      site: 'LC',
      model: postDio('${privilegeApi}read', {
        'skip': 0,
        'limit': _limit,
        'keySearch': keySearch != null ? keySearch : '',
        'isHighlight': isHighlight != null ? isHighlight : false,
        'category': categorySelected != null ? categorySelected : ''
      }),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
    // if (widget.fromPolicy) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => MenuV2(),
    //     ),
    //     (Route<dynamic> route) => false,
    //   );
    // } else {
    //   Navigator.pop(context, false);
    // }
  }
}
