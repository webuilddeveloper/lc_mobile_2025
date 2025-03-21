import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:lc/component/key_search.dart';
import 'package:lc/pages/training/training_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TrainingListV3 extends StatefulWidget {
  const TrainingListV3({super.key, this.title, this.isCategory});
  final String? title;
  final bool? isCategory;
  @override
  _TrainingListV3 createState() => _TrainingListV3();
}

class _TrainingListV3 extends State<TrainingListV3>
    with TickerProviderStateMixin {
  late TrainingListV3 trainingList;
  bool hideSearch = true;
  List<dynamic> listData = [];
  List<dynamic> category = [];
  bool isMain = true;
  String categorySelected = '';
  String keySearch = '';
  bool isHighlight = false;
  int _limit = 10;
  late Future futureModel;
  bool _showSearch = false;
  late AnimationController _animationSearchController;
  TextEditingController _searchController = TextEditingController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _animationSearchController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    futureModel = postDioMessage('${trainingApi}read', {
      'skip': 0,
      'limit': _limit,
      'keySearch': keySearch,
      'isHighlight': isHighlight,
      'category': categorySelected
    });
    categoryRead();
    super.initState();
  }

  Future<dynamic> categoryRead() async {
    var response = await postDio('${trainingCategoryApi}read',
        {"permission": "all", "skip": 0, "limit": 999});

    setState(() {
      category = response;
    });

    if (category.isNotEmpty) {
      for (int i = 0; i <= category.length - 1; i++) {
        var res = post('${trainingApi}read', {
          'skip': 0,
          'limit': 100,
          'category': category[i]['code'],
          'keySearch': keySearch
        });
        listData.add(res);
      }
    }
  }

  reloadList() {
    return TrainingListVertical(
      model: futureModel,
      urlGallery: trainingGalleryApi,
      urlComment: trainingCommentApi,
      url: '${trainingApi}read',
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      futureModel = postDio('${trainingApi}read', {
        'skip': 0,
        'limit': _limit,
        'keySearch': _searchController.text,
        'isHighlight': isHighlight,
        'category': categorySelected
      });
    });

    await Future.delayed(const Duration(milliseconds: 10000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  //  tabCategory() {
  //   return FutureBuilder<dynamic>(
  //     future: postCategory(
  //       '${trainingCategoryApi}read',
  //       {'skip': 0, 'limit': 100},
  //     ), // function where you call your api
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       // AsyncSnapshot<Your object type>

  //       if (snapshot.hasData) {
  //         return
  //         Container(
  //           height: 45.0,
  //           padding: EdgeInsets.only(left: 5.0, right: 5.0),
  //           margin: EdgeInsets.symmetric(horizontal: 10.0),
  //           decoration: new BoxDecoration(
  //             // boxShadow: [
  //             //   BoxShadow(
  //             //     color: Colors.grey.withOpacity(0.5),
  //             //     spreadRadius: 0,
  //             //     blurRadius: 7,
  //             //     offset: Offset(0, 3), // changes position of shadow
  //             //   ),
  //             // ],
  //             borderRadius: new BorderRadius.circular(6.0),
  //             color: Colors.white,
  //           ),
  //           child:
  //           ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: snapshot.data.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return GestureDetector(
  //                 onTap: () {
  //                   if (snapshot.data[index]['code'] != '') {
  //                     setState(() {
  //                       categorySelected = snapshot.data[index]['code'];
  //                     });
  //                   } else {
  //                     setState(() {
  //                       categorySelected = '';
  //                       isMain = true;
  //                     });
  //                   }
  //                   _onLoading();
  //                 },
  //                 child:
  //                 Padding(
  //                     padding: EdgeInsets.symmetric(
  //                       horizontal: 5.0,
  //                       vertical: 10.0,
  //                     ),
  //                     child: Container(
  //                       alignment: Alignment.center,
  //                       padding: EdgeInsets.symmetric(horizontal: 15),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.all(Radius.circular(12.5)),
  //                         color: categorySelected == snapshot.data[index]['code']
  //                               ? Color(0xFF2D9CED)
  //                               : Color(0xFF8AD2FF).withOpacity(.15),
  //                       ),
  //                       child: Text(
  //                         snapshot.data[index]['title'],
  //                         style: TextStyle(
  //                           color: categorySelected == snapshot.data[index]['code']
  //                               ? Colors.white
  //                               : Color(0xFF2D9CED).withOpacity(.50),
  //                           // decoration:
  //                           //     categorySelected == snapshot.data[index]['code']
  //                           //         ? TextDecoration.underline
  //                           //         : null,
  //                           fontSize: 13.0,
  //                           fontWeight: FontWeight.normal,
  //                           letterSpacing: 1,
  //                           fontFamily: 'Kanit',
  //                         ),
  //                       ),
  //                     ),
  //                   ),

  //               );
  //             },
  //           ),
  //         );
  //       } else {
  //         return Container(
  //           height: 45.0,
  //           padding: EdgeInsets.only(left: 5.0, right: 5.0),
  //           margin: EdgeInsets.symmetric(horizontal: 30.0),
  //           decoration: new BoxDecoration(
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.5),
  //                 spreadRadius: 0,
  //                 blurRadius: 7,
  //                 offset: Offset(0, 3), // changes position of shadow
  //               ),
  //             ],
  //             borderRadius: new BorderRadius.circular(6.0),
  //             color: Colors.white,
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

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
                  ? TextFormField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          // _showSearch = false;
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
                      color: const Color(0x802D9CED),
                      height: 15,
                      width: 15,
                    ),
            ),
          ),
          Expanded(
            child: FutureBuilder<dynamic>(
              future: postCategory(
                '${trainingCategoryApi}read',
                {'skip': 0, 'limit': 100},
              ),
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
                          // onTap: () {
                          //   if (snapshot.data[index]['code'] != '') {
                          //     setState(() {
                          //       _searchController.text = '';
                          //       isMain = false;
                          //       isHighlight = false;
                          //       categorySelected = snapshot.data[index]['code'];
                          //     });
                          //   } else {
                          //     setState(() {
                          //       isHighlight = true;
                          //       categorySelected = '';
                          //       isMain = true;
                          //     });
                          //   }
                          //   setState(() {
                          //     categorySelected = snapshot.data[index]['code'];
                          //     // selectedIndex = index;
                          //   });
                          // },
                          onTap: () {
                            if (snapshot.data[index]['code'] != '') {
                              setState(() {
                                categorySelected = snapshot.data[index]['code'];
                              });
                            } else {
                              setState(() {
                                categorySelected = '';
                                isMain = true;
                              });
                            }
                            _onLoading();
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
        // appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
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
                // KeySearch(
                //   show: hideSearch,
                //   onKeySearchChange: (String val) {
                //     setState(() {
                //       keySearch = val;
                //     });
                //   },
                // ),
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
                    child: TrainingListVertical(
                      model: futureModel,
                      urlGallery: trainingGalleryApi,
                      urlComment: trainingCommentApi,
                      url: '${trainingApi}read',
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
}
