import 'dart:async';
import 'package:lc/component/key_search.dart';
import 'package:flutter/material.dart';
import 'package:lc/component/sso/list_content.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'news/news_form.dart';

class SearchListPage extends StatefulWidget {
  const SearchListPage({super.key});

  @override
  _SearchListPageState createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  late Future<dynamic> futureModel;
  ScrollController scrollController = new ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String keySearch = '';
  var tempData = List<dynamic>.empty(growable: true);

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildHeader(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Color(0xFF000070),
        ),
      ),
      backgroundColor: Colors.white,
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            _buildHead(),
            Expanded(
              child: _buildSmartRefresher(
                _screen(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildHead() {
    return Container(
      color: Color(0xFF000070),
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        // height: 120,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    child: Text(
                      'สภาทนายความ',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 30,
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: KeySearch(
                        onKeySearchChange: (String val) {
                          setState(
                            () {
                              keySearch = val;
                            },
                          );
                          _onLoading();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildSmartRefresher(Widget child) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      physics: ClampingScrollPhysics(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.loading) {
            body = CircularProgressIndicator();
          } else if (mode == LoadStatus.noMore) {
            body = Text("ไม่มีข้อมูลเพิ่มเติม");
          } else {
            body = SizedBox.shrink(); // Default empty widget
          }
          return Container(
            padding: EdgeInsets.all(10),
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: child,
    );
  }

  _screen() {
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        SizedBox(height: 10),
        // if (keySearch != '')
        //   Text('ผลการค้นหา ' +
        //       keySearch +
        //       ' พบ ' +
        //       model['totalData'].toString()),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'ข่าวประชาสัมพันธ์ ' + keySearch,
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListContent4(
          model: futureModel,
          navigationForm: (dynamic model) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsForm(
                  code: model['code'],
                  model: model,
                ),
              ),
            );
          },
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            'ผลการค้นหา ' + keySearch + ' ข่าวประชาสัมพันธ์',
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Expanded(
        //   child:
        ListContent2(
          model: futureModel,
          navigationForm: (dynamic model) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsForm(
                  code: model['code'],
                  model: model,
                ),
              ),
            );
          },
        ),
        // ),
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
    _callRead();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  _callRead() {
    futureModel = postDio('${server}m/news/read', {
      // "category": "application",
      "limit": 10,
      "keySearch": keySearch
    });

    for (var i = 0; i < 10; i++) {
      tempData.add({'title': '', 'imageUrl': ''});
    }
  }
}
