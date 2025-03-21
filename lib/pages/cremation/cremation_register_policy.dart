// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/shared/extension.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import 'cremation_main.dart';

class CremationRegisterPolicyForm extends StatefulWidget {
  const CremationRegisterPolicyForm({Key? key, this.model}) : super(key: key);
  final dynamic model;

  @override
  State<CremationRegisterPolicyForm> createState() =>
      _CremationRegisterPolicyFormState();
}

class _CremationRegisterPolicyFormState
    extends State<CremationRegisterPolicyForm> {
  dynamic listModel;
  final storage = new FlutterSecureStorage();

  late ScrollController scrollController;
  final txtidcard = TextEditingController();
  int currentCardIndex = 0;
  int policyLength = 0;
  bool lastPage = false;
  List acceptPolicyList = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Container(
                height: 1000,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_cremation_second.png"),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.contain,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.6),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/images/fram_policy.png",
                    width: 500,
                    height: 550,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    // height:  MediaQuery.of(context).size.height * .650,
                    height: (deviceHeight >= 500 && deviceHeight < 800)
                        ? 490
                        : (deviceHeight >= 800)
                            ? 590
                            : deviceHeight * 0.2,
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: _futureBuilderModel(),
                  ),
                ),
              ),
              if (_loading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CircularProgressIndicator(
                      color: Color(0xFFED6B2D),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    scrollController = new ScrollController();

    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtidcard.dispose();

    super.dispose();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  _callRead() async {
    var policyAccept = await postDio('${server}m/policy/readAccept', {
      "category": "cremation",
    });
    if (policyAccept.length > 0) {
      setState(() {
        listModel = policyAccept;
      });
    } else {
      var policy = await postDio(server + "m/policy/read", {
        "skip": 0,
        "limit": 10,
        "category": "cremation",
      });
      setState(() {
        listModel = policy;
      });
    }
  }

  nextStep() async {}

  _futureBuilderModel() {
    return FutureBuilder<dynamic>(
      future: Future.value(listModel), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _screen(snapshot.data);
          // _logicShowCard(snapshot.data, currentCardIndex);
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return _screen([
            {'title': '', 'description': ''}
          ]);
        }
      },
    );
  }

  _screen(dynamic model) {
    policyLength = model.length;
    return Column(
      children: [
        lastPage ? _buildListCard(model) : _buildCard(model[currentCardIndex])
      ],
    );
  }

  _buildListCard(dynamic model) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.60,
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Container(
              // color: Colors.blueAccent,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                shrinkWrap: true, // 1st add
                physics: ClampingScrollPhysics(),
                itemCount: model.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  model[index]['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Kanit',
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                              // SizedBox(width: 10),
                              Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFFEEBA33),
                                ),
                                child: Text(
                                  (index + 1).toString() +
                                      '/' +
                                      policyLength.toString(),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Kanit',
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: height * 0.6,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              controller: scrollController,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Html(
                                  data: model['description'],
                                  onLinkTap: (String? url,
                                      Map<String, String> attributes, element) {
                                    launch(url!);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        _buildButton(
                          acceptPolicyList[index]['isActive']
                              ? 'ยอมรับ'
                              : 'ไม่ยอมรับ',
                          acceptPolicyList[index]['isActive']
                              ? Color(0xFFEEBA33)
                              : Color(0xFF707070),
                          corrected: true,
                        ),
                        SizedBox(height: 20)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildButton(
            'บันทึกข้อมูล',
            Color(0xFFEEBA33),
            onTap: () {
              sendAcceptedPolicy();
              // dialogConfirm();
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildCard(dynamic model) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.6,
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      padding: EdgeInsets.all(5),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    model['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Kanit',
                    ),
                    maxLines: 3,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFEEBA33),
                  ),
                  child: Text(
                    (currentCardIndex + 1).toString() +
                        '/' +
                        policyLength.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Kanit',
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              // isAlwaysShown: false,
              controller: scrollController,
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Html(
                    data: model['description'],
                    onLinkTap:
                        (String? url, Map<String, String> attributes, element) {
                      launch(url!);
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          _buildButton(
            'ยินยอม',
            Color(0xFFED6B2D),
            onTap: () {
              nextIndex(model, true);
            },
          ),
          SizedBox(height: 15),
          _buildButton(
            'ไม่ยินยอม',
            Color(0xFF707070),
            onTap: () {
              Navigator.pop(context, false);
            },
          ),
          // SizedBox(height: 10),
        ],
      ),
    );
  }

  _buildButton(String title, Color color,
      {VoidCallback? onTap, bool corrected = false}) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        height: 40,
        width: 285,
        alignment: Alignment.center,
        // margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Row(
          children: [
            SizedBox(width: 40),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Kanit',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: corrected
                  ? Image.asset(
                      'assets/images/correct.png',
                      height: 15,
                      width: 15,
                    )
                  : null,
            )
          ],
        ),
      ),
    );
  }

  nextIndex(dynamic model, bool accepted) {
    scrollController.jumpTo(0);
    if (currentCardIndex == policyLength - 1) {
      setState(() {
        lastPage = true;
        acceptPolicyList.add({
          'index': currentCardIndex,
          'reference': model['code'],
          'isActive': accepted
        });
      });
    } else {
      setState(() {
        acceptPolicyList.add({
          'index': currentCardIndex,
          'reference': model['code'],
          'isActive': accepted
        });
        currentCardIndex++;
      });
    }
  }

  sendAcceptedPolicy() async {
    setState(() {
      _loading = true;
    });
    // logWTF(acceptPolicyList);
    acceptPolicyList.forEach((e) {
      postDio(server + 'm/policy/create', e);
    });
    var profileCode = await storage.read(key: 'profileCode18');
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    final result = await postDio(server + 'cremation/registerCreate', {
      'profileCode': profileCode,
      'cremation_no': widget.model['cremation_no'],
      'name': widget.model['name'],
      'membercategory': widget.model['membercategory'],
      'idcard': widget.model['idcard'],
      'phone': widget.model['phone'],
      'reasonfortermination': widget.model['reasonfortermination'],
      'birthdate': widget.model['birthdate'],
      'address': widget.model['address'],
      'imageUrl': user['imageUrl'] ?? '',
    });

    setState(() {
      _loading = false;
    });

    logWTF(result);
    return dialogConfirm();
  }

  Future<dynamic> dialogConfirm() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CustomAlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: 220,
              height: 155,
              // width: MediaQuery.of(context).size.width / 1.3,
              // height: MediaQuery.of(context).size.height / 2.5,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'สมัครสมาชิกเรียบร้อย',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'คลิก ตกลง เพื่อกลับสู่หน้าจอหลักฌาปนกิจ',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CremationMainForm(title: 'ฌาปนกิจ'),
                          ),
                        );
                      },
                      child: Container(
                        height: 35,
                        width: 160,
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFED6B2D),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'ตกลง',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Kanit',
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // child: //Contents here
            ),
          ),
        );
      },
    );
  }
}
