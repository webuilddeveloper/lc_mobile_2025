import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/models/user.dart';
import 'package:lc/v3/poll_v3/poll_list_v3.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchOtherList extends StatefulWidget {
  SearchOtherList({Key? key, required this.title, required this.model})
      : super(key: key);

  final String title;
  final Future<dynamic> model;

  @override
  _SearchOtherList createState() => _SearchOtherList();
}

class _SearchOtherList extends State<SearchOtherList> {
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;
  final storage = new FlutterSecureStorage();

  late User userData;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0XFFF7F7F7),
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
        body: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 3),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'โปรดเลือกบริการ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Color(0xFF2D9CED),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchInWebViewWithJavaScript(
                          'http://deka.supremecourt.or.th/');
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/supremeCourt.png"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                ),
                                height: 100,
                                width: 100,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 20, top: 10),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'คำสั่งศาลฏีกา',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D9CED),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'ท่านสามารถดูรายละเอียดคำสั่งศาลฏีกาได้ที่นี่',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 13.0,
                                          color: Color(0xFF707070),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchInWebViewWithJavaScript(
                          'http://www.ratchakitcha.soc.go.th/RKJ/announce/newrkj.jsp');
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage("assets/announcement.png"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                ),
                                height: 100,
                                width: 100,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 20, top: 10),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ประกาศราชกิจจานุเบกษา',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D9CED),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'ท่านสามารถดูประกาศราชกิจจานุเบกษาได้ที่นี่',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 13.0,
                                          color: Color(0xFF707070),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launchInWebViewWithJavaScript(
                          'https://library.coj.go.th/th/index.html');
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/electronicLibrary.png"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                ),
                                height: 100,
                                width: 100,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 20, top: 10),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ห้องสมุดอิเล็กทรอนิกส์',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D9CED),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'ท่านสามารถใช้งานห้องสมุดอิเล็กทรอนิกส์ได้ฟรี ได้ที่นี่แล้วครับ',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 13.0,
                                          color: Color(0xFF707070),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PollListV3(
                            title: 'แบบสอบถาม',
                            userData: userData,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 20, top: 10),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/questionnaire.png"),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                  ),
                                ),
                                height: 100,
                                width: 100,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 20, top: 10),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 15, right: 15, bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  width: 100,
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'แบบสอบถาม',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2D9CED),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'ท่านสามารถทำแบบสอบถามต่างๆ ได้ที่นี่',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 13.0,
                                          color: Color(0xFF707070),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    txtDescription.dispose();
    super.dispose();
  }

  _callRead() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var data = json.decode(value!);
    setState(() {
      userData = new User(
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
  }
}
