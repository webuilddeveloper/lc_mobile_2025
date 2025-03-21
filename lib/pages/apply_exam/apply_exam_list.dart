import 'package:flutter/material.dart';
import 'package:lc/component/key_search.dart';
import 'package:lc/component/header.dart';
import 'package:lc/component/tab_category.dart';
import 'package:lc/pages/blank_page/blank_data.dart';
import 'package:lc/pages/apply_exam/apply_exam_card.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ApplyExamList extends StatefulWidget {
  const ApplyExamList({super.key, required this.title, this.isCategory = false});

  final String title;
  final bool isCategory;

  @override
  // ignore: library_private_types_in_public_api
  _ApplyExamList createState() => _ApplyExamList();
}

class _ApplyExamList extends State<ApplyExamList> {
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;

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
    super.initState();

    futureModel = postDio('${applyExamApi}read', {
      'skip': 0,
      'limit': _limit,
      "category": category,
      "isCategory":widget.isCategory,
      "keySearch": keySearch
    });

    futureCategory = postDioCategory(
      '${applyExamCategoryApi}read',
      {'skip': 0, 'limit': 100,"isCategory":widget.isCategory,},
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      futureModel = postDio('${applyExamApi}read', {
        'skip': 0,
        'limit': _limit,
        "category": category,
        "isCategory":widget.isCategory,
        "keySearch": keySearch
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
        appBar: header(context, goBack, title: widget.title),
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
                CategorySelector(
                  model: futureCategory,
                  onChange: (String val) {
                    setData(val, keySearch);
                  },
                ),
                const SizedBox(height: 5),
                KeySearch(
                  show: hideSearch,
                  onKeySearchChange: (String val) {
                    setData(category, val);
                  },
                ),
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
                  "isCategory":widget.isCategory,
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
          return newsCard(context, model[index]);
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
          "isCategory":widget.isCategory,
          "keySearch": keySearch
        });
      },
    );
  }
}
