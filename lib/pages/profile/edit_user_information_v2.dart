import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lc/component/header.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v3/menu_v3.dart';
import 'package:lc/v3/widget/header_v3.dart';
import 'package:lc/widget/header_v2.dart';
import 'package:lc/widget/text_form_field.dart';

import '../../widget/dialog.dart';
import '../auth/login_new.dart';

class EditUserInformationV2Page extends StatefulWidget {
  const EditUserInformationV2Page({super.key});

  @override
  _EditUserInformationV2PageState createState() =>
      _EditUserInformationV2PageState();
}

class _EditUserInformationV2PageState extends State<EditUserInformationV2Page> {
  final storage = new FlutterSecureStorage();

  late String _imageUrl = '';
  late String _code;

  final _formKey = GlobalKey<FormState>();

  List<String> _itemPrefixName = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;

  List<dynamic> _itemSex = [
    {'title': 'ชาย', 'code': 'ชาย'},
    {'title': 'หญิง', 'code': 'หญิง'},
    {'title': 'ไม่ระบุเพศ', 'code': ''}
  ];
  late String _selectedSex;

  List<dynamic> _itemPosition = [];
  late String _selectedPosition;

  List<dynamic> _itemProvince = [];
  late String _selectedProvince;

  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict;

  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict;

  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode;

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtPrefixName = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtUsername = TextEditingController();
  final txtIdCard = TextEditingController();
  final txtLineID = TextEditingController();
  final txtOfficerCode = TextEditingController();
  final txtAddress = TextEditingController();
  final txtMoo = TextEditingController();
  final txtSoi = TextEditingController();
  final txtRoad = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

  late XFile _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  String _categorySocial = '';
  String _imageUrlSocial = '';
  late String profileCode;
  late String _firstName;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    futureModel = getUser();

