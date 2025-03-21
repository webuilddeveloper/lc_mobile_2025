import 'package:flutter/material.dart';
import 'package:lc/pages/blank_page/blank_data.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widget/header_v3.dart';
import 'apply_exam_card_v3.dart';

class ApplyExamListV3 extends StatefulWidget {
  const ApplyExamListV3({super.key, this.title, this.isCategory = false});

  final String? title;
  final bool? isCategory;

  @override
  // ignore: library_private_types_in_public_api
  _ApplyExamListV3 createState() => _ApplyExamListV3();
}

class _ApplyExamListV3 extends State<ApplyExamListV3>
    with TickerProviderStateMixin {
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category = "";
  int _limit = 10;
  bool _showSearch = false;
  late AnimationController _animationSearchController;
  TextEditingController _searchController = TextEditingController();
  bool _isSearch = false;
  bool isMain = true;
  String categorySelected = '';
  bool isHighlight = false;

  late Future<dynamic> futureModel;
  late Future<dynamic> futureCategory;
  List<dynamic> listTemp = [
    {
      'code': '',
      'title': '',
      'imageUrl': '',
      'createDate': '',
      'userList': [
        {'imageUrl': '', 'firstName': '', 'lastName': ''}
      ]
    }
  ];
  bool showLoadingItem = true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationSearchController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();

    futureModel = postDio('${applyExamApi}read', {
      'skip': 0,
      'limit': _limit,
      "category": category,
      "isCategory": widget.isCategory,
      // "keySearch": keySearch
    });

    futureCategory = postDioCategory(
      '${applyExamCategoryApi}read',
      {
        'skip': 0,
        'limit': 100,
        "isCategory": widget.isCategory,
      },
    );
  }

  reloadList() {
    setState(() {
      futureModel = postDio('${applyExamApi}read', {
        'skip': 0,
        'limit': _limit,
        "category": categorySelected,
        "isCategory": widget.isCategory,
        "keySearch": _searchController.text,
      });
    });
  }

  void _onLoading() async {
    setState(() {
      showLoadingItem = true;
      _limit = _limit + 10;

      futureModel = postDio('${applyExamApi}read', {
        'skip': 0,
        'limit': _limit,
        "category": categorySelected,
        "isCategory": widget.isCategory,
        // "keySearch": keySearch
      });
    });

    await Future.delayed(const Duration(milliseconds: 2000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: headerV3(context, goBack, title: widget.title!),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                const SizedBox(height: 5),
                // CategorySelector(
                //   model: futureCategory,
                //   onChange: (String val) {
                //     setData(val, keySearch);
                //   },
                // ),
                tabCategory(),
                // SizedBox(height: 5),
                // KeySearch(
                //   show: hideSearch,
                //   onKeySearchChange: (String val) {
                //     setData(category, val);
                //   },
                // ),
                const SizedBox(height: 10),
                Expanded(
                  child: buildApplyExamList(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder buildApplyExamList() {
    return FutureBuilder<dynamic>(
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (showLoadingItem) {
            return blankListData(context, height: 300);
          } else {
            return refreshList(listTemp);
          }
        } else if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                showLoadingItem = false;
                listTemp = snapshot.data;
              });
            });
            return refreshList(snapshot.data);
          } else {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: const Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Colors.grey,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          // return dialogFail(context);
          return InkWell(
            onTap: () {
              setState(() {
                futureModel = postDio('${applyExamApi}read', {
                  'skip': 0,
                  'limit': _limit,
                  "category": category,
                  "isCategory": widget.isCategory,
                  "keySearch": keySearch
                });
              });
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 50.0, color: Colors.blue),
                Text('ลองใหม่อีกครั้ง')
              ],
            ),
          );
        } else {
          return refreshList(listTemp);
        }
      },
    );
  }

  SmartRefresher refreshList(List<dynamic> model) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      footer: const ClassicFooter(
        loadingText: ' ',
        canLoadingText: ' ',
        idleText: ' ',
        idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
      ),
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return newsCardV3(context, model[index]);
        },
      ),
    );
  }

  setData(String category, String keySearkch) {
    setState(
      () {
        if (keySearch != "") {
          showLoadingItem = true;
        }
        keySearch = keySearkch;
        _limit = 10;
        futureModel = postDio('${applyExamApi}read', {
          'skip': 0,
          'limit': _limit,
          "category": category,
          "isCategory": widget.isCategory,
          "keySearch": keySearch
        });
      },
    );
  }

  tabCategory() {
    return SizedBox(
      // height: 25,
      width: double.infinity,
      child: Row(
        children: [
          const SizedBox(width: 15),
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
                  const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0x408AD2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _showSearch
                  ? TextField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,

                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _isSearch = true;
                          _showSearch = true;
                          _limit = 0;
                        });
                        setData(category, _searchController.text);
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
                      // validator: (model) {
                      //   if (model.isEmpty) {
                      //     return 'กรุณากรอกวันเดือนปีเกิด.';
                      //   }
                      //   return null;
                      // },
                    )
                  : Image.asset(
                      'assets/images/search.png',
                      color: const Color(0x802D9CED),
                      height: 15,
                      width: 15,
                    ),
            ),
          ),
          // SizedBox(width: 5),
          //   Expanded(
          //     child: FutureBuilder(
          //       future: postCategory(
          //   '${privilegeCategoryApi}read',
          //   {'skip': 0, 'limit': 100},
          // ), // fun,
          //       builder: (_, snapshot) {
          //         if (snapshot.hasData) {
          //           return ListView.separated(
          //             padding: EdgeInsets.only(right: 15),
          //             physics: ClampingScrollPhysics(),
          //             scrollDirection: Axis.horizontal,
          //             itemBuilder: (_, __) =>
          //                 _buildItemCategory(snapshot.data[__]),
          //             separatorBuilder: (_, __) => const SizedBox(width: 10),
          //             itemCount: snapshot.data.length,
          //           );
          //         } else {
          //           return const SizedBox();
          //         }
          //       },
          //     ),
          //   ),

          Expanded(
            child: FutureBuilder<dynamic>(
              future: postCategory(
                '${applyExamCategoryApi}read',
                {'skip': 0, 'limit': 100},
              ), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                // AsyncSnapshot<Your object type>

                if (snapshot.hasData) {
                  return Container(
                    height: 45.0,
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              // futureModel = postDio('${applyExamApi}read', {
                              //   'skip': 0,
                              //   'limit': 10,
                              //   "category": categorySelected,
                              //   "isCategory": widget.isCategory,

                              // });
                              // reloadList();
                              // selectedIndex = index;
                              _onLoading();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 10.0,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.5)),
                                color: categorySelected ==
                                        snapshot.data[index]['code']
                                    ? const Color(0xFF2D9CED)
                                    : const Color(0xFF8AD2FF).withOpacity(.15),
                              ),
                              child: Text(
                                snapshot.data[index]['title'],
                                style: TextStyle(
                                  color: categorySelected ==
                                          snapshot.data[index]['code']
                                      ? Colors.white
                                      : const Color(0xFF2D9CED)
                                          .withOpacity(.50),
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
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(6.0),
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
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              'assets/images/search.png',
              color: const Color(0x802D9CED),
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
            padding: const EdgeInsets.all(3),
            child: _searchController.text == ''
                ? const Icon(
                    Icons.arrow_back,
                    color: Color(0xFF2D9CED),
                    size: 16,
                  )
                : Image.asset(
                    'assets/images/close_noti_list.png',
                    color: const Color(0x802D9CED),
                  ),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(6.0, 1.0, 1.0, 1.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );
}
