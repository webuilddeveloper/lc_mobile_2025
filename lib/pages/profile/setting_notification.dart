import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v3/widget/header_v3.dart';

class SettingNotificationPage extends StatefulWidget {
  @override
  _SettingNotificationPageState createState() =>
      _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  final storage = new FlutterSecureStorage();

  late String _username;
  late String _password;
  late String _facebookID;
  late String _appleID;
  late String _googleID;
  late String _lineID;
  late String _email;
  late String _imageUrl;
  late String _category;
  late String _prefixName;
  late String _firstName;
  late String _lastName;
  late String _idCard;

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

  bool isSwitchedEventPage = false;
  bool isSwitchedContactPage = false;
  bool isSwitchedKnowledgePage = false;
  bool isSwitchedMainPage = false;
  bool isSwitchedNewsPage = false;
  bool isSwitchedPoiPage = false;
  bool isSwitchedPollPage = false;
  bool isSwitchedPrivilegePage = false;
  bool isSwitchedReporterPage = false;
  bool isSwitchedWelfarePage = false;
  bool isSwitchedCooperativeFormPage = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    futureModel = readNotification();
    super.initState();
  }

  Future<dynamic> readNotification() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);
    if (user['code'] != '') {
      setState(() {
        _username = user['username'] ?? '';
        _imageUrl = user['imageUrl'] ?? '';
        _firstName = user['firstName'] ?? '';
        _lastName = user['lastName'] ?? '';
        _prefixName = user['prefixName'];
      });
    }
    final result = await postObjectData('m/register/notification/read', {
      'username': _username,
    });

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataNotificationOPEC',
        value: jsonEncode(result['objectData']),
      );

      setState(() {
        isSwitchedEventPage = result['objectData']['eventPage'];
        isSwitchedContactPage = result['objectData']['contactPage'];
        isSwitchedKnowledgePage = result['objectData']['knowledgePage'];
        isSwitchedMainPage = result['objectData']['mainPage'];
        isSwitchedNewsPage = result['objectData']['newsPage'];
        isSwitchedPoiPage = result['objectData']['poiPage'];
        isSwitchedPollPage = result['objectData']['pollPage'];
        isSwitchedPrivilegePage = result['objectData']['privilegePage'];
        isSwitchedReporterPage = result['objectData']['reporterPage'];
        isSwitchedWelfarePage = result['objectData']['welfarePage'];
        isSwitchedCooperativeFormPage =
            result['objectData']['cooperativeFormPage'];
      });
    }
  }

  Future<dynamic> updateNotication() async {
    var value = await storage.read(key: 'dataNotificationOPEC');
    var data = json.decode(value!);
    data['eventPage'] = isSwitchedEventPage;
    data['contactPage'] = isSwitchedContactPage;
    data['knowledgePage'] = isSwitchedKnowledgePage;
    data['mainPage'] = isSwitchedMainPage;
    data['newsPage'] = isSwitchedNewsPage;
    data['poiPage'] = isSwitchedPoiPage;
    data['pollPage'] = isSwitchedPollPage;
    data['privilegePage'] = isSwitchedPrivilegePage;
    data['reporterPage'] = isSwitchedReporterPage;
    data['welfarePage'] = isSwitchedWelfarePage;
    data['cooperativeFormPage'] = isSwitchedCooperativeFormPage;

    final result = await postObjectData('m/Register/notification/update', data);

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataNotificationOPEC',
        value: jsonEncode(result['objectData']),
      );

      setState(() {
        isSwitchedEventPage = result['objectData']['eventPage:'] ?? '';
        isSwitchedContactPage = result['objectData']['contactPage:'] ?? '';
        isSwitchedKnowledgePage = result['objectData']['knowledgePage:'] ?? '';
        isSwitchedMainPage = result['objectData']['mainPage'] ?? '';
        isSwitchedNewsPage = result['objectData']['newsPage'] ?? '';
        isSwitchedPoiPage = result['objectData']['poiPage'] ?? '';
        isSwitchedPollPage = result['objectData']['pollPage'] ?? '';
        isSwitchedPrivilegePage = result['objectData']['privilegePage'] ?? '';
        isSwitchedReporterPage = result['objectData']['reporterPage'] ?? '';
        isSwitchedWelfarePage = result['objectData']['welfarePage'] ?? '';
        isSwitchedCooperativeFormPage =
            result['objectData']['cooperativeFormPage'] ?? '';
      });
    }
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => UserInformationPage(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(10), child: contentCard()),
    );
  }

  contentCard() {
    return Column(
      // shrinkWrap: true,
      // physics: ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Color(0xFFE2E2E2),
          //       width: 1.0,
          //     ),
          //   ),
          // ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'ระบบแจ้งเตือน',
                  style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedMainPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedMainPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFF8AD2FF),
                  activeColor: Color(0xFF2D9CED),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Color(0xFFE2E2E2),
          //       width: 1.0,
          //     ),
          //   ),
          // ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'ข่าวสารประชาสัมพันธ์',
                  style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedNewsPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedNewsPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFF8AD2FF),
                  activeColor: Color(0xFF2D9CED),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Color(0xFFE2E2E2),
          //       width: 1.0,
          //     ),
          //   ),
          // ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'ปฎิทินกิจกรรม',
                  style: new TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedEventPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedEventPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFF8AD2FF),
                  activeColor: Color(0xFF2D9CED),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Color(0xFFE2E2E2),
          //       width: 1.0,
          //     ),
          //   ),
          // ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'สมาชิกต้องรู้',
                  style: new TextStyle(
                    fontSize: 15,
                    //color: Color(0xFF9D040C),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedKnowledgePage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedKnowledgePage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFF8AD2FF),
                  activeColor: Color(0xFF2D9CED),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Color(0xFFE2E2E2),
          //       width: 1.0,
          //     ),
          //   ),
          // ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'สิทธิประโยชน์',
                  style: new TextStyle(
                    fontSize: 15,
                    //color: Color(0xFF9D040C),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPrivilegePage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPrivilegePage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFF8AD2FF),
                  activeColor: Color(0xFF2D9CED),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Color(0xFFE2E2E2),
          //       width: 1.0,
          //     ),
          //   ),
          // ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'กดดูรู้ที่เรียน',
                  style: new TextStyle(
                    fontSize: 15,
                    //color: Color(0xFF9D040C),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPoiPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPoiPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFF8AD2FF),
                  activeColor: Color(0xFF2D9CED),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Color(0xFFE2E2E2),
          //       width: 1.0,
          //     ),
          //   ),
          // ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'แบบสอบถาม',
                  style: new TextStyle(
                    fontSize: 15,
                    //color: Color(0xFF9D040C),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPollPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPollPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFF8AD2FF),
                  activeColor: Color(0xFF2D9CED),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          // decoration: BoxDecoration(
          //   border: Border(
          //     bottom: BorderSide(
          //       color: Color(0xFFE2E2E2),
          //       width: 1.0,
          //     ),
          //   ),
          // ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'ข้อเสนอแนะ',
                  style: new TextStyle(
                    fontSize: 15,
                    //color: Color(0xFF9D040C),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedReporterPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedReporterPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFF8AD2FF),
                  activeColor: Color(0xFF2D9CED),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: headerV3(
          context,
          goBack,
          title: 'ตั้งค่าการแจ้งเตือน',
        ),
        // backgroundColor: Color(0xFFF7F7F7),
        backgroundColor: Color(0xFFFFFFFF),
        body: FutureBuilder<dynamic>(
          future: futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Container(
                  color: Colors.white,
                  child: dialogFail(context),
                ),
              );
            else
              return Container(
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  // padding: EdgeInsets.only(top: 10),
                  children: <Widget>[
                    new Column(
                      // alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.symmetric(
                            horizontal: 5.0,
                            // vertical: 10.0,
                          ),
                          child: contentCard(),
                        ),
                      ],
                    ),
                  ],
                ),
              );
          },
        ));
  }
}
