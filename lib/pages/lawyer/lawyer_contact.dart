import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/widget/header_v2.dart';

import '../../component/header.dart';
import '../../widget/text_form_field.dart';

// ignore: must_be_immutable
class LawyerContact extends StatefulWidget {
  LawyerContact({
    Key? key,
    required this.code,
    required this.url,
    this.model,
  }) : super(key: key);

  final String code;
  final String url;
  final dynamic model;

  @override
  _LawyerContact createState() => _LawyerContact();
}

class _LawyerContact extends State<LawyerContact> {
  final storage = new FlutterSecureStorage();

  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];
  bool isShowContact = false;
  final txtoPhone = TextEditingController();
  final txtoEmail = TextEditingController();
  final txtOffice = TextEditingController();

  @override
  void initState() {
    super.initState();
    _read();
  }

  _read() async {
    setState(() {
      txtoEmail.text = widget.model['oemail'] ?? '';
      txtoPhone.text = widget.model['ophone'] ?? '';
      txtOffice.text = widget.model['office_t'] ?? '';
      isShowContact = widget.model['isShowContact'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: headerV2(context, goBack, title: 'ข้อมูลการติดต่อ'),
        // backgroundColor: Color(0xFFF7F7F7),
        backgroundColor: Color(0xFFFFFFFF),
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowIndicator();
              return false;
            },
            child: myContent(context, widget.model)),
      ),
    );
  }

  myContent(BuildContext context, dynamic model) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    'แสดงข้อมูลติดต่อ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  child: Transform.scale(
                    scale: 1.5,
                    child: Switch(
                      value: isShowContact,
                      onChanged: (value) {
                        setState(() {
                          isShowContact = value;
                          submitUpdateUser();
                        });
                      },
                      activeTrackColor: Color(0xFF8AD2FF),
                      activeColor: Color(0xFF2D9CED),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isShowContact
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      textFormFieldV2(
                        txtoPhone,
                        '',
                        'เบอร์โทรศัพท์',
                        'เบอร์โทรศัพท์',
                        'เบอร์โทรศัพท์',
                        true,
                        false,
                        false,
                      ),
                      SizedBox(height: 25),
                      textFormFieldV2(
                        txtoEmail,
                        '',
                        'อีเมล',
                        'อีเมล',
                        'อีเมล',
                        true,
                        false,
                        false,
                      ),
                      SizedBox(height: 25),
                      textFormFieldV2(
                        txtOffice,
                        '',
                        'ชื่อสำนักงาน',
                        'ชื่อสำนักงาน',
                        'ชื่อสำนักงาน',
                        true,
                        false,
                        false,
                      ),
                    ],
                  ),
                )
              : Container(),
          isShowContact
              ? Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(25.0),
                        color: Color(0xFFED6B2D),
                        child: MaterialButton(
                          height: 40,
                          onPressed: () {
                            submitUpdateUser();
                          },
                          child: new Text(
                            'บันทึกข้อมูล',
                            style: new TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 25)
        ],
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context);
  }

  Future<dynamic> submitUpdateUser() async {
    // var value = await storage.read(key: 'dataUserLoginLC');
    // var user = json.decode(value);
    dynamic user = {};

    user['ophone'] = txtoPhone.text ?? '';
    user['oemail'] = txtoEmail.text ?? '';
    user['office_t'] = txtOffice.text ?? '';
    user['isShowContact'] = isShowContact;

    await postDio(server + 'm/register/updateContact', user);

    // if (result['status'] == 'S') {
    //   await storage.write(
    //     key: 'dataUserLoginLC',
    //     value: jsonEncode(result['objectData']),
    //   );

    //   return showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return WillPopScope(
    //         onWillPop: () {
    //           return Future.value(false);
    //         },
    //         child: CupertinoAlertDialog(
    //           title: new Text(
    //             'อัพเดตข้อมูลเรียบร้อยแล้ว',
    //             style: TextStyle(
    //               fontSize: 16,
    //               fontFamily: 'Kanit',
    //               color: Colors.black,
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           content: Text(" "),
    //           actions: [
    //             CupertinoDialogAction(
    //               isDefaultAction: true,
    //               child: new Text(
    //                 "ตกลง",
    //                 style: TextStyle(
    //                   fontSize: 13,
    //                   fontFamily: 'Kanit',
    //                   color: Color(0xFF9A1120),
    //                   fontWeight: FontWeight.normal,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 // Navigator.of(context).pushAndRemoveUntil(
    //                 //   MaterialPageRoute(
    //                 //     builder: (context) => MenuV2(),
    //                 //   ),
    //                 //   (Route<dynamic> route) => false,
    //                 // );
    //                 // goBack();
    //                 // Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // } else {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return WillPopScope(
    //         onWillPop: () {
    //           return Future.value(false);
    //         },
    //         child: CupertinoAlertDialog(
    //           title: new Text(
    //             'อัพเดตข้อมูลไม่สำเร็จ',
    //             style: TextStyle(
    //               fontSize: 16,
    //               fontFamily: 'Kanit',
    //               color: Colors.black,
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           content: new Text(
    //             result['message'],
    //             style: TextStyle(
    //               fontSize: 13,
    //               fontFamily: 'Kanit',
    //               color: Colors.black,
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           actions: [
    //             CupertinoDialogAction(
    //               isDefaultAction: true,
    //               child: new Text(
    //                 "ตกลง",
    //                 style: TextStyle(
    //                   fontSize: 13,
    //                   fontFamily: 'Kanit',
    //                   color: Color(0xFF9A1120),
    //                   fontWeight: FontWeight.normal,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }
  }
}
