import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v3/widget/header_v3.dart';
import 'package:lc/widget/text_form_field.dart';

import '../../data_error.dart';

import '../../widget/stack_tap.dart';

// ignore: must_be_immutable
class IdentityVerificationV2Page extends StatefulWidget {
  IdentityVerificationV2Page({super.key, required this.title});
  String title;

  @override
  // ignore: library_private_types_in_public_api
  _IdentityVerificationV2PageState createState() =>
      _IdentityVerificationV2PageState();
}

class _IdentityVerificationV2PageState
    extends State<IdentityVerificationV2Page> {
  final storage = const FlutterSecureStorage();

  late String _imageUrl;
  late String _code;
  late String _username;

  final _formKey = GlobalKey<FormState>();
  final _formOrganizationKey = GlobalKey<FormState>();

  final List<String> _itemPrefixName = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;
  dynamic categoryModel = {'provinceTitle': ''};

  final List<dynamic> _itemSex = [
    {'title': 'ชาย', 'code': 'ชาย'},
    {'title': 'หญิง', 'code': 'หญิง'},
    {'title': 'ไม่ระบุเพศ', 'code': 'ไม่ระบุเพศ'}
  ];
  late String _selectedSex;

  List<dynamic> _itemProvince = [];
  late String _selectedProvince;

  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict;

  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict;

  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode;

  final List<dynamic> _itemOrganizationLv0 = [];
  late PageController pageController;
  int currentPage = 0;
  late Future<dynamic> _futureShopLv1;
  late Future<dynamic> _futureShopLv2;
  late Future<dynamic> _futureShopLv3;
  String titleCategoryLv1 = '';
  String titleCategoryLv2 = '';
  String titleCategoryLv3 = '';
  String titleCategoryLv4 = '';

  String selectedCodeLv1 = '';
  String selectedCodeLv2 = '';
  String selectedCodeLv3 = '';
  String selectedCodeLv4 = '';
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

  late Future<dynamic> futureModel = Future.value();

  ScrollController scrollController = ScrollController();

  late File _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  bool openOrganization = false;
  List<dynamic> _itemLv0 = [];
  late String _selectedLv0;
  late String _selectedTitleLv0;
  List<dynamic> _itemLv1 = [];
  late String _selectedLv1;
  late String _selectedTitleLv1;
  List<dynamic> _itemLv2 = [];
  late String _selectedLv2;
  late String _selectedTitleLv2;
  List<dynamic> _itemLv3 = [];
  late String _selectedLv3;
  late String _selectedTitleLv3;
  List<dynamic> _itemLv4 = [];
  late String _selectedLv4;
  late String _selectedTitleLv4;
  List<dynamic> _itemLv5 = [];
  late String _selectedLv5;
  late String _selectedTitleLv5;
  int totalLv = 0;

  List<dynamic> dataCountUnit = [];

  List<dynamic> dataPolicy = [];

  @override
  void initState() {
    pageController = PageController(initialPage: currentPage);
    // readStorage();
    getUser();
    getOrganizationLv0();
    _callReadProvince(categoryModel);

    scrollController = ScrollController();
    var now = DateTime.now();
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
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
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
          return Scaffold(
            appBar: headerV3(context, goBack, title: widget.title),
            backgroundColor: const Color(0xFFFFFFFF),
            body: Container(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: contentCard(),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  Future<dynamic> getPolicy() async {
    final result = await postObjectData("m/policy/read", {
      "category": "application",
      "username": _username,
    });
    if (result['status'] == 'S') {
      if (result['objectData'].length > 0) {
        for (var i in result['objectData']) {
          result['objectData'][i].isActive = "";
          result['objectData'][i].agree = false;
          result['objectData'][i].noAgree = false;
        }
        setState(() {
          dataPolicy = result['objectData'];
        });
      }
    }
  }

  Future<dynamic> getOrganizationLv0() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv0",
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv0 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv1() async {
    setState(() {
      _selectedLv1 = "";
      _selectedTitleLv1 = "";
      _itemLv1 = [];
    });

    final result = await postObjectData("organization/category/read", {
      "category": "lv1",
      "lv0": _selectedLv0,
    });

    if (result['status'] == 'S') {
      setState(() {
        _itemLv1 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv2() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv2",
      "lv1": _selectedLv1,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv2 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv3() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv3",
      "lv2": _selectedLv2,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv3 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv4() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv4",
      "lv3": _selectedLv3,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv4 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv5() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv5",
      "lv4": _selectedLv4,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv5 = result['objectData'];
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
          _username = result['objectData'][0]['username'];
          dataCountUnit = result['objectData'][0]['countUnit'] != ''
              ? json.decode(result['objectData'][0]['countUnit'])
              : [];
          _imageUrl = result['objectData'][0]['imageUrl'];
          txtFirstName.text = result['objectData'][0]['firstName'];
          txtLastName.text = result['objectData'][0]['lastName'];
          txtEmail.text = result['objectData'][0]['email'];
          txtPhone.text = result['objectData'][0]['phone'];
          _selectedPrefixName = result['objectData'][0]['prefixName'];
          _code = result['objectData'][0]['code'];
          txtPhone.text = result['objectData'][0]['phone'];
          txtUsername.text = result['objectData'][0]['username'];
          txtIdCard.text = result['objectData'][0]['idcard'];
          txtLineID.text = result['objectData'][0]['lineID'];
          txtOfficerCode.text = result['objectData'][0]['officerCode'];
          txtAddress.text = result['objectData'][0]['address'];
          txtMoo.text = result['objectData'][0]['moo'];
          txtSoi.text = result['objectData'][0]['soi'];
          txtRoad.text = result['objectData'][0]['road'];
          txtPrefixName.text = result['objectData'][0]['prefixName'];

          _selectedProvince = result['objectData'][0]['provinceCode'];
          _selectedDistrict = result['objectData'][0]['amphoeCode'];
          _selectedSubDistrict = result['objectData'][0]['tambonCode'];
          _selectedPostalCode = result['objectData'][0]['postnoCode'];
          _selectedSex = result['objectData'][0]['sex'];
        });
      }
      // if (_selectedProvince != '') {
      //   getPolicy();
      //   getProvince();
      //   getDistrict();
      //   getSubDistrict();
      //   setState(() {
      //     futureModel = getPostalCode();
      //   });
      // } else {
      //   getPolicy();
      //   setState(() {
      //     futureModel = getProvince();
      //   });
      // }

      categoryModel = {
        'provinceTitle': result['objectData'][0]['province'],
        'provinceCode': result['objectData'][0]['provinceCode'],
        'districtTitle': result['objectData'][0]['amphoe'],
        'districtCode': result['objectData'][0]['amphoeCode'],
        'subDistrictTitle': result['objectData'][0]['tambon'],
        'subDistrictCode': result['objectData'][0]['tambonCode'],
        'postCode': result['objectData'][0]['postnoCode'],
      };

      setState(() {
        categoryModel = {
          'provinceTitle': result['objectData'][0]['province'],
          'provinceCode': result['objectData'][0]['provinceCode'],
          'districtTitle': result['objectData'][0]['amphoe'],
          'districtCode': result['objectData'][0]['amphoeCode'],
          'subDistrictTitle': result['objectData'][0]['tambon'],
          'subDistrictCode': result['objectData'][0]['tambonCode'],
          'postCode': result['objectData'][0]['postnoCode'],
        };

        selectedCodeLv1 = (result['objectData'][0]['provinceCode']).toString();
        selectedCodeLv2 = (result['objectData'][0]['amphoeCode']).toString();
        selectedCodeLv3 = (result['objectData'][0]['tambonCode']).toString();
        selectedCodeLv4 = (result['objectData'][0]['postnoCode']);
        titleCategoryLv1 = (result['objectData'][0]['province']);
        titleCategoryLv2 = (result['objectData'][0]['amphoe']);
        titleCategoryLv3 = (result['objectData'][0]['tambon']);
        selectedCodeLv4 = (result['objectData'][0]['postnoCode']);
        // selectedType = data['addressType'];
      });
      _callReadProvince(categoryModel);
    }
  }

  Future<dynamic> submitAddOrganization() async {
    if (dataCountUnit.isNotEmpty) {
      var index = dataCountUnit.indexWhere(
        (c) =>
            c['lv0'] == _selectedLv0 &&
            c['lv1'] == _selectedLv1 &&
            c['lv2'] == _selectedLv2 &&
            c['lv3'] == _selectedLv3 &&
            c['lv4'] == _selectedLv4 &&
            c['lv5'] == _selectedLv5 &&
            c['statud'] != 'A',
      );
      if (index == -1) {
        dataCountUnit.add({
          "lv0": _selectedLv0,
          "titleLv0": _selectedTitleLv0,
          "lv1": _selectedLv1,
          "titleLv1": _selectedTitleLv1,
          "lv2": _selectedLv2,
          "titleLv2": _selectedTitleLv2,
          "lv3": _selectedLv3,
          "titleLv3": _selectedTitleLv3,
          "lv4": _selectedLv4,
          "titleLv4": _selectedTitleLv4,
          "lv5": _selectedLv5,
          "titleLv5": _selectedTitleLv5,
          "status": "V",
        });

        setState(() {
          dataCountUnit = dataCountUnit;
          _selectedLv0 = "";
          _selectedTitleLv0 = "";
          _selectedLv1 = "";
          _selectedTitleLv1 = "";
          _selectedLv2 = "";
          _selectedTitleLv2 = "";
          _selectedLv3 = "";
          _selectedTitleLv3 = "";
          _selectedLv4 = "";
          _selectedTitleLv4 = "";
          _selectedLv5 = "";
          _selectedTitleLv5 = "";
          openOrganization = false;
          totalLv = 0;
        });
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text(
              'ข้อมูลซ้ำ กรุณาเลือกใหม่',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: const Text(''),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text(
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
      }
    } else {
      dataCountUnit.add({
        "lv0": _selectedLv0,
        "titleLv0": _selectedTitleLv0,
        "lv1": _selectedLv1,
        "titleLv1": _selectedTitleLv1,
        "lv2": _selectedLv2,
        "titleLv2": _selectedTitleLv2,
        "lv3": _selectedLv3,
        "titleLv3": _selectedTitleLv3,
        "lv4": _selectedLv4,
        "titleLv4": _selectedTitleLv4,
        "lv5": _selectedLv5,
        "titleLv5": _selectedTitleLv5,
        "status": "V",
      });

      setState(() {
        dataCountUnit = dataCountUnit;
        _selectedLv0 = "";
        _selectedTitleLv0 = "";
        _selectedLv1 = "";
        _selectedTitleLv1 = "";
        _selectedLv2 = "";
        _selectedTitleLv2 = "";
        _selectedLv3 = "";
        _selectedTitleLv3 = "";
        _selectedLv4 = "";
        _selectedTitleLv4 = "";
        _selectedLv5 = "";
        _selectedTitleLv5 = "";
        openOrganization = false;
        totalLv = 0;
      });
    }
  }

  Future<dynamic> submitUpdateUser() async {
    // if (dataCountUnit.length == 0) {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) => new CupertinoAlertDialog(
    //       title: new Text(
    //         'กรุณาเพิ่มหน่วยงานอย่างน้อย 1 หน่วยงาน',
    //         style: TextStyle(
    //           fontSize: 16,
    //           fontFamily: 'Kanit',
    //           color: Colors.black,
    //           fontWeight: FontWeight.normal,
    //         ),
    //       ),
    //       content: Text(''),
    //       actions: [
    //         CupertinoDialogAction(
    //           isDefaultAction: true,
    //           child: new Text(
    //             "ตกลง",
    //             style: TextStyle(
    //               fontSize: 13,
    //               fontFamily: 'Kanit',
    //               color: Color(0xFF9A1120),
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    // } else {
    var codeLv0 = "";
    var codeLv1 = "";
    var codeLv2 = "";
    var codeLv3 = "";
    var codeLv4 = "";
    var codeLv5 = "";

    // var dataRow = dataCountUnit;
    for (var i in dataCountUnit) {
      if (codeLv0 != "" && codeLv0 != null) {
        codeLv0 = codeLv0 + "," + i['lv0'];
      } else {
        codeLv0 = i['lv0'];
      }

      if (codeLv1 != "" && codeLv1 != null) {
        codeLv1 = codeLv1 + "," + i['lv1'];
      } else {
        codeLv1 = i['lv1'];
      }

      if (codeLv2 != "" && codeLv2 != null) {
        codeLv2 = codeLv2 + "," + i['lv2'];
      } else {
        codeLv2 = i['lv2'];
      }

      if (codeLv3 != "" && codeLv3 != null) {
        codeLv3 = codeLv3 + "," + i['lv3'];
      } else {
        codeLv3 = i['lv3'];
      }

      if (codeLv4 != "" && codeLv4 != null) {
        codeLv4 = codeLv4 + "," + i['lv4'];
      } else {
        codeLv4 = i['lv4'];
      }
      if (codeLv5 != "" && codeLv5 != null) {
        codeLv5 = codeLv4 + "," + i['lv4'];
      } else {
        codeLv5 = i['lv4'];
      }
    }

    var index = dataCountUnit.indexWhere((c) => c['status'] != "A");

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
    user['province'] = titleCategoryLv1;
    user['amphoe'] = titleCategoryLv2;
    user['tambon'] = titleCategoryLv3;
    user['postno'] = titleCategoryLv4;
    user['provinceCode'] = selectedCodeLv1;
    user['amphoeCode'] = selectedCodeLv2;
    user['tambonCode'] = selectedCodeLv3;
    user['postnoCode'] = selectedCodeLv4;
    user['idcard'] = txtIdCard.text;
    user['officerCode'] = txtOfficerCode.text;
    user['linkAccount'] = user['linkAccount'] ?? '';
    user['countUnit'] = json.encode(dataCountUnit);
    user['lv0'] = codeLv0;
    user['lv1'] = codeLv1;
    user['lv2'] = codeLv2;
    user['lv3'] = codeLv3;
    user['lv4'] = codeLv4;
    user['lv5'] = codeLv5;
    // user['status'] = "V";
    // user['status'] = index == -1 ? user['status'] : "V";
    user['appleID'] = user['appleID'] ?? "";

    final result = await postObjectData('m/Register/update', user);

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginLC',
        value: jsonEncode(result['objectData']),
      );

      Navigator.pop(context);
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text(
            'ยืนยันตัวตนไม่สำเร็จ',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            result['message'],
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
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
    }
    // }
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'];
        txtFirstName.text = user['firstName'];
        txtLastName.text = user['lastName'];
        txtEmail.text = user['email'];
        txtPhone.text = user['phone'];
        txtPrefixName.text = user['prefixName'];
        // _selectedPrefixName = user['prefixName'];
        _code = user['code'];
      });

      if (user['birthDay'] != '') {
        var date = user['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
        // DateTime todayDate = DateTime.parse(user['birthDay']);

        // setState(() {
        //   _selectedYear = todayDate.year;
        //   _selectedMonth = todayDate.month;
        //   _selectedDay = todayDate.day;
        //   txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
        // });
      }
      // getUser();
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: const EdgeInsets.all(15), child: contentCard()),
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
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 5.0, left: 30),
              child: Text(
                'ข้อมูลสมาชิก',
                style: TextStyle(
                  fontSize: 18.00,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  // color: Color(0xFFBC0611),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            textFormIdCardFieldV2(
              txtIdCard,
              'รหัสประจำตัวประชาชน',
              'รหัสประจำตัวประชาชน',
              'รหัสประจำตัวประชาชน',
              true,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => dialogOpenPickerDate(),
              child: AbsorbPointer(
                child: TextFormField(
                  style: const TextStyle(
                    color: Color(0xFF2D9CED),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Kanit',
                    fontSize: 15.00,
                  ),
                  controller: txtDate,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
                    hintText: '',
                    labelText: 'วันเดือนปีเกิด',
                    labelStyle: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      color: Color(0xFF216DA6),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFF216DA6),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFF216DA6),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Color(0xFF216DA6),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        width: 1,
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 13.0,
                      color: Colors.red,
                    ),
                  ),
                  validator: (model) {
                    if (model!.isEmpty) {
                      return 'กรุณากรอกวันเดือนปีเกิด.';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 30),
              child: Text(
                'ข้อมูลสมาชิก',
                style: TextStyle(
                  fontSize: 18.00,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  // color: Color(0xFFBC0611),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Column(
            //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         _sheetBottom();
            //         // setState(() {

            //         // });
            //       },
            //       child: Container(
            //         padding: EdgeInsets.only(left: 10.0),
            //         constraints: BoxConstraints(
            //           minHeight: 40,
            //         ),
            //         // height: 40,
            //         decoration: new BoxDecoration(
            //           color: Color(0xFFFFFFFF),
            //           borderRadius: BorderRadius.circular(8.0),
            //           border: Border.all(
            //             width: 1,
            //             color: Colors.grey.withOpacity(0.5),
            //           ),
            //         ),
            //         child: Container(
            //             alignment: Alignment.centerLeft,
            //             child: Text(
            //               titleCategoryLv1 != ""
            //                   ? (titleCategoryLv1 ?? "") +
            //                       " / " +
            //                       (titleCategoryLv2 ?? "") +
            //                       " / " +
            //                       (titleCategoryLv3 ?? "") +
            //                       " / " +
            //                       (selectedCodeLv4 ?? "")
            //                   : 'จังหวัด / อำเภอ/เขต / ตำบล/แขวง / รหัสไปรษณีย์',
            //               style: TextStyle(
            //                 color: Color(0xFF000000).withOpacity(0.9),
            //                 fontFamily: 'Kanit',
            //                 fontSize: 13,
            //                 fontWeight: FontWeight.w300,
            //                 // letterSpacing: 0.23,
            //               ),
            //             )),
            //       ),
            //     ),
            //   ],
            // ),

            GestureDetector(
              onTap: () {
                _sheetBottom();
                // setState(() {

                // });
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
                constraints: const BoxConstraints(
                  minHeight: 50,
                ),
                // height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(width: 1, color: const Color(0xFF216DA6)),
                ),
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      titleCategoryLv1 != ""
                          ? (titleCategoryLv1) +
                              " / " +
                              (titleCategoryLv2) +
                              " / " +
                              (titleCategoryLv3) +
                              " / " +
                              (selectedCodeLv4)
                          : 'จังหวัด / อำเภอ/เขต / ตำบล/แขวง / รหัสไปรษณีย์',
                      style: const TextStyle(
                        color: Color(0xFF2D9CED),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Kanit',
                        fontSize: 15.00,
                      ),
                    )),
              ),
            ),
            const SizedBox(height: 20),
            textFormFieldNoValidatorV2(
              txtAddress,
              'บ้านเลขที่ / ซอย / หมู่ / ถนน',
              'บ้านเลขที่ / ซอย / หมู่ / ถนน',
              true,
              false,
            ),
            const SizedBox(height: 20),
            textFormPhoneFieldV2(
              txtPhone,
              'เบอร์โทรศัพท์',
              'เบอร์โทรศัพท์',
              'เบอร์โทรศัพท์',
              true,
              true,
            ),
            const SizedBox(height: 20),
            textFormFieldNoValidatorV2(
              txtEmail,
              'อีเมล',
              'อีเมล',
              false,
              true,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15.0),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(25.0),
                  color: const Color(0xFFED6B2D),
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
                    child: const Text(
                      'บันทึกข้อมูล',
                      style: TextStyle(
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
            // SizedBox(height: 100),
            // InkWell(
            //   onTap: () {
            //     logout();
            //   },
            //   child: Container(
            //     alignment: Alignment.centerRight,
            //     child: Text(
            //       '1.0.4',
            //       style: TextStyle(fontSize: 8),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    var category = await storage.read(key: 'profileCategory');

    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    if (category == 'google') {
      googleSignIn.disconnect();
    } else if (category == 'facebook') {
      // await facebookSignIn.logOut();
    }

    // delete
    await storage.deleteAll();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  dropdownMenuItemHaveData(
    String selected,
    List<dynamic> item,
    String title,
  ) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 10.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (value) => value == null ? 'กรุณาเลือก' + title : null,
      hint: Text(
        title,
        style: const TextStyle(
          fontSize: 15.00,
          fontFamily: 'Kanit',
        ),
      ),
      value: selected,
      onChanged: (newValue) {
        setState(() {
          selected = newValue as String;
        });
      },
      items: item.map((item) {
        return DropdownMenuItem(
          value: item['code'],
          child: Text(
            item['title'],
            style: const TextStyle(
              fontSize: 15.00,
              fontFamily: 'Kanit',
              color: Color(0xFF9A1120),
            ),
          ),
        );
      }).toList(),
    );
  }

  dropdownMenuItemNoHaveData(
    String selected,
    List<dynamic> item,
    String title,
  ) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 10.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (value) =>
          value == '' || value == null ? 'กรุณาเลือก' + title : null,
      hint: Text(
        title,
        style: const TextStyle(
          fontSize: 15.00,
          fontFamily: 'Kanit',
        ),
      ),
      // value: _selected,
      onChanged: (newValue) {
        setState(() {
          selected = newValue as String;
        });
      },
      items: item.map((item) {
        return DropdownMenuItem(
          value: item['code'],
          child: Text(
            item['title'],
            style: const TextStyle(
              fontSize: 15.00,
              fontFamily: 'Kanit',
              color: Color(0xFF9A1120),
            ),
          ),
        );
      }).toList(),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: const Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                urlImage,
                height: 5.0,
                width: 5.0,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: const TextStyle(
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

  void goBack() async {
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
    Navigator.pop(context, false);
  }

  _sheetBottom() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setStateModal /*You can rename this!*/) {
          return Container(
            // height: 300,
            color: const Color(0xFFFFFFFF),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          'เลือกที่อยู่',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _titleCategory(1, setStateModal),
                      if (selectedCodeLv1 != '')
                        _titleCategory(2, setStateModal),
                      if (selectedCodeLv2 != '')
                        _titleCategory(3, setStateModal),
                      if (selectedCodeLv3 != '')
                        _titleCategory(4, setStateModal),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPageLv(_futureShopLv1, 1, setStateModal),
                      if (selectedCodeLv1 != '')
                        _buildPageLv(_futureShopLv2, 2, setStateModal),
                      if (selectedCodeLv2 != '')
                        _buildPageLv(_futureShopLv3, 3, setStateModal),
                      // if (selectedCodeLv3 != '')
                      //   _buildPageLv(_futureShopLv4, 4, setStateModal),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      },
    );
  }

  _titleCategory(lv, StateSetter setStateModal) {
    return GestureDetector(
      onTap: () => setStateModal(() {
        currentPage = lv - 1;
        pageController.animateToPage(lv - 1,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: currentPage == lv - 1 ? Colors.red : Colors.white,
            ),
          ),
        ),
        child: Text(
          textCategory(lv),
          style: const TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  _buildPageLv(future, lv, StateSetter setStateModal) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: (snapshot.data as List).length,
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Theme.of(context).colorScheme.background,
            ),
            itemBuilder: (context, index) =>
                _buildItem((snapshot.data as List)[index], lv, setStateModal),
          );
        } else if (snapshot.hasError) {
          return DataError(onTap: () => _callReadProvince(''));
        } else {
          return ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Theme.of(context).colorScheme.background,
            ),
            itemBuilder: (context, index) => Container(
              height: 50,
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
            ),
          );
        }
      },
    );
  }

  StackTap _buildItem(item, page, StateSetter setStateModal) {
    Color colorItem = const Color(0xFF000000);
    if (page == 1 && titleCategoryLv1 == item['title']) colorItem = Colors.red;
    if (page == 2 && titleCategoryLv2 == item['title']) colorItem = Colors.red;
    if (page == 3 && titleCategoryLv3 == item['title']) colorItem = Colors.red;
    // if (page == 4 && selectedCodeLv4 == item['zip']) colorItem = Colors.red;
    return StackTap(
      onTap: () async => {
        setStateModal(() {
          currentPage = page;
        }),
        if (page == 1)
          {
            setStateModal(() {
              selectedCodeLv1 = item['code'].toString();
              selectedCodeLv2 = '';
              selectedCodeLv3 = '';
              selectedCodeLv4 = '';
              titleCategoryLv1 = item['title'];
              titleCategoryLv2 = '';
              titleCategoryLv3 = '';
              titleCategoryLv4 = '';
              getCategory(page, setStateModal);
              pageController.animateToPage(page,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            })
          },
        if (page == 2)
          {
            setStateModal(() {
              selectedCodeLv2 = item['code'].toString();
              selectedCodeLv3 = '';
              selectedCodeLv4 = '';
              titleCategoryLv2 = item['title'];
              getCategory(page, setStateModal);
              pageController.animateToPage(page,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            })
          },
        if (page == 3)
          {
            setStateModal(() {
              selectedCodeLv3 = item['code'].toString();
              titleCategoryLv3 = item['title'];
              selectedCodeLv4 = item['postCode'];
              titleCategoryLv4 = item['postCode'];
              getCategory(page, setStateModal);
              // pageController.animateToPage(page,
              //     duration: Duration(milliseconds: 500), curve: Curves.ease)
            }),
            Navigator.pop(context, 'success')
          },
        // if (page == 4)
        //   {
        //     setStateModal(() => {
        //           selectedCodeLv4 = item['zip'],
        //           titleCategoryLv4 = item['zip'],
        //           getCategory(page, setStateModal),
        //           // pageController.animateToPage(page,
        //           //     duration: Duration(milliseconds: 500), curve: Curves.ease)
        //         }),
        //     Navigator.pop(context, 'success')
        //   },
        setState(() {}),
      },
      borderRadius: null,
      splashColor: null,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item['title'] ?? item['title'],
              style: TextStyle(
                  fontFamily: 'Kanit', fontSize: 14, color: colorItem),
            ),
            Icon(
              colorItem == Colors.red
                  ? Icons.check
                  : page != 4
                      ? Icons.arrow_forward_ios_rounded
                      : null,
              size: colorItem == Colors.red ? 20 : 15,
              color: colorItem,
            ),
          ],
        ),
      ),
    );
  }

  getCategory(lv, StateSetter setStateModal) async {
    // var model = await get(server + 'provinces/' );
    setStateModal(
      () {
        if (lv == 1) {
          _futureShopLv2 = postDio("${server}route/district/read", {
            'province': selectedCodeLv1,
          });
        }
        if (lv == 2) {
          _futureShopLv3 = postDio("${server}route/tambon/read", {
            'province': selectedCodeLv1,
            'district': selectedCodeLv2,
          });
        }
        // if (lv == 3)
        //   _futureShopLv4 = _futureShopLv3;
      },
    );
  }

  textCategory(page) {
    String text = '';
    if (page == 1) {
      if (titleCategoryLv1 != "" && titleCategoryLv1 != "กรุงเทพมหานคร") {
        text = "จังหวัด" + titleCategoryLv1;
      } else if (titleCategoryLv1 == "กรุงเทพมหานคร") {
        text = titleCategoryLv1;
      } else {
        text = 'เลือกจังหวัด';
      }
    }
    if (page == 2) {
      if (titleCategoryLv2 != "") {
        text = titleCategoryLv2;
      } else {
        text = 'เลือกอำเภอ/เขต';
      }
    }
    if (page == 3) {
      if (titleCategoryLv3 != "" && titleCategoryLv1 != "กรุงเทพมหานคร") {
        text = "ตำบล" + titleCategoryLv3;
      } else if (titleCategoryLv1 == "กรุงเทพมหานคร") {
        text = titleCategoryLv3;
      } else {
        text = 'เลือกตำบล/แขวง';
      }
    }
    if (page == 4) {
      if (selectedCodeLv4 != "") {
        text = selectedCodeLv4;
      } else {
        text = 'เลือกรหัสไปรษณีย์';
      }
      // text = titleCategoryLv4;
    }

    return text;
  }

  Future<dynamic> _callReadProvince(param) async {
    setState(
      () {
        _futureShopLv1 = postDio("${server}route/province/read", {});

        if (param['provinceTitle'] != "") {
          selectedCodeLv1 = param['provinceCode:'];
          titleCategoryLv1 = param['provinceTitle'];
          _futureShopLv2 = postDio("${server}route/district/read", {
            'province': selectedCodeLv1,
          });
          selectedCodeLv2 = param['districtCode'];
          titleCategoryLv2 = param['districtTitle'];

          _futureShopLv3 = postDio("${server}route/tambon/read", {
            'province': selectedCodeLv1,
            'district': selectedCodeLv2,
          });
          selectedCodeLv3 = param['subDistrictCode'];
          titleCategoryLv3 = param['subDistrictTitle'];
          selectedCodeLv4 = param['postCode'];
          titleCategoryLv4 = param['postCode'];
        }
      },
    );
  }
}