    scrollController = ScrollController();
    var now = new DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    super.initState();
  }

  void logout() async {
    var category = await storage.read(key: 'profileCategory');

    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    if (category == 'google') {
      _googleSignIn.signOut();
    } else if (category == 'facebook') {
      // await facebookSignIn.logOut();
    }

    // delete
    await storage.deleteAll();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<dynamic> getPosition() async {
    final result = await postObjectData("position/read", {});
    // print('----------------------------');
    if (result['status'] == 'S') {
      setState(() {
        _itemPosition = result['objectData'];
      });
    }
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = result['objectData'];
      });
    }
  }

  Future<dynamic> getDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedProvince,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedProvince,
      'district': _selectedDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemSubDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedSubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemPostalCode = result['objectData'];
      });
    }
  }

  bool isValidDate(String input) {
    try {
      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);
      return input == originalFormatString;
    } catch (e) {
      return false;
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  Future<dynamic> getUser() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    var categorySocial = await storage.read(key: 'categorySocial');
    if (categorySocial != '' && categorySocial != null)
      setState(() {
        _categorySocial = categorySocial;
      });

    var imageUrlSocial = await storage.read(key: 'imageUrlSocial');
    if (imageUrlSocial != '' && imageUrlSocial != null)
      setState(() {
        _imageUrlSocial = imageUrlSocial;
      });

    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        _code = user['code'];
      });

      final result = await postObjectData("m/Register/read", {
        'code': _code,
      });

      if (result['status'] == 'S') {
        await storage.write(
          key: 'dataUserLoginLC',
          value: jsonEncode(result['objectData'][0]),
        );

        if (result['objectData'][0]['birthDay'] != '') {
          if (isValidDate(result['objectData'][0]['birthDay'])) {
            var date = result['objectData'][0]['birthDay'];
            var year = date.substring(0, 4);
            var month = date.substring(4, 6);
            var day = date.substring(6, 8);
            DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
            setState(() {
              _selectedYear = todayDate.year;
              _selectedMonth = todayDate.month;
              _selectedDay = todayDate.day;
              txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
            });
          }
        }

        setState(() {
          _firstName = result['objectData'][0]['firstName'] ?? '';
          _imageUrl = result['objectData'][0]['imageUrl'] ?? '';
          txtFirstName.text = result['objectData'][0]['firstName'] ?? '';
          txtLastName.text = result['objectData'][0]['lastName'] ?? '';
          txtEmail.text = result['objectData'][0]['email'] ?? '';
          txtPhone.text = result['objectData'][0]['phone'] ?? '';
          _selectedPrefixName = result['objectData'][0]['prefixName'];
          _code = result['objectData'][0]['code'] ?? '';
          txtPhone.text = result['objectData'][0]['phone'] ?? '';
          txtUsername.text = result['objectData'][0]['username'] ?? '';
          txtIdCard.text = result['objectData'][0]['idcard'] ?? '';
          txtLineID.text = result['objectData'][0]['lineID'] ?? '';
          txtOfficerCode.text = result['objectData'][0]['officerCode'] ?? '';
          txtAddress.text = result['objectData'][0]['address'] ?? '';
          txtMoo.text = result['objectData'][0]['moo'] ?? '';
          txtSoi.text = result['objectData'][0]['soi'] ?? '';
          txtRoad.text = result['objectData'][0]['road'] ?? '';
          txtPrefixName.text = result['objectData'][0]['prefixName'] ?? '';

          _selectedProvince = result['objectData'][0]['provinceCode'] ?? '';
          _selectedDistrict = result['objectData'][0]['amphoeCode'] ?? '';
          _selectedSubDistrict = result['objectData'][0]['tambonCode'] ?? '';
          _selectedPostalCode = result['objectData'][0]['postnoCode'] ?? '';
          _selectedSex = result['objectData'][0]['sex'] ?? '';
          _selectedPosition = result['objectData'][0]['position'] ?? '';
        });
      }
      if (_selectedProvince != '') {
        getProvince();
        getDistrict();
        getSubDistrict();
        // setState(() {
        //   futureModel =
        getPostalCode();
        // });
      } else {
        // setState(() {
        //   futureModel =
        getProvince();

        // });
      }

      getPosition();
    }
  }

  Future<dynamic> submitUpdateUser() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);
    user['imageUrl'] = _imageUrl;
    // user['prefixName'] = _selectedPrefixName ;
    user['prefixName'] = txtPrefixName.text;
    user['firstName'] = txtFirstName.text;
    user['lastName'] = txtLastName.text;
    user['email'] = txtEmail.text;
    user['phone'] = txtPhone.text;

    user['birthDay'] = DateFormat("yyyyMMdd").format(
      DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
    );
    user['sex'] = _selectedSex;
    user['address'] = txtAddress.text;
    user['soi'] = txtSoi.text;
    user['moo'] = txtMoo.text;
    user['road'] = txtRoad.text;
    user['tambon'] = '';
    user['amphoe'] = '';
    user['province'] = '';
    user['postno'] = '';
    user['tambonCode'] = _selectedSubDistrict;
    user['amphoeCode'] = _selectedDistrict;
    user['provinceCode'] = _selectedProvince;
    user['postnoCode'] = _selectedPostalCode;
    user['idcard'] = txtIdCard.text;
    user['officerCode'] = txtOfficerCode.text;
    user['linkAccount'] =
        user['linkAccount'] != null ? user['linkAccount'] : '';
    user['appleID'] = user['appleID'] != null ? user['appleID'] : "";
    user['position'] = _selectedPosition;

    print('------------------------$_selectedPosition--------------------');
    final result = await postObjectData('m/Register/update', user);

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginLC',
        value: jsonEncode(result['objectData']),
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => UserInformationPage(),
      //   ),
      // );

      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: const Text(
                'อัพเดตข้อมูลเรียบร้อยแล้ว',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF9A1120),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => MenuV3(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                    // goBack();
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'อัพเดตข้อมูลไม่สำเร็จ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: new Text(
                result['message'],
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF9A1120),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        txtFirstName.text = user['firstName'] ?? '';
        txtLastName.text = user['lastName'] ?? '';
        txtEmail.text = user['email'] ?? '';
        txtPhone.text = user['phone'] ?? '';
        _selectedPrefixName = user['prefixName'];
        txtPrefixName.text = user['prefixName'] ?? '';
        _code = user['code'];
        _selectedProvince = user['provinceCode'] ?? '';
        _selectedDistrict = user['amphoeCode'] ?? '';
        _selectedSubDistrict = user['tambonCode'] ?? '';
        _selectedPostalCode = user['postnoCode'] ?? '';
      });

      if (user['birthDay'] != '') {
        var date = user['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);

        setState(() {
          _selectedYear = todayDate.year;
          _selectedMonth = todayDate.month;
          _selectedDay = todayDate.day;
          txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
        });
      }

      if (_selectedProvince != '') {
        getProvince();
        getDistrict();
        getSubDistrict();
        getPostalCode();
        // setState(() {
        //   futureModel = getUser();
        // });
      } else {
        getProvince();
        // setState(() {
        //   futureModel = getUser();
        // });
      }
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: contentCard()),
    );
  }

  dialogOpenPickerDate() {
    dt_picker.DatePicker.showDatePicker(
      context,
      theme: const dt_picker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(year, month, day),
      onConfirm: (date) {
        setState(
          () {
            _selectedYear = date.year;
            _selectedMonth = date.month;
            _selectedDay = date.day;
            txtDate.value = TextEditingValue(
              text: DateFormat("dd-MM-yyyy").format(date),
            );
          },
        );
      },
      currentTime: DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
      locale: dt_picker.LocaleType.th,
    );
  }

  contentCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // if (_categorySocial != '')
            //   FlatButton(
            //     color: Colors.black,
            //     shape: new RoundedRectangleBorder(
            //       borderRadius: new BorderRadius.circular(5.0),
            //     ),
            //     onPressed: () {
            //       print(_imageUrlSocial);

            //       setState(() {
            //         _imageUrl = _imageUrlSocial;
            //       });
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(
            //           Icons.image,
            //           color: Colors.white,
            //         ),
            //         Text(
            //           ' ใช้รูปโปรไฟล์จาก ' + _categorySocial,
            //           style: TextStyle(
            //             fontSize: 18.00,
            //             fontFamily: 'Kanit',
            //             // fontWeight: FontWeight.w500,
            //             color: Color(0xFFFFFFFF),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // Padding(
            //   padding: EdgeInsets.only(top: 5.0),
            // ),
            // Text(
            //   'ข้อมูลผู้ใช้งาน',
            //   style: TextStyle(
            //     fontSize: 18.00,
            //     fontFamily: 'Kanit',
            //     fontWeight: FontWeight.w500,
            //     // color: Color(0xFFBC0611),
            //   ),
            // ),
            // SizedBox(height: 5.0),
            // labelTextFormField('Username'),
            // textFormField(
            //   txtUsername,
            //   null,
            //   'ชื่อผู้ใช้งาน',
            //   'ชื่อผู้ใช้งาน',
            //   false,
            //   false,
            //   false,
            // ),

            // Text(
            //   'ข้อมูลส่วนตัว',
            //   style: TextStyle(
            //     fontSize: 18.00,
            //     fontFamily: 'Kanit',
            //     fontWeight: FontWeight.w500,
            //     // color: Color(0xFFBC0611),
            //   ),
            // ),

            SizedBox(height: 20),
            textFormFieldV2(
              txtPrefixName,
              '',
              'คำนำหน้า',
              'คำนำหน้า',
              'คำนำหน้า',
              true,
              false,
              false,
            ),
            // new Container(
            //   width: 5000.0,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFEEBA33),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   // child: DropdownButtonHideUnderline(
            //   child: DropdownButtonFormField(
            //     decoration: InputDecoration(
            //       errorStyle: TextStyle(
            //         fontWeight: FontWeight.normal,
            //         fontFamily: 'Kanit',
            //         fontSize: 10.0,
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //     validator: (value) =>
            //         value == '' || value == null ? 'กรุณาเลือกคำนำหน้า' : null,
            //     hint: Text(
            //       'กรุณาเลือกคำนำหน้า',
            //       style: TextStyle(
            //         fontSize: 15.00,
            //         fontFamily: 'Kanit',
            //       ),
            //     ),
            //     value: _selectedPrefixName != '' ? _selectedPrefixName : '',

            //     onChanged: (newValue) {
            //       setState(() {
            //         _selectedPrefixName = newValue;
            //       });
            //     },
            //     items: _itemPrefixName.map((prefixName) {
            //       return DropdownMenuItem(
            //         child: new Text(
            //           prefixName,
            //           style: TextStyle(
            //             fontSize: 15.00,
            //             fontFamily: 'Kanit',
            //             color: Color(
            //               0xFF9A1120,
            //             ),
            //           ),
            //         ),
            //         value: prefixName,
            //       );
            //     }).toList(),
            //   ),
            //   // ),
            // ),
            SizedBox(height: 20),
            textFormFieldV2(
              txtFirstName,
              '',
              'ชื่อ',
              'ชื่อ',
              'ชื่อ',
              true,
              false,
              false,
            ),
            SizedBox(height: 20),
            textFormFieldV2(
              txtLastName,
              '',
              'นามสกุล',
              'นามสกุล',
              'นามสกุล',
              true,
              false,
              false,
            ),

            // labelTextFormField('* วันเดือนปีเกิด'),
            // GestureDetector(
            //   onTap: () => dialogOpenPickerDate(),
            //   child: AbsorbPointer(
            //     child: TextFormField(
            //       controller: txtDate,
            //       style: TextStyle(
            //         color: Color(0xFF9A1120),
            //         fontWeight: FontWeight.normal,
            //         fontFamily: 'Kanit',
            //         fontSize: 15.0,
            //       ),
            //       decoration: InputDecoration(
            //         filled: true,
            //         fillColor: Color(0xFFEEBA33),
            //         contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            //         hintText: "วันเดือนปีเกิด",
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(10.0),
            //           borderSide: BorderSide.none,
            //         ),
            //         errorStyle: TextStyle(
            //           fontWeight: FontWeight.normal,
            //           fontFamily: 'Kanit',
            //           fontSize: 10.0,
            //         ),
            //       ),
            //       // validator: (model) {
            //       //   if (model.isEmpty) {
            //       //     return 'กรุณากรอกวันเดือนปีเกิด.';
            //       //   }
            //       // },
            //     ),
            //   ),
            // ),
            // labelTextFormField('* รหัสประจำตัวประชาชน'),
            // textFormIdCardField(
            //   txtIdCard,
            //   'รหัสประจำตัวประชาชน',
            //   'รหัสประจำตัวประชาชน',
            //   true,
            // ),

            // labelTextFormField('Line ID'),
            // textFormFieldNoValidator(
            //   txtLineID,
            //   'Line ID',
            //   true,
            //   false,
            // ),
            // labelTextFormField('* รหัสสมาชิก'),
            // textFormField(
            //   txtOfficerCode,
            //   null,
            //   'รหัสสมาชิก',
            //   'รหัสสมาชิก',
            //   true,
            //   false,
            //   false,
            // ),

            SizedBox(height: 20),
            textFormPhoneFieldV2(
              txtPhone,
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              true,
              true,
            ),
            SizedBox(height: 20),
            textFormFieldNoValidatorV2(
              txtEmail,
              'อีเมล',
              'อีเมล',
              false,
              false,
            ),
            // labelTextFormField('ตำแหน่ง'),
            // new Container(
            //   width: 5000.0,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFEEBA33),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   child: _selectedPosition != ''
            //       ? DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           // validator: (value) => value == '' || value == null
            //           //     ? 'กรุณาเลือกจังหวัด'
            //           //     : null,
            //           hint: Text(
            //             'ตำแหน่ง',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           value: _selectedPosition,
            //           onChanged: (newValue) {
            //             setState(() {
            //               // _selectedDistrict = "";
            //               // _itemDistrict = [];
            //               // _selectedSubDistrict = "";
            //               // _itemSubDistrict = [];
            //               // _selectedPostalCode = "";
            //               // _itemPostalCode = [];
            //               _selectedPosition = newValue;
            //             });
            //             // getDistrict();
            //           },
            //           items: _itemPosition.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         )
            //       : DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           // validator: (value) =>
            //           //     value == '' || value == null ? 'กรุณาตำแหน่ง' : null,
            //           hint: Text(
            //             'ตำแหน่ง',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           onChanged: (newValue) {
            //             setState(() {
            //               // _selectedDistrict = "";
            //               // _itemDistrict = [];
            //               // _selectedSubDistrict = "";
            //               // _itemSubDistrict = [];
            //               // _selectedPostalCode = "";
            //               // _itemPostalCode = [];
            //               _selectedPosition = newValue;
            //             });
            //             // getDistrict();
            //           },
            //           items: _itemPosition.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         ),
            // ),
            // labelTextFormField('* เพศ'),

            // new Container(
            //   width: 5000.0,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFEEBA33),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   child: DropdownButtonFormField(
            //     decoration: InputDecoration(
            //       errorStyle: TextStyle(
            //         fontWeight: FontWeight.normal,
            //         fontFamily: 'Kanit',
            //         fontSize: 10.0,
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //     validator: (value) =>
            //         // value == '' ||
            //         value == null ? 'กรุณาเลือกเพศ' : null,
            //     hint: Text(
            //       'เพศ',
            //       style: TextStyle(
            //         fontSize: 15.00,
            //         fontFamily: 'Kanit',
            //       ),
            //     ),
            //     value: _selectedSex,
            //     onChanged: (newValue) {
            //       setState(() {
            //         _selectedSex = newValue;
            //       });
            //     },
            //     items: _itemSex.map((item) {
            //       return DropdownMenuItem(
            //         child: new Text(
            //           item['title'],
            //           style: TextStyle(
            //             fontSize: 15.00,
            //             fontFamily: 'Kanit',
            //             color: Color(
            //               0xFF9A1120,
            //             ),
            //           ),
            //         ),
            //         value: item['code'],
            //       );
            //     }).toList(),
            //   ),
            // ),
            // labelTextFormField('ที่อยู่ปัจจุบัน'),
            // textFormFieldNoValidator(
            //   txtAddress,
            //   'ที่อยู่ปัจจุบัน',
            //   true,
            //   false,
            // ),
            // labelTextFormField('หมู่ที่'),
            // textFormFieldNoValidator(
            //   txtMoo,
            //   'หมู่ที่',
            //   true,
            //   false,
            // ),
            // labelTextFormField('ซอย'),
            // textFormFieldNoValidator(
            //   txtSoi,
            //   'ซอย',
            //   true,
            //   false,
            // ),
            // labelTextFormField('ถนน'),
            // textFormFieldNoValidator(
            //   txtRoad,
            //   'ถนน',
            //   true,
            //   false,
            // ),
            // labelTextFormField('* จังหวัด'),
            // new Container(
            //   width: 5000.0,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFEEBA33),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   child: _selectedProvince != ''
            //       ? DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           validator: (value) => value == '' || value == null
            //               ? 'กรุณาเลือกจังหวัด'
            //               : null,
            //           hint: Text(
            //             'จังหวัด',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           value: _selectedProvince,
            //           onChanged: (newValue) {
            //             setState(() {
            //               _selectedDistrict = "";
            //               _itemDistrict = [];
            //               _selectedSubDistrict = "";
            //               _itemSubDistrict = [];
            //               _selectedPostalCode = "";
            //               _itemPostalCode = [];
            //               _selectedProvince = newValue;
            //             });
            //             getDistrict();
            //           },
            //           items: _itemProvince.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         )
            //       : DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           validator: (value) => value == '' || value == null
            //               ? 'กรุณาเลือกจังหวัด'
            //               : null,
            //           hint: Text(
            //             'จังหวัด',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           onChanged: (newValue) {
            //             setState(() {
            //               _selectedDistrict = "";
            //               _itemDistrict = [];
            //               _selectedSubDistrict = "";
            //               _itemSubDistrict = [];
            //               _selectedPostalCode = "";
            //               _itemPostalCode = [];
            //               _selectedProvince = newValue;
            //             });
            //             getDistrict();
            //           },
            //           items: _itemProvince.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         ),
            // ),

            // labelTextFormField('* อำเภอ'),

            // new Container(
            //   width: 5000.0,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFEEBA33),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   child: _selectedDistrict != ''
            //       ? DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           validator: (value) => value == '' || value == null
            //               ? 'กรุณาเลือกอำเภอ'
            //               : null,
            //           hint: Text(
            //             'อำเภอ',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           value: _selectedDistrict,
            //           onChanged: (newValue) {
            //             setState(() {
            //               _selectedSubDistrict = "";
            //               _itemSubDistrict = [];
            //               _selectedPostalCode = "";
            //               _itemPostalCode = [];
            //               _selectedDistrict = newValue;
            //               getSubDistrict();
            //             });
            //           },
            //           items: _itemDistrict.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         )
            //       : DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           validator: (value) => value == '' || value == null
            //               ? 'กรุณาเลือกอำเภอ'
            //               : null,
            //           hint: Text(
            //             'อำเภอ',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           onChanged: (newValue) {
            //             setState(() {
            //               _selectedSubDistrict = "";
            //               _itemSubDistrict = [];
            //               _selectedPostalCode = "";
            //               _itemPostalCode = [];
            //               _selectedDistrict = newValue;
            //               getSubDistrict();
            //             });
            //           },
            //           items: _itemDistrict.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         ),
            // ),

            // labelTextFormField('* ตำบล'),
            // new Container(
            //   width: 5000.0,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFEEBA33),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   child: _selectedSubDistrict != ''
            //       ? DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           validator: (value) => value == '' || value == null
            //               ? 'กรุณาเลือกตำบล'
            //               : null,
            //           hint: Text(
            //             'ตำบล',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           value: _selectedSubDistrict,
            //           onChanged: (newValue) {
            //             setState(() {
            //               _selectedPostalCode = "";
            //               _itemPostalCode = [];
            //               _selectedSubDistrict = newValue;
            //               getPostalCode();
            //             });
            //           },
            //           items: _itemSubDistrict.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         )
            //       : DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           validator: (value) => value == '' || value == null
            //               ? 'กรุณาเลือกตำบล'
            //               : null,
            //           hint: Text(
            //             'ตำบล',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           onChanged: (newValue) {
            //             setState(() {
            //               _selectedPostalCode = "";
            //               _itemPostalCode = [];
            //               _selectedSubDistrict = newValue;
            //               getPostalCode();
            //             });
            //           },
            //           items: _itemSubDistrict.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['title'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         ),
            // ),
            // labelTextFormField('* รหัสไปรษณีย์'),

            // new Container(
            //   width: 5000.0,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFEEBA33),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   child: _selectedPostalCode != ''
            //       ? DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           validator: (value) => value == '' || value == null
            //               ? 'กรุณาเลือกรหัสไปรษณีย์'
            //               : null,
            //           hint: Text(
            //             'รหัสไปรษณีย์',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           value: _selectedPostalCode,
            //           onChanged: (newValue) {
            //             setState(() {
            //               _selectedPostalCode = newValue;
            //             });
            //           },
            //           items: _itemPostalCode.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['postCode'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         )
            //       : DropdownButtonFormField(
            //           decoration: InputDecoration(
            //             errorStyle: TextStyle(
            //               fontWeight: FontWeight.normal,
            //               fontFamily: 'Kanit',
            //               fontSize: 10.0,
            //             ),
            //             enabledBorder: UnderlineInputBorder(
            //               borderSide: BorderSide(
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ),
            //           validator: (value) => value == '' || value == null
            //               ? 'กรุณาเลือกรหัสไปรษณีย์'
            //               : null,
            //           hint: Text(
            //             'รหัสไปรษณีย์',
            //             style: TextStyle(
            //               fontSize: 15.00,
            //               fontFamily: 'Kanit',
            //             ),
            //           ),
            //           onChanged: (newValue) {
            //             setState(() {
            //               _selectedPostalCode = newValue;
            //             });
            //           },
            //           items: _itemPostalCode.map((item) {
            //             return DropdownMenuItem(
            //               child: new Text(
            //                 item['postCode'],
            //                 style: TextStyle(
            //                   fontSize: 15.00,
            //                   fontFamily: 'Kanit',
            //                   color: Color(
            //                     0xFF9A1120,
            //                   ),
            //                 ),
            //               ),
            //               value: item['code'],
            //             );
            //           }).toList(),
            //         ),
            // ),
            Padding(
              padding: EdgeInsets.only(top: 25.0),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  color: Color(0xFFED6B2D),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form!.validate()) {
                        form.save();
                        submitUpdateUser();
                      }
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
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 5),
              child: InkWell(
                onTap: () => {
                  dialog(
                    context,
                    title: 'คุณต้องการลบบัญชี',
                    description:
                        'คุณต้องการลบบัญชีออกจาก สภาทนายความ ใช่หรือไม่',
                    isYesNo: true,
                    btnOk: 'ใช่',
                    btnCancel: 'ไม่ใช่',
                    callBack: (data) {
                      if (data) {
                        postDio('${server}m/Register/delete',
                            {"code": profileCode, "updateBy": _firstName});
                        logout();
                      }
                    },
                  ),
                },
                child: Text(
                  'ลบบัญชี',
                  style: new TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            child: new Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(
                urlImage,
                height: 5.0,
                width: 5.0,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: new TextStyle(
                fontSize: 12.0,
                color: Color(0xFF9A1120),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  _imgFromGallery() async {
    // XFile image = await ImagePicker.pickImage(
    //   source: ImageSource.gallery,
    //   imageQuality: 100,
    // );

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  _imgFromNow() async {
    setState(() {
      _imageUrl = _imageUrlSocial;
    });
  }

  void _upload() async {
    if (_image == null) return;

    uploadImageX(_image).then((res) {
      setState(() {
        _imageUrl = res;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      'อัลบั้มรูปภาพ',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
                if (_categorySocial != '')
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(
                      ' ใช้รูปโปรไฟล์จาก ' + _categorySocial,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      _imgFromNow();
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerV3(context, goBack, title: 'บัญชีผู้ใช้งาน'),
      backgroundColor: Color(0xFFFFFFFF),
      body: FutureBuilder<dynamic>(
        future: futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Container(
              color: Colors.white,
              child: dialogFail(context),
            ));
          } else {
            return Container(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          margin: EdgeInsets.only(top: 30.0),
                          padding: EdgeInsets.all(
                              _imageUrl != null && _imageUrl != '' ? 0.0 : 5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.white70),
                          child: GestureDetector(
                            onTap: () {
                              // _showPickerImage(context);
                            },
                            child: _imageUrl != null && _imageUrl != ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      _imageUrl,
                                      fit: BoxFit.cover,
                                      height: 130,
                                      // width: 100,
                                    ),
                                  )
                                : Container(
                                    padding: EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      'assets/images/user_not_found.png',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      // Center(
                      //   child: Container(
                      //     width: 25.0,
                      //     height: 25.0,
                      //     margin: EdgeInsets.only(top: 90.0, left: 70.0),
                      //     child: Padding(
                      //       padding: EdgeInsets.all(0.0),
                      //       child: DecoratedBox(
                      //         decoration: ShapeDecoration(
                      //           shape: CircleBorder(),
                      //           image: DecorationImage(
                      //             fit: BoxFit.contain,
                      //             alignment: Alignment.center,
                      //             image: AssetImage(
                      //                 "assets/logo/icons/Group37.png"),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        _showPickerImage(context);
                      },
                      child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text('เปลี่ยนรูปโปรไฟล์',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF8AD2FF),
                                  decoration: TextDecoration.underline))),
                    ),
                  ),
                  Container(
                    // color: Color(0xFFF7F7F7),
                    color: Color(0xFFFFFFFF),
                    child: contentCard(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
