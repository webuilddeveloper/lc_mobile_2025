import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lc/component/key_search.dart';
import 'package:lc/pages/training/training_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TrainingList extends StatefulWidget {
  const TrainingList({super.key, required this.title, required this.isCategory});
  final String title;
  final bool isCategory;
  @override
  // ignore: library_private_types_in_public_api
  _TrainingList createState() => _TrainingList();
}

class _TrainingList extends State<TrainingList> {
  late TrainingList trainingList;
  bool hideSearch = true;
  List<dynamic> listData = [];
  List<dynamic> category = [];
  bool isMain = true;
  String categorySelected = '';
  String keySearch = '';
  bool isHighlight = false;
  int _limit = 10;
  late Future futureModel;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
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
    var response = await postDio(trainingCategoryApi + 'read',
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
        'keySearch': keySearch,
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

  FutureBuilder<dynamic> tabCategory() {
    return FutureBuilder<dynamic>(
      future: postCategory(
        '${trainingCategoryApi}read',
        {'skip': 0, 'limit': 100},
      ), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(6.0),
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
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
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
