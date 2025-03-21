import 'package:badges/badges.dart' as badges;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/cremation/cremation_history.dart';
import 'package:lc/pages/cremation/cremation_information.dart';
import 'package:lc/pages/cremation/cremation_notification.dart';
import 'package:lc/pages/cremation/cremation_register_first.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../../shared/extension.dart';
import '../../v3/menu_v3.dart';
import 'cremation_pay.dart';

class CremationMainForm extends StatefulWidget {
  const CremationMainForm({super.key, required this.title});
  final String title;

  @override
  State<CremationMainForm> createState() => _CremationMainFormState();
}

class _CremationMainFormState extends State<CremationMainForm> {
  dynamic model;
  String memberStatus = "0";
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  // ignore: non_constant_identifier_names
  final txtCremation_no = TextEditingController();
  late Future<dynamic> _futureCremationRegister;
  late Future<dynamic> _futureProfile;
  late Future<dynamic> _futureNoti;

  String profileCode = "";
  // ignore: non_constant_identifier_names
  late int cremation_no;

  final storage = const FlutterSecureStorage();
  dynamic _username = '';
  dynamic _category = '';
  dynamic _modelAmount;
  dynamic _modelMember;

  String totalAmount = '0';
  String updateDate = '-';

  int notiCount = 0;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFFFFFFF),
          flexibleSpace: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 15,
              right: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MenuV3(),
                    ),
                  ),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x408AD2FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF2D9CED),
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    "ข้อมูลสมาชิกฌาปนกิจ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () => _dialogContact(),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x408AD2FF),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset('assets/images/icon_contact.png'),
                  ),
                ),
              ],
            ),
          ),
        ),
        extendBody: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SmartRefresher(
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
            child: _card(),
          ),
        ),
      ),
    );
  }

  _card() {
    return Stack(
      children: [
        ListView(
          children: [
            _header(),
            Column(
              children: [
                memberStatus == "0"
                    ? Container(
                        child: const Text(
                          "ยอดเงินสงเคราะห์ล่วงหน้าคงเหลือ",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF052598)),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : memberStatus == "1"
                        ? Container(
                            child: const Text(
                              "ยอดเงินสงเคราะห์ค้างชำระ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFED6B2D)),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(
                            child: const Text(
                              "ท่านพ้นสภาพสมาชิก ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFED6B2D)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                memberStatus == "0"
                    ? Container()
                    : memberStatus == "1"
                        ? Container(
                            child: const Text(
                              "เงินสงเคราะห์ล่วงหน้าและค่าบำรุงประจำปี",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFED6B2D)),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Container(
                            child: const Text(
                              "หากประสงค์กลับเข้าเป็นสมาชิก กรุณาติดต่อสภาทนายความ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFED6B2D)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text(
                    "ธุรกรรม",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildButtonSocial(
                          icon: Image.asset(
                            memberStatus == "0"
                                ? 'assets/images/icon_pay.png'
                                : memberStatus == "1"
                                    ? 'assets/images/icon_pay.png'
                                    : 'assets/images/icon_pay1.png',
                          ),
                          title: 'จ่าย',
                          press: () async {
                            memberStatus == '2'
                                ? {}
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CremationPayForm(
                                        title: "จ่าย",
                                        model: model,
                                      ),
                                    ),
                                  );
                          },
                        ),
                        _buildButtonSocial(
                          icon: Image.asset(
                            memberStatus == "0"
                                ? 'assets/images/icon_history.png'
                                : memberStatus == "1"
                                    ? 'assets/images/icon_history.png'
                                    : 'assets/images/icon_history1.png',
                          ),
                          title: 'ประวัติ',
                          press: () async {
                            memberStatus == '2'
                                ? {}
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CremationHistoryForm(
                                        title: 'ประวัติ',
                                        model: model,
                                      ),
                                    ),
                                  );
                          },
                        ),
                        badges.Badge(
                          showBadge: memberStatus == '2' ? false : true,
                          badgeContent: Text(
                            notiCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: _buildButtonSocial(
                            icon: Image.asset(
                              memberStatus == "0"
                                  ? 'assets/images/icon_noti.png'
                                  : memberStatus == "1"
                                      ? 'assets/images/icon_noti.png'
                                      : 'assets/images/icon_noti1.png',
                            ),
                            title: 'แจ้งเตือน',
                            press: () async {
                              if (memberStatus != '2') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CremationNotificationForm(
                                            title: "แจ้งเตือน"),
                                  ),
                                ).then((value) => _callReadNotification());
                              }
                            },
                          ),
                        ),
                        _buildButtonSocial(
                          icon: Image.asset(
                            memberStatus == "0"
                                ? 'assets/images/icon_infomation.png'
                                : memberStatus == "1"
                                    ? 'assets/images/icon_infomation.png'
                                    : 'assets/images/icon_infomation.png',
                          ),
                          title: 'สมาชิก',
                          press: () async {
                            // memberStatus == '2'
                            //     ? {}
                            //     : Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) =>
                            //               CremationInformationPage(
                            //                   model: _futureCremationRegister),
                            //         ),
                            //       );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CremationInformationPage(
                                    model: _futureCremationRegister),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFF7F7F7),
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        // padding: EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                          "หากมีข้อสงสัยกรุณาติดต่อ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        // padding: EdgeInsets.symmetric(horizontal: 30),
                        child: const Text(
                          "การฌาปนกิจสภาทนายความ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: const Text(
                          "02-522-7124 ต่อ 226,227 หรือ 083-040-8662",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF2D9CED),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
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
          )
      ],
    );
  }

  _header() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 60),
          height: 320,
          width: 340,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              memberStatus == "0"
                  ? 'assets/images/img_main1.png'
                  : memberStatus == "1"
                      ? 'assets/images/img_main2.png'
                      : 'assets/images/img_main3.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(40.0),
            child: Image.asset(
                memberStatus == "0"
                    ? 'assets/images/fram_main1.png'
                    : memberStatus == "1"
                        ? 'assets/images/fram_main2.png'
                        : 'assets/images/fram_main3.png',
                height: 210,
                width: 210),
          ),
        ),
        Positioned(
          top: 100,
          child: Text(
            totalAmount != null && totalAmount != "" ? totalAmount : '0',
            style: const TextStyle(
              fontSize: 45.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        const Positioned(
          bottom: 115,
          child: Text(
            'ข้อมูลอัพเดตเมื่อ',
            style: TextStyle(
              fontSize: 15.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        Positioned(
          bottom: 95,
          child: Text(
            updateDate != null && updateDate != '' ? updateDate : '-',
            style: const TextStyle(
              fontSize: 15.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ],
    );
  }

  @override
  initState() {
    _callRead();

    super.initState();
  }

  void _onLoading() async {
    _callRead();
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtCremation_no.dispose();

    super.dispose();
  }

  _callRead() async {
    setState(() {
      _loading = true;
    });
    profileCode = (await storage.read(key: 'profileCode18'))!;
    if (profileCode != '' && profileCode != null) {
      _futureProfile = postDio(profileReadApi, {'code': profileCode});
    }
    var _profile = await _futureProfile;
    if (_profile != null) {
      _username = _profile["username"];
      _category = _profile["category"];
    }

    _futureCremationRegister = postDio('${server}cremation/registerRead',
        {'skip': 0, 'limit': 1, 'profileCode': profileCode});
    var modelRegister = await _futureCremationRegister;
    // logWTF(modelRegister);
    if (modelRegister.length <= 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const CremationRegisterFirstForm(
            title: '',
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }

    if (modelRegister.isNotEmpty) {
      _callReadLcCremation(modelRegister[0]['cremation_no']);
      setState(() {
        model = modelRegister[0];
      });
    } else {
      print('modelRegister is empty, skipping _callReadLcCremation');
      return;
    }
    // _futureModel = postDio('${newsApi}read',
    //     {'skip': 0, 'limit': 3, 'category': '20210212114334-244-708'});
    setState(() {
      model = modelRegister[0];
      // _loading = false;
    });
    _futureNoti = postDio(
      '${server}cremation/notification/count',
      {
        "username": _username,
        "category": _category,
      },
    );
    var _norti = await _futureNoti;
    setState(() {
      notiCount = _norti['total'];
    });

    Dio dio1 = new Dio();

    await dio1.get('${server}cremation/negativeAmount/send');
  }

  Future<dynamic> _dialogContact() async {
    String title = 'หากมีข้อสงสัยกรุณาติดต่อ';
    String subTitle1 = 'การฌาปนกิจสภาทนายความ';
    String subTitle2 = '02-522-7124 ต่อ 226,227 หรือ 083-040-8662';
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CustomAlertDialog(
            // contentPadding: EdgeInsets.all(0),
            content: Container(
              width: MediaQuery.of(context).size.height / 100 * 30,
              height: 210,
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
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF2D9CED),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subTitle1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    Text(
                      subTitle2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    const SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.height / 100 * 15,
                        height: 40,
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.5),
                          color: const Color(0xFFED6B2D),
                        ),
                        child: const Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Kanit',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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

  _callReadLcCremation(int cremation_no) async {
    _modelAmount = await postDio(
      server + 'cremation/readAmount',
      {"cremation_no": cremation_no.toString()},
    );

    _modelMember = await postDio(
      server + 'cremation/read',
      {"cremation_no": cremation_no.toString()},
    );

    // _modelAmount = await _futureCremationAmount;
    // _modelMember = await _futureCremationMember;

    // logWTF(_modelAmount);
    // logWTF(_modelMember);

    setState(() {
      _checkStatus(_modelMember, _modelAmount);

      if (_modelAmount.length > 0) {
        totalAmount = _modelAmount[0]['remainingamount'];
        updateDate = dateStringToDate(_modelAmount[0]['updateDate']);
      } else {
        totalAmount = '0';
        updateDate = '-';
      }
      model['cremation_no'] = cremation_no;
      model['totalAmount'] = totalAmount;
      model['updateDate'] = updateDate;
      _loading = false;
    });
  }

  _checkStatus(dynamic modelMember, dynamic modelAmount) {
    // logWTF(modelAmount);
    // logWTF(modelMember);

    var status =
        modelMember.length > 0 ? modelMember[0]['reasonfortermination'] : '';
    var chkNegative =
        modelAmount.length > 0 ? modelAmount[0]['remainingamount'][0] : '';

    if (status == 'เสียชีวิต' ||
        status == 'พ้นสภาพ' ||
        status == 'ลาออก' ||
        status == 'เสียชีวิตก่อนกำหนด') {
      setState(() {
        memberStatus = '2';
        model['memberStatus'] = memberStatus;
      });
    } else if (chkNegative == '-') {
      setState(() {
        memberStatus = '1';
        model['memberStatus'] = memberStatus;
      });
    } else {
      setState(() {
        memberStatus = '0';
        model['memberStatus'] = memberStatus;
      });
    }
  }

  _callReadNotification() async {
    _futureNoti = postDio(
      '${server}cremation/notification/count',
      {
        "username": _username,
        "category": _category,
      },
    );
    var _norti = await _futureNoti;
    setState(() {
      notiCount = _norti['total'];
    });
    // logWTF(_norti);
  }

  _buildButtonSocial({Widget? icon, String? title, Function? press}) {
    return Column(
      children: [
        Container(
          height: 65.0,
          width: 65.0,
          child: new IconButton(
            onPressed: () async {
              press!();
            },
            icon: icon!,
          ),
        ),
        Text(title!)
      ],
    );
  }
}
