import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lc/pages/main_popup/dialog_main_popup.dart';
import 'package:lc/pages/privilege/privilege_list.dart';
// import 'package:lc/pages/privilege/privilege_list_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:lc/v3/privilege_v3/list_content_horizontal_privilege_v3.dart';
import 'package:lc/v3/privilege_v3/privilege_form_v3.dart';
import 'package:lc/v3/privilege_v3/privilege_list_vertical_v3.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';

import '../../component/loadingImageNetwork.dart';
import '../../shared/extension.dart';

class PrivilegeMainV3 extends StatefulWidget {
  PrivilegeMainV3(
      {Key? key, required this.title, this.fromPolicy, this.checkShowDialog})
      : super(key: key);
  final String title;
  final bool? fromPolicy;
  final bool? checkShowDialog;

  @override
  _PrivilegeMainV3 createState() => _PrivilegeMainV3();
}

class _PrivilegeMainV3 extends State<PrivilegeMainV3>
    with TickerProviderStateMixin {
  final storage = new FlutterSecureStorage();

  late PrivilegeList privilegeList;
  late PrivilegeListVerticalV3 gridView;
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
  int _carouselIndex = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool _showSearch = false;
  late AnimationController _animationSearchController;
  TextEditingController _searchController = new TextEditingController();
  bool _isSearch = false;

  @override
  void initState() {
    _animationSearchController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
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

  InputDecoration _decorationSearch(context, {String hintText = ''}) =>
      InputDecoration(
        // label: Text(hintText),
        // labelStyle: const TextStyle(
        //   color: Color(0xFF707070),
        //   fontSize: 12,
        // ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _isSearch = true;
              _showSearch = false;
              _limit = 0;
            });
            _onLoading();
          },
          child: Container(
            padding: EdgeInsets.all(3),
            child: Image.asset(
              'assets/images/search.png',
              color: Color(0x802D9CED),
            ),
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              if (_searchController.text == '') {
                _isSearch = false;
                _showSearch = false;
              } else {
                _searchController = TextEditingController(text: '');
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(3),
            child: _searchController.text == ''
                ? Icon(
                    Icons.arrow_back,
                    color: Color(0xFF2D9CED),
                    size: 16,
                  )
                : Image.asset(
                    'assets/images/close_noti_list.png',
                    color: Color(0x802D9CED),
                  ),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(6.0, 1.0, 1.0, 1.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

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
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color(0x408AD2FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF2D9CED),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
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
        ),
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
                SizedBox(
                  height: 5.0,
                ),

                tabCategory(),
                SizedBox(
                  height: 10.0,
                ),
                // KeySearch(
                //   show: hideSearch,
                //   onKeySearchChange: (String val) {
                //     setState(() {
                //       keySearch = val;
                //     });
                //   },
                // ),
                // SizedBox(
                //   height: 10.0,
                // ),
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    footer: ClassicFooter(
                      loadingText: ' ',
                      canLoadingText: ' ',
                      idleText: ' ',
                      idleIcon:
                          Icon(Icons.arrow_upward, color: Colors.transparent),
                    ),
                    controller: _refreshController,
                    onLoading: _onLoading,
                    child: _searchController.text == ''
                        ? isMain
                            ? ListView(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(), // 2nd

                                children: [
                                  // ListContentHorizontalPrivilegeSuggestedV3(
                                  //   // title: 'แนะนำ111',
                                  //   url: privilegeApi + 'read',
                                  //   model: _futurePromotion,
                                  //   urlComment: '',
                                  //   navigationList: () {
                                  //     setState(() {
                                  //       _searchController.text = '';
                                  //       isMain = false;
                                  //       categorySelected = '';
                                  //     });
                                  //   },
                                  //   navigationForm: (
                                  //     String code,
                                  //     dynamic model,
                                  //   ) {
                                  //     Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //         builder: (context) => PrivilegeFormV3(
                                  //           code: code,
                                  //           model: model,
                                  //           urlRotation: rotationPrivilegeApi,
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
                                  _buildHighlight(),
                                  for (int i = 0; i < listData.length; i++)
                                    new ListContentHorizontalPrivilegeV3(
                                      code: category[i]['code'],
                                      title: category[i]['title'],
                                      model: listData[i],
                                      navigationList: () {
                                        setState(() {
                                          _searchController.text = '';
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
                                            builder: (context) =>
                                                PrivilegeFormV3(
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
                SizedBox(
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
    return SizedBox(
      // height: 25,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              setState(() {
                _showSearch = !_showSearch;
              });
            },
            child: AnimatedContainer(
              height: 25,
              width: _showSearch ? MediaQuery.of(context).size.width * 0.7 : 25,
              duration: _animationSearchController.duration ??
                  Duration(milliseconds: 500),
              curve: Curves.easeIn,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0x408AD2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _showSearch
                  ? TextFormField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _isSearch = true;
                          _showSearch = false;
                          _limit = 0;
                        });
                        _onLoading();
                      },
                      style: const TextStyle(
                        color: Color(0xFF2D9CED),
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                        fontSize: 15.0,
                      ),
                      decoration: _decorationSearch(
                        context,
                        hintText: 'ค้นหา',
                      ),
                      validator: (model) {
                        if (model!.isEmpty) {
                          return 'กรุณากรอกวันเดือนปีเกิด.';
                        }
                        return null;
                      },
                    )
                  : Image.asset(
                      'assets/images/search.png',
                      color: Color(0x802D9CED),
                      height: 15,
                      width: 15,
                    ),
            ),
          ),
          Expanded(
            child: FutureBuilder<dynamic>(
              future: postCategory(
                '${privilegeCategoryApi}read',
                {'skip': 0, 'limit': 100},
              ), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                // AsyncSnapshot<Your object type>

                if (snapshot.hasData) {
                  return Container(
                    height: 45.0,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (snapshot.data[index]['code'] != '') {
                              setState(() {
                                _searchController.text = '';
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
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 10.0,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.5)),
                                color: categorySelected ==
                                        snapshot.data[index]['code']
                                    ? Color(0xFF2D9CED)
                                    : Color(0xFF8AD2FF).withOpacity(.15),
                              ),
                              child: Text(
                                snapshot.data[index]['title'],
                                style: TextStyle(
                                  color: categorySelected ==
                                          snapshot.data[index]['code']
                                      ? Colors.white
                                      : Color(0xFF2D9CED).withOpacity(.50),
                                  // decoration:
                                  //     categorySelected == snapshot.data[index]['code']
                                  //         ? TextDecoration.underline
                                  //         : null,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 1,
                                  fontFamily: 'Kanit',
                                ),
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
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: new BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
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
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(''),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: TextStyle(
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

  Widget _buildHighlight() {
    return FutureBuilder(
      future: _futurePromotion,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.width - 30 + 37,
                width: double.infinity,
                child: CarouselSlider(
                  items: snapshot.data
                      .take(10)
                      .map<Widget>((e) => _buildHighlightItem(e))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 1,
                    viewportFraction: 1,
                    onPageChanged: (i, value) {
                      setState(() {
                        _carouselIndex = i;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: snapshot.data.take(10).map<Widget>(
                    (e) {
                      int index = snapshot.data.indexOf(e);
                      bool thisCarousel = _carouselIndex == index;
                      return Container(
                        width: thisCarousel ? 17.5 : 7,
                        height: 7,
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color:
                              thisCarousel ? Color(0xFF8AD2FF) : Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Color(0xFF8AD2FF),
                          ),
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildHighlightItem(dynamic model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PrivilegeFormV3(
              code: model['code'],
              model: model,
              urlRotation: rotationPrivilegeApi,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0x268AD2FF),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: loadingImageNetwork(
                model['imageUrl'],
                height: MediaQuery.of(context).size.width - 30,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 15,
            right: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 98,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0x99FFFFFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model['title']}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${model['createDate']}' != null
                            ? dateStringToDate('${model['createDate']}')
                            : '',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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
    if (result != null && result.isNotEmpty) {
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

      gridView = new PrivilegeListVerticalV3(
        site: 'CIO',
        model: postDio('${privilegeApi}read', {
          'skip': 0,
          'limit': _limit,
        }),
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  reloadList() {
    return gridView = new PrivilegeListVerticalV3(
      site: 'LC',
      model: postDio('${privilegeApi}read', {
        'skip': 0,
        'limit': _limit,
        'keySearch':
            _searchController.text != null ? _searchController.text : '',
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
