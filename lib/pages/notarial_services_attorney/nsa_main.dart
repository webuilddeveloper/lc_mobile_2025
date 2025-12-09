import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/notarial_services_attorney/nsa_report_1.dart';
import 'package:lc/v4/menu_v4.dart';
import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../../v3/menu_v3.dart';
import 'nsa_report_certify.dart';
import 'nsa_report_register.dart';
import 'nsa_report_2.dart';
import 'nsa_report_3.dart';
import 'nsa_report_4.dart';

class NSAMainForm extends StatefulWidget {
  const NSAMainForm({super.key, required this.title});
  final String title;

  @override
  State<NSAMainForm> createState() => _NSAMainFormState();
}

class _NSAMainFormState extends State<NSAMainForm> {
  final storage = new FlutterSecureStorage();
  String profileCode = "";
  late Future<dynamic> _futureProfile;
  dynamic _model;
  late Future<dynamic> _futureSign;
  dynamic _modelSign;
  bool isSign = false;

  late Future<dynamic> _futureReporterT01;
  dynamic _modelT01;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        // extendBody: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 30), // ปรับ padding
                height: 1000, // ปรับความสูง
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_nsa.png"),
                    alignment: Alignment.center, // จัดตำแหน่งรูปพื้นหลัง
                    fit: BoxFit.fill, // ครอบคลุมเต็มพื้นที่
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), // ปรับ opacity
                      BlendMode.dstATop,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          "assets/images/bg_preview.png",
                          fit: BoxFit.contain, // จัดขนาดรูปภาพให้พอดี
                          width: 400, // ปรับความกว้าง
                          height: 350, // ปรับความสูง
                        ),
                      ),
                    ),
                  ],
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
                    height: deviceHeight * 0.7,
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.0),
                            child: Text(
                              'ทนายความผู้ทำคำรับรองลายมือชื่อ',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Color(0xFF000000)),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(left: 1.0),
                            child: Text(
                              'และเอกสาร',
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Color(0xFF000000)),
                            ),
                          ),
                        ),
                        // Container(
                        //   height: 40,
                        //   child: Stack(
                        //     children: [
                        //       Align(
                        //         alignment: Alignment.center,
                        //         child: Padding(
                        //           padding: EdgeInsets.only(left: 1.0),
                        //           child: Text(
                        //             'ทนายความผู้ทำคำรับรองลายมือชื่อ',
                        //             style: TextStyle(
                        //                 fontStyle: FontStyle.normal,
                        //                 fontWeight: FontWeight.w500,
                        //                 fontSize: 20,
                        //                 color: Color(0xFF000000)),
                        //           ),
                        //         ),
                        //       ),
                        //        Align(
                        //         alignment: Alignment.center,
                        //         child: Padding(
                        //           padding: EdgeInsets.only(left: 1.0),
                        //           child: Text(
                        //             'และเอกสาร',
                        //             style: TextStyle(
                        //                 fontStyle: FontStyle.normal,
                        //                 fontWeight: FontWeight.w500,
                        //                 fontSize: 20,
                        //                 color: Color(0xFF000000)),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 10),
                        Container(
                          height: 40,
                          // margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 1.0),
                                  child: Text(
                                    'โปรดเลือกแบบฟอร์ม',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        color: Color(0xFF758C29)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        _buildMenu(
                          'สมัครสมาชิกสำหรับการอบรมทนายรับรองลายมือชื่อ',
                          '',
                          isSign == true ? false : true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NsaReportRegisterPage(),
                              ),
                            ).then((value) => _callRead());
                          },
                        ),
                        SizedBox(height: 15),
                        _buildMenu(
                          'แบบ ทรอ.1',
                          'คำขอขึ้นทะเบียนเป็นทนายความ ผู้ทำคำรับรองลายมือชื่อและเอกสาร',
                          isSign,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NsaReport1Page(model: _modelSign[0]),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15),
                        _buildMenu(
                          'แบบ ทรอ.2',
                          'แบบคำขอต่ออายุการขึ้นทะเบียนเป็นทนายความผู้ทำคำรับรองลายมือชื่อ และเอกสาร',
                          isSign,
                          onTap: () {
                            checkExpireDate(context);
                          },
                        ),
                        SizedBox(height: 15),
                        _buildMenu(
                          'แบบ ทรอ.3',
                          'คำขอรับใบแทนใบสำคัญการขึ้นทะเบียน/ตราประทับทนายความผู้ทำคำรับรอง ลายมือชื่อและเอกสาร',
                          isSign,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NsaReport3Page(
                                    profileCode: profileCode,
                                    model: _modelSign[0]),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15),
                        _buildMenu(
                          'แบบ ทรอ.4',
                          'คำขอเปลี่ยนแปลงข้อมูล',
                          isSign,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NsaReport4Page(
                                    profileCode: profileCode,
                                    model: _modelSign[0]),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15),
                        _buildMenu(
                          'แบบคําขอให้รับรองสําเนาถูกต้อง',
                          'ของหนังสือรับรองการเป็นทนายความผู้ทําคํารับรองลายมือชื่อและเอกสาร',
                          isSign,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NsaReportCertifyPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
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
                      color: Color(0xFF758C29),
                    ),
                  ),
                ),
              Container(
                width: 35.0,
                height: 35.0,
                margin: EdgeInsets.only(top: 55, left: 15, bottom: 100),
                // padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuV4(),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/nsa_back.png',
                    // color: Colors.white,
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
    setState(() {
      _loading = true;
    });
    _callRead();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    _futureProfile = postDio(profileReadApi, {'code': profileCode});
    _model = await _futureProfile;

    if (_model['idcard'] != '' && _model['idcard'] != null) {
      _futureSign = postDio(registerSignReadApi, {'card_id': _model['idcard']});
      _modelSign = await _futureSign;

      setState(() {
        if (_modelSign.length > 0) {
          isSign = true;
        } else {
          isSign = false;
        }
      });
    }
    setState(() {
      _loading = false;
    });
  }

  // _callReadT01() async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   profileCode = await storage.read(key: 'profileCode18');

  //   _futureReporterT01 = postDio(trackingReadApi, {'code': profileCode});
  //   _modelT01 = await _futureReporterT01;

  //   if (_modelT01.length > 0) {
  //     final firstEntry = _modelT01[0];
  //     if (firstEntry['paymentImageUrl'] != '' &&
  //         firstEntry['paymentTime'] != '' &&
  //         firstEntry['paymentDate'] != '') {
  //       setState(() {
  //         _loading = false;
  //       });
  //       // return _dialogSuccess();
  //     } else {
  //       setState(() {
  //         _loading = false;
  //       });
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => NsaReport1Page(model: firstEntry),
  //         ),
  //       );
  //     }
  //   } else {
  //     setState(() {
  //       _loading = false;
  //     });
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => NsaReport1Page(model: _modelSign[0]),
  //       ),
  //     );
  //   }
  // }

  _buildMenu(
    String title,
    String detail,
    bool isColorFilter, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: () {
        isColorFilter ? onTap!() : null;
      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/img_menu.png'),
                      fit: BoxFit.cover,
                      colorFilter: !isColorFilter
                          ? ColorFilter.mode(
                              Colors.grey.withOpacity(0.8),
                              BlendMode.saturation,
                            )
                          : null,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  height: 120,
                  width: 120,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 10, top: 10),
                    padding: EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Color(0xFFFFFFFF),
                    ),
                    width: 120,
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: !isColorFilter
                                ? Colors.grey
                                : Color(0xFF758C29),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          detail,
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
    );
  }

  Future<dynamic> _dialogStatus(String title, String subTitle) async {
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
              width: MediaQuery.of(context).size.height / 100 * 40,
              height: 200,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFED6B2D),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width:
                                MediaQuery.of(context).size.height / 100 * 14,

                            height: 40,
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.5),
                              color: Color(0xFF758C29),
                            ),
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
                        ),
                      ],
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

  void checkExpireDate(BuildContext context) {
    print('---1---${_modelSign[0]}');
    final String expireDate = _modelSign[0]['expiredate_id'];

    if (!mounted) return; // ตรวจสอบว่า Widget ยังอยู่ใน tree
    final DateTime expireDateTime = DateTime(
      int.parse(expireDate.substring(0, 4)) - 543, // แปลง พ.ศ. เป็น ค.ศ.
      int.parse(expireDate.substring(4, 6)), // เดือน
      int.parse(expireDate.substring(6, 8)), // วัน
    );

    final DateTime currentDate = DateTime.now();

    if (expireDateTime.isBefore(currentDate)) {
      _dialogStatus('แจ้งเตือน!',
          'ข้อมูลของท่านหมดอายุแล้ว กรุณาเลือก ทรอ.1 เพื่อขึ้นทะเบียนใหม่');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NsaReport2Page(model: _modelSign),
        ),
      );
    }
  }

  nextStep() async {}
}
