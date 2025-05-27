import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/notarial_services_attorney/nsa_main.dart';
import 'package:lc/shared/extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';

class NsaReportPolicy extends StatefulWidget {
  const NsaReportPolicy({super.key, this.model, required this.title});
  final dynamic model;
  final String title;

  @override
  State<NsaReportPolicy> createState() => _NsaReportPolicyState();
}

class _NsaReportPolicyState extends State<NsaReportPolicy> {
  dynamic listModel;
  int _limit = 10;
  final storage = const FlutterSecureStorage();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
                    image: const AssetImage(
                        "assets/images/bg_cremation_second.png"),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
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
                    height:  MediaQuery.of(context).size.height * 0.650,
                    // height: (deviceHeight >= 500 && deviceHeight < 800)
                    //     ? 490
                    //     : (deviceHeight >= 800)
                    //         ? 970
                    //         : deviceHeight * 0.2,
                    padding:
                        const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: const BoxDecoration(
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
                    child: const CircularProgressIndicator(
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
    scrollController = ScrollController();

    _callRead();
    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
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
      "category": "nsa",
    });
    if (policyAccept.length > 0) {
      // setState(() {
      //   listModel = policyAccept;
      // });
      //  Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => NSAMainForm(),
      //   ),
      //   (Route<dynamic> route) => false,
      // );
    } else {
      var policy = await postDio(server + "m/policy/read", {
        "skip": 0,
        "limit": 10,
        "category": "nsa",
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
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: Container(
              // color: Colors.blueAccent,
              alignment: Alignment.topCenter,
              child: ListView.builder(
                shrinkWrap: true, // 1st add
                physics: const ClampingScrollPhysics(),
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
                                  style: const TextStyle(
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
                                  color: const Color(0xFFEEBA33),
                                ),
                                child: Text(
                                  (index + 1).toString() +
                                      '/' +
                                      policyLength.toString(),
                                  style: const TextStyle(
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              controller: scrollController,
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Html(
                                  data: model[index]['description']?.toString() ?? '',
                                  onLinkTap: (String? url,
                                      Map<String, String> attributes, element) {
                                    launch(url!);
                                    //open URL in webview, or launch URL in browser, or any other logic here
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
                              ? const Color(0xFFEEBA33)
                              : const Color(0xFF707070),
                          corrected: true,
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildButton(
            'บันทึกข้อมูล',
            const Color(0xFFEEBA33),
            onTap: () {
              sendAcceptedPolicy();
              // dialogConfirm();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildCard(dynamic model) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.6,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    model['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Kanit',
                    ),
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFEEBA33),
                  ),
                  child: Text(
                    (currentCardIndex + 1).toString() +
                        '/' +
                        policyLength.toString(),
                    style: const TextStyle(
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
                      //open URL in webview, or launch URL in browser, or any other logic here
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildButton(
            'ยินยอม',
            const Color(0xFFED6B2D),
            onTap: () {
              nextIndex(model, true);
            },
          ),
          const SizedBox(height: 15),
          _buildButton(
            'ไม่ยินยอม',
            const Color(0xFF707070),
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
      {Function? onTap, bool corrected = false}) {
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
            const SizedBox(width: 40),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
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
    logWTF(acceptPolicyList);
    acceptPolicyList.forEach((e) {
      postDio(server + 'm/policy/create', e);
    });
    var profileCode = await storage.read(key: 'profileCode18');
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    setState(() {
      _loading = false;
    });

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
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: 250,
              height: 170,
              // width: MediaQuery.of(context).size.width / 1.3,
              // height: MediaQuery.of(context).size.height / 2.5,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0x00ffffff),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'นโยบายความปลอดภัย',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'คลิก ตกลง เพื่อกลับสู่หน้าจอทนายรับรองรายมือชื่อ',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NSAMainForm(title: ''),
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
                          color: const Color(0xFFED6B2D),
                        ),
                        child: const Row(
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
                    ),
                    const SizedBox(height: 15),
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
