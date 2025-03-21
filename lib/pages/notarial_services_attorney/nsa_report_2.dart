// ignore_for_file: missing_return, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../../widget/header_v2.dart';
import '../../widget/text_form_field.dart';
import 'nsa_report_pay.dart';

class NsaReport2Page extends StatefulWidget {
  const NsaReport2Page({
    super.key,
    this.model,
  });
  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _NsaReport2PageState createState() => _NsaReport2PageState();
}

class _NsaReport2PageState extends State<NsaReport2Page> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  bool _hasErrorPrefix = false;
  bool _hasErrorPrefixEN = false;
  bool _hasErrorProvince = false;
  bool _hasErrorDistrict = false;
  bool _hasErrorSubDistrict = false;
  bool _hasErrorPostalCode = false;
  bool _hasErrorCompanyProvince = false;
  bool _hasErrorCompanyDistrict = false;
  bool _hasErrorCompanySubDistrict = false;
  bool _hasErrorCompanyPostalCode = false;
  bool _hasErrorShippingProvince = false;
  bool _hasErrorShippingDistrict = false;
  bool _hasErrorShippingSubDistrict = false;
  bool _hasErrorShippingPostalCode = false;

  final List<dynamic> _itemPrefix = [
    {'code': '1', 'title': 'นาย'},
    {'code': '2', 'title': 'นางสาว'},
    {'code': '3', 'title': 'นาง'}
  ];
  final List<dynamic> _itemPrefixEN = [
    {
      'code': "1",
      'title': "Mr",
    },
    {
      'code': "2",
      'title': "Mrs",
    },
    {
      'code': "3",
      'title': "Miss",
    },
    {
      'code': "4",
      'title': "Ms",
    },
    {
      'code': "5",
      'title': "Dr",
    },
    {
      'code': "6",
      'title': "Prof",
    },
  ];
  String? _selectedPrefix;
  String? _selectedPrefixEN;

  int selectLcType = 1;
  String lcTypeName = "2 ปี";
  bool isMemterType = false;

  bool isLawyersConduct = false;
  bool isNoCriminal = false;
  bool isOther = false;

  final txtCode_id = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtFirstNameEN = TextEditingController();
  final txtLastNameEN = TextEditingController();
  final txtAge = TextEditingController();
  final txtIdCard = TextEditingController();
  final txtCom_no = TextEditingController();
  final txtAddress = TextEditingController();
  final txtMoo = TextEditingController();
  final txtSoi = TextEditingController();
  final txtRoad = TextEditingController();
  final txtPhone = TextEditingController();
  final txtEmail = TextEditingController();
  final txtFax = TextEditingController();
  final txtGeneration = TextEditingController();
  final txtCompanyName = TextEditingController();
  final txtCompanyAddress = TextEditingController();
  final txtCompanyBuilding = TextEditingController();
  final txtCompanyMoo = TextEditingController();
  final txtCompanySoi = TextEditingController();
  final txtCompanyRoad = TextEditingController();
  final txtCompanyPhone = TextEditingController();
  final txtCompanyEmail = TextEditingController();
  final txtCompanyFax = TextEditingController();
  final txtShippingFirstName = TextEditingController();
  final txtShippingLastName = TextEditingController();
  final txtShippingName = TextEditingController();
  final txtShippingAddress = TextEditingController();
  final txtShippingBuilding = TextEditingController();
  final txtShippingMoo = TextEditingController();
  final txtShippingSoi = TextEditingController();
  final txtShippingRoad = TextEditingController();
  final txtShippingPhone = TextEditingController();
  final txtOtherDetail = TextEditingController();
  final txtNewFirstName = TextEditingController();
  final txtNewLastName = TextEditingController();
  final txtNewFirstNameEN = TextEditingController();
  final txtNewLastNameEN = TextEditingController();
  final txtDocNo = TextEditingController();

  int selectedNewAddress = 1;

  List<dynamic> _itemImage = [];
  final List<dynamic> _itemImage2 = [];
  late XFile _image;

  DateTime selectedDate = DateTime.now();
  final txtDate = TextEditingController();
  final txtExpDate = TextEditingController();

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage2 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage3 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage4 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImageSign = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic _modelReport = {};

  List<dynamic> _itemProvince = [];
  String? _selectedProvince;
  List<dynamic> _itemDistrict = [];
  String? _selectedDistrict;
  List<dynamic> _itemSubDistrict = [];
  String? _selectedSubDistrict;
  List<dynamic> _itemPostalCode = [];
  String? _selectedPostalCode;

  List<dynamic> _itemCompanyProvince = [];
  String? _selectedCompanyProvince;
  List<dynamic> _itemCompanyDistrict = [];
  String? _selectedCompanyDistrict;
  List<dynamic> _itemCompanySubDistrict = [];
  String? _selectedCompanySubDistrict;
  List<dynamic> _itemCompanyPostalCode = [];
  String? _selectedCompanyPostalCode;

  List<dynamic> _itemShippingProvince = [];
  String? _selectedShippingProvince;
  List<dynamic> _itemShippingDistrict = [];
  String? _selectedShippingDistrict;
  List<dynamic> _itemShippingSubDistrict = [];
  String? _selectedShippingSubDistrict;
  List<dynamic> _itemShippingPostalCode = [];
  String? _selectedShippingPostalCode;

  Color selectedColor = const Color(0xFF758C29);

  bool isNewAddress = false;
  bool isNewName = false;
  bool isNewCompanyAddress = false;
  bool isCertifyStatus = false;
  bool isCertifyPunish = false;
  bool isAgree = false;
  bool isEvidence = false;
  bool isChkmodel = false;
  late String profileCode;

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerNSA(context,
          callback: goBack, title: 'แบบ ทรอ.2', contentRight: Container()),
      body: ListView(
        controller: scrollController,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          buildContent(),
        ],
      ),
    );
  }

  buildContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Center(
            child: Text(
              'แบบคำขอต่ออายุการขึ้นทะเบียน',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const Center(
            child: Text(
              'เป็นทนายความผู้ทำคำรับรองลายมือชื่อและเอกสาร',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(28.5),
              border: Border.all(
                color: _hasErrorPrefix
                    ? Colors.red
                    : const Color(0xFF758C29).withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                errorStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 10.0,
                ),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == '' || value == null) {
                  setState(() {
                    _hasErrorPrefix = true;
                  });
                  return null;
                } else {
                  setState(() {
                    _hasErrorPrefix = false;
                  });
                  return null;
                }
              },
              value: _selectedPrefix,
              hint: const Text(
                'คำนำหน้า',
                style: TextStyle(
                  fontSize: 14.00,
                  fontFamily: 'Kanit',
                  color: Color(0xFFCCBEBE),
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                TextEditingController().clear();
              },
              onChanged: (newValue) {
                setState(() {
                  _selectedPrefix = newValue as String;
                  _hasErrorPrefix = false;
                });
              },
              items: _itemPrefix.map((item) {
                return DropdownMenuItem(
                  value: item['title'],
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Kanit',
                      color: Color(0xFF758C29),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (_hasErrorPrefix)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Text(
                'กรุณาเลือกคำนำหน้า',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 10.0,
                  color: Colors.red,
                ),
              ),
            ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSA(
                    txtFirstName,
                    '',
                    'ชื่อ(ภาษาไทย)',
                    'ชื่อ(ภาษาไทย)',
                    'ชื่อ(ภาษาไทย)',
                    true,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSA(
                      txtLastName,
                      '',
                      'นามสกุล(ภาษาไทย)',
                      'นามสกุล(ภาษาไทย)',
                      'นามสกุล(ภาษาไทย)',
                      true,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(28.5),
              border: Border.all(
                color: _hasErrorPrefixEN
                    ? Colors.red
                    : const Color(0xFF758C29).withOpacity(0.7),
                width: 1.5,
              ),
            ),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                errorStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 10.0,
                ),
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == '' || value == null) {
                  setState(() {
                    _hasErrorPrefixEN = true;
                  });
                  return null;
                } else {
                  setState(() {
                    _hasErrorPrefixEN = false;
                  });
                  return null;
                }
              },
              value: _selectedPrefixEN,
              hint: const Text(
                'คำนำหน้า',
                style: TextStyle(
                  fontSize: 14.00,
                  fontFamily: 'Kanit',
                  color: Color(0xFFCCBEBE),
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                TextEditingController().clear();
              },
              onChanged: (newValue) {
                setState(() {
                  _selectedPrefixEN = newValue as String;
                  _hasErrorPrefixEN = false;
                });
              },
              items: _itemPrefixEN.map((item) {
                return DropdownMenuItem(
                  value: item['title'],
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontFamily: 'Kanit',
                      color: Color(0xFF758C29),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (_hasErrorPrefixEN)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Text(
                'กรุณาเลือกคำนำหน้า(ภาษาอังกฤษ)',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 10.0,
                  color: Colors.red,
                ),
              ),
            ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSA(
                    txtFirstNameEN,
                    '',
                    'ชื่อ(ภาษาอังกฤษ)',
                    'ชื่อ(ภาษาอังกฤษ)',
                    'ชื่อ(ภาษาอังกฤษ)',
                    true,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSA(
                      txtLastNameEN,
                      '',
                      'นามสกุล(ภาษาอังกฤษ)',
                      'นามสกุล(ภาษาอังกฤษ)',
                      'นามสกุล(ภาษาอังกฤษ)',
                      true,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: textFormFieldNSA(
              txtCom_no,
              '',
              'เลขที่ใบอนุญาตทนายความ',
              'เลขที่ใบอนุญาตทนายความ',
              'เลขที่ใบอนุญาตทนายความ',
              true,
              false,
              false,
              false,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'เป็นสมาชิกประเภท',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: const Color(0xFF758C29),
                      radioTheme: RadioThemeData(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => selectedColor,
                        ),
                      ),
                    ),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 1,
                      groupValue: selectLcType,
                      title: const Text(
                        "2 ปี",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Color(0xFF758C29)),
                      ),
                      onChanged: (value) => setState(
                        (() {
                          selectLcType = 1;
                          lcTypeName = "2 ปี";
                          isMemterType = true;
                          selectedColor = const Color(0xFF758C29);
                        }),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(
                      unselectedWidgetColor: const Color(0xFF758C29),
                      radioTheme: RadioThemeData(
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) => selectedColor,
                        ),
                      ),
                    ),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 2,
                      groupValue: selectLcType,
                      title: const Text("ตลอดชีพ",
                          style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Color(0xFF758C29))),
                      onChanged: (value) => setState(
                        (() {
                          selectLcType = 2;
                          lcTypeName = "ตลอดชีพ";
                          isMemterType = false;
                          selectedColor = const Color(0xFF758C29);
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                // horizontal: 15,
                vertical: 0,
              ),
              child: GestureDetector(
                onTap: () => dialogOpenPickerDate(),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: txtExpDate,
                    style: const TextStyle(
                      color: Color(0xFF758C29),
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 15.0,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      hintText: 'หมดอายุ วันที่/เดือน/ปี ',
                      hintStyle: const TextStyle(
                        color: Color(0xFF758C29),
                        fontFamily: 'Kanit',
                        fontSize: 14.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.5),
                        borderSide: const BorderSide(
                          color: Color(0xFF4A4A4A),
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.5),
                        borderSide: BorderSide(
                          color: const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.5),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.5),
                        borderSide: const BorderSide(
                          color: Colors.redAccent,
                          width: 1.5,
                        ),
                      ),
                      errorStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                        fontSize: 10.0,
                      ),
                    ),
                    validator: (model) {
                      return null;

                      // if (model.isEmpty) {
                      //   return 'วันเดือนปีที่หมดอายุ';
                      // }
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: textFormFieldNSANoValidator(
              txtDocNo,
              '',
              'ทะเบียนทนายความผู้ทำคำรับรองลายมาชื่อเอกสารเลขที่',
              'ทะเบียนทนายความผู้ทำคำรับรองลายมาชื่อเอกสารเลขที่',
              true,
              false,
              false,
              false,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'ข้าพเจ้าขอรับรองว่าขณะยื่นคำขอนี้',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Theme(
                  data:
                      ThemeData(unselectedWidgetColor: const Color(0xFF758C29)),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    value: isCertifyStatus,
                    title: const Text(
                      "ข้าพเจ้ายังคงสถานภาพเป็นผู้ประกอบวิชาชีพทนายความ",
                      style: TextStyle(
                        fontFamily: 'Kanit',
                      ),
                    ),
                    onChanged: (value) => setState(
                      (() {
                        isCertifyStatus = value!;
                      }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Theme(
                  data:
                      ThemeData(unselectedWidgetColor: const Color(0xFF758C29)),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    value: isCertifyPunish,
                    title: const Text(
                      "ข้าพเจ้าไม่อยู่ระหว่างถูกลงโทษฐานประพฤติผิดมรรยาททนายความ",
                      style: TextStyle(
                        fontFamily: 'Kanit',
                      ),
                    ),
                    onChanged: (value) => setState(
                      (() {
                        isCertifyPunish = value!;
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'ในการนี้ข้าพเจ้ามีความประสงค์ดังนี้',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Theme(
                  data: ThemeData(
                    unselectedWidgetColor: const Color(0xFF758C29),
                    radioTheme: RadioThemeData(
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (states) => selectedColor,
                      ),
                    ),
                  ),
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: 1,
                    groupValue: selectedNewAddress,
                    title: const Text(
                      "ใช้ข้อมูลทางทะเบียนที่ให้ไว้เดิม",
                      style: TextStyle(
                        fontFamily: 'Kanit',
                      ),
                    ),
                    onChanged: (value) => isChkmodel
                        ? setState(
                            (() {
                              selectedNewAddress = 1;
                              isNewAddress = false;
                            }),
                          )
                        : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Theme(
                  data:
                      ThemeData(unselectedWidgetColor: const Color(0xFF758C29)),
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: 2,
                    groupValue: selectedNewAddress,
                    title: const Text(
                      "เปลี่ยนแปลงข้อมูลทางทะเบียนใหม่ดังนี้",
                      style: TextStyle(
                        fontFamily: 'Kanit',
                      ),
                    ),
                    onChanged: (value) => setState(
                      (() {
                        selectedNewAddress = 2;
                        isNewAddress = true;
                        getProvince();
                        getCompanyProvince();
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'เปลี่ยนชื่อตัว, ชื่อนามสกุลใหม่ เป็นดังนี้',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSA(
                    txtNewFirstName,
                    '',
                    'ชื่อตัว',
                    'ชื่อตัว',
                    'ชื่อตัว',
                    isNewAddress,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSA(
                      txtNewLastName,
                      '',
                      'ชื่อสกุล',
                      'ชื่อสกุล',
                      'ชื่อสกุล',
                      isNewAddress,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSA(
                    txtNewFirstNameEN,
                    '',
                    'ชื่อตัว(ภาษาอังกฤษ)',
                    'ชื่อตัว(ภาษาอังกฤษ)',
                    'ชื่อตัว(ภาษาอังกฤษ)',
                    isNewAddress,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSA(
                      txtNewLastNameEN,
                      '',
                      'ชื่อสกุล(ภาษาอังกฤษ)',
                      'ชื่อสกุล(ภาษาอังกฤษ)',
                      'ชื่อสกุล(ภาษาอังกฤษ)',
                      isNewAddress,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'เปลี่ยนแปลงข้อมูลที่อยู่ปัจจุบันใหม่ เป็นดังนี้',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSA(
                    txtAddress,
                    '',
                    'บ้านเลขที่',
                    'บ้านเลขที่',
                    'บ้านเลขที่',
                    isNewAddress,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSANoValidator(
                      txtMoo,
                      '',
                      'หมู่ที่',
                      'หมู่ที่',
                      isNewAddress,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSANoValidator(
                    txtSoi,
                    '',
                    'ตรอก/ซอย',
                    'ตรอก/ซอย',
                    isNewAddress,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSANoValidator(
                      txtRoad,
                      '',
                      'ถนน',
                      'ถนน',
                      isNewAddress,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: isNewAddress
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFCCBEBE),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorProvince
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (isNewAddress) {
                            if (value == '' || value == '') {
                              setState(() {
                                _hasErrorProvince = true;
                              });
                              return null;
                            } else {
                              setState(() {
                                _hasErrorProvince = false;
                              });
                              return null;
                            }
                          }
                          return null;
                        },
                        hint: const Text(
                          'จังหวัด',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _selectedProvince,
                        onTap: () {
                          if (isNewAddress) {
                            FocusScope.of(context).unfocus();
                            TextEditingController().clear();
                          }
                        },
                        onChanged: isNewAddress
                            ? (newValue) {
                                setState(() {
                                  _selectedDistrict = "";
                                  _itemDistrict = [];
                                  _selectedSubDistrict = "";
                                  _itemSubDistrict = [];
                                  _selectedPostalCode = "";
                                  _itemPostalCode = [];
                                  _selectedProvince = newValue as String;
                                  _hasErrorProvince = false;
                                });
                                getDistrict();
                              }
                            : null, // Disable dropdown interaction when isNewAddress is false
                        items: isNewAddress
                            ? _itemProvince.map((item) {
                                return DropdownMenuItem(
                                  value: item['code'],
                                  child: Text(
                                    item['title'],
                                    style: const TextStyle(
                                      fontSize: 14.00,
                                      fontFamily: 'Kanit',
                                      color: Color(0xFF4A4A4A),
                                    ),
                                  ),
                                );
                              }).toList()
                            : null, // No items when disabled
                      ),
                    ),
                    if (_hasErrorProvince)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกจังหวัด',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                        color: isNewAddress
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFCCBEBE),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorDistrict
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (isNewAddress) {
                            if (value == '' || value == null) {
                              setState(() {
                                _hasErrorDistrict = true;
                              });
                              return null;
                            } else {
                              setState(() {
                                _hasErrorDistrict = false;
                              });
                              return null;
                            }
                          }
                          return null;
                        },
                        hint: const Text(
                          'อำเภอ',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemDistrict.any(
                                (item) => item['code'] == _selectedDistrict)
                            ? _selectedDistrict
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSubDistrict = "";
                            _itemSubDistrict = [];
                            _selectedPostalCode = "";
                            _itemPostalCode = [];
                            _selectedDistrict = newValue as String;
                            _hasErrorDistrict = false;
                          });
                          getSubDistrict();
                        },
                        items: _itemDistrict.map((item) {
                          return DropdownMenuItem(
                            value: item['code'],
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorDistrict)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกอำเภอ',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: isNewAddress
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFCCBEBE),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorSubDistrict
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (isNewAddress) {
                            if (value == '' || value == null) {
                              setState(() {
                                _hasErrorSubDistrict = true;
                              });
                              return null;
                            } else {
                              setState(() {
                                _hasErrorSubDistrict = false;
                              });
                              return null;
                            }
                          }
                          return null;
                        },
                        hint: const Text(
                          'ตำบล',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemSubDistrict.any(
                                (item) => item['code'] == _selectedSubDistrict)
                            ? _selectedSubDistrict
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPostalCode = "";
                            _itemPostalCode = [];
                            _selectedSubDistrict = newValue as String;
                            _hasErrorSubDistrict = false;
                          });
                          getPostalCode();
                        },
                        items: _itemSubDistrict.map((item) {
                          return DropdownMenuItem(
                            value: item['code'],
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorSubDistrict)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกตำบล',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: isNewAddress
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFCCBEBE),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorPostalCode
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (isNewAddress) {
                            if (value == '' || value == null) {
                              setState(() {
                                _hasErrorPostalCode = true;
                              });
                              return null;
                            } else {
                              setState(() {
                                _hasErrorPostalCode = false;
                              });
                              return null;
                            }
                          }
                          return null;
                        },
                        hint: const Text(
                          'รหัสไปรษณีย์',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemPostalCode.any((item) =>
                                item['postCode'] == _selectedPostalCode)
                            ? _selectedPostalCode
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedPostalCode = newValue as String;
                            _hasErrorPostalCode = false;
                          });
                        },
                        items: _itemPostalCode.map((item) {
                          return DropdownMenuItem(
                            value: item['postCode'],
                            child: Text(
                              item['postCode'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF758C29),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorPostalCode)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกรหัสไปรษณีย์',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSA(
              txtPhone,
              '',
              'เบอร์โทรศัพท์',
              'เบอร์โทรศัพท์',
              'เบอร์โทรศัพท์',
              isNewAddress,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSANoValidator(
              txtFax,
              '',
              'เลขหมายโทรสาร',
              'เลขหมายโทรสาร',
              isNewAddress,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSANoValidator(
              txtEmail,
              '',
              'E-mail',
              'E-mail',
              isNewAddress,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'เปลี่ยนแปลงข้อมูลสำนักงาน/บริษัทใหม่ เป็นดังนี้',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSA(
              txtCompanyName,
              '',
              'ชื่อสำนักงาน / บริษัท',
              'ชื่อสำนักงาน / บริษัท',
              'ชื่อสำนักงาน / บริษัท',
              isNewAddress,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSA(
              txtCompanyAddress,
              '',
              'สำนักงาน/บริษัท เลขที่',
              'สำนักงาน/บริษัท เลขที่',
              'สำนักงาน/บริษัท เลขที่',
              isNewAddress,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSANoValidator(
                    txtCompanyBuilding,
                    '',
                    'อาคาร',
                    'อาคาร',
                    isNewAddress,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSANoValidator(
                      txtCompanyMoo,
                      '',
                      'หมู่ที่',
                      'หมู่ที่',
                      isNewAddress,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSANoValidator(
                    txtCompanySoi,
                    '',
                    'ตรอก/ซอย',
                    'ตรอก/ซอย',
                    isNewAddress,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSANoValidator(
                      txtCompanyRoad,
                      '',
                      'ถนน',
                      'ถนน',
                      isNewAddress,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: isNewAddress
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFCCBEBE),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorCompanyProvince
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (isNewAddress) {
                            if (value == '' || value == null) {
                              setState(() {
                                _hasErrorCompanyProvince = true;
                              });
                              return null;
                            } else {
                              setState(() {
                                _hasErrorCompanyProvince = false;
                              });
                              return null;
                            }
                          }
                          return null;
                        },
                        hint: const Text(
                          'จังหวัด',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _selectedCompanyProvince,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCompanyDistrict = "";
                            _itemCompanyDistrict = [];
                            _selectedCompanySubDistrict = "";
                            _itemCompanySubDistrict = [];
                            _selectedCompanyPostalCode = "";
                            _itemCompanyPostalCode = [];
                            _selectedCompanyProvince = newValue as String;
                            _hasErrorCompanyProvince = false;
                          });
                          getCompanyDistrict();
                        },
                        items: _itemCompanyProvince.map((item) {
                          return DropdownMenuItem(
                            value: item['code'],
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorCompanyProvince)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกจังหวัด',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                        color: isNewAddress
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFCCBEBE),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorCompanyDistrict
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (isNewAddress) {
                            if (value == '' || value == null) {
                              setState(() {
                                _hasErrorCompanyDistrict = true;
                              });
                              return null;
                            } else {
                              setState(() {
                                _hasErrorCompanyDistrict = false;
                              });
                              return null;
                            }
                          }
                          return null;
                        },
                        hint: const Text(
                          'อำเภอ',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemCompanyDistrict.any((item) =>
                                item['code'] == _selectedCompanyDistrict)
                            ? _selectedCompanyDistrict
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCompanySubDistrict = "";
                            _itemCompanySubDistrict = [];
                            _selectedCompanyPostalCode = "";
                            _itemCompanyPostalCode = [];
                            _selectedCompanyDistrict = newValue as String;
                            _hasErrorCompanyDistrict = false;
                          });
                          getCompanySubDistrict();
                        },
                        items: _itemCompanyDistrict.map((item) {
                          return DropdownMenuItem(
                            value: item['code'],
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorCompanyDistrict)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกอำเภอ',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: isNewAddress
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFCCBEBE),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorCompanySubDistrict
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (isNewAddress) {
                            if (value == '' || value == null) {
                              setState(() {
                                _hasErrorCompanySubDistrict = true;
                              });
                              return null;
                            } else {
                              setState(() {
                                _hasErrorCompanySubDistrict = false;
                              });
                              return null;
                            }
                          }
                          return null;
                        },
                        hint: const Text(
                          'ตำบล',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemCompanySubDistrict.any((item) =>
                                item['code'] == _selectedCompanySubDistrict)
                            ? _selectedCompanySubDistrict
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCompanyPostalCode = "";
                            _itemCompanyPostalCode = [];
                            _selectedCompanySubDistrict = newValue as String;
                            _hasErrorCompanySubDistrict = false;
                          });
                          getCompanyPostalCode();
                        },
                        items: _itemCompanySubDistrict.map((item) {
                          return DropdownMenuItem(
                            value: item['code'],
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorCompanySubDistrict)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกตำบล',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: isNewAddress
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFFCCBEBE),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorCompanyPostalCode
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (isNewAddress) {
                            if (value == '' || value == null) {
                              setState(() {
                                _hasErrorCompanyPostalCode = true;
                              });
                              return null;
                            } else {
                              setState(() {
                                _hasErrorCompanyPostalCode = false;
                              });
                              return null;
                            }
                          }
                          return null;
                        },
                        hint: const Text(
                          'รหัสไปรษณีย์',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemCompanyPostalCode.any((item) =>
                                item['postCode'] == _selectedCompanyPostalCode)
                            ? _selectedCompanyPostalCode
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedCompanyPostalCode = newValue as String;
                            _hasErrorCompanyPostalCode = false;
                          });
                        },
                        items: _itemCompanyPostalCode.map((item) {
                          return DropdownMenuItem(
                            value: item['postCode'],
                            child: Text(
                              item['postCode'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF758C29),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorCompanyPostalCode)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกรหัสไปรษณีย์',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSA(
              txtCompanyPhone,
              '',
              'เบอร์โทรศัพท์',
              'เบอร์โทรศัพท์',
              'เบอร์โทรศัพท์',
              isNewAddress,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSANoValidator(
              txtCompanyFax,
              '',
              'เลขหมายโทรสาร',
              'เลขหมายโทรสาร',
              isNewAddress,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSANoValidator(
              txtCompanyEmail,
              '',
              'E-mail',
              'E-mail',
              isNewAddress,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Theme(
                  data:
                      ThemeData(unselectedWidgetColor: const Color(0xFF758C29)),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.all(0),
                    value: isAgree,
                    title: const Text(
                        "ข้าพเจ้ายินดีชำระค่าธรรมเนียม และยินยอมปฏิบัติตามกฏระเบียบ คำสั่งตลอดจนหลักเกณฑ์ที่สภาทนายความ หรือผู้ที่สภาทนายความมอบหมายประกาศใช้ทุกประการ",
                        style: TextStyle(
                          fontFamily: 'Kanit',
                        )),
                    onChanged: (value) => setState(
                      (() {
                        isAgree = value!;
                      }),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Theme(
                  data:
                      ThemeData(unselectedWidgetColor: const Color(0xFF758C29)),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.all(0),
                    value: isEvidence,
                    title: const Text(
                        "ข้าพเจ้าได้แนบหลักฐานประกอบการแจ้งเปลี่ยนแปลงข้อมูลข้างต้นมาพร้อมคำขอนี้ด้วยแล้ว",
                        style: TextStyle(
                          fontFamily: 'Kanit',
                        )),
                    onChanged: (value) => setState(
                      (() {
                        isEvidence = value!;
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'เอกสารประกอบคำขอ',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage1['imageUrl'] != "" &&
                              itemImage1['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage1['id'].toString(), "1");
                                },
                                padding: const EdgeInsets.all(0),
                                child: itemImage1['isPdf']
                                    ? Image.asset(
                                        'assets/images/file-other.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.contain)
                                    : Image.network(
                                        itemImage1['imageUrl'],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  _showPickerImage(context, '1');
                                },
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset(
                                  'assets/logo/icons/picture.png',
                                  height: 35.0,
                                  width: 35.0,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'สําเนาหนังสือรับรองการเป็นทนายความผู้ทําคํารับรองฯ(ฉบับเดิม)จํานวน 1 ฉบับ',
                    style: TextStyle(
                        fontSize: 14.00,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _itemImage2.isNotEmpty
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4.7,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      _itemImage2[0]['id'].toString(), "");
                                },
                                padding: const EdgeInsets.all(0),
                                child: _itemImage2[0]['isPdf']
                                    ? Image.asset(
                                        'assets/images/file-other.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.contain)
                                    : Image.network(
                                        _itemImage2[0]['imageUrl'],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                            _itemImage2.length == 2
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4.7,
                                    height: 100,
                                    child: MaterialButton(
                                      onPressed: () {
                                        dialogDeleteImage(
                                            _itemImage2[1]['id'].toString(),
                                            "");
                                      },
                                      padding: const EdgeInsets.all(0),
                                      child: _itemImage2[1]['isPdf']
                                          ? Image.asset(
                                              'assets/images/file-other.png',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 100,
                                              fit: BoxFit.contain)
                                          : Image.network(
                                              _itemImage2[1]['imageUrl'],
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 100,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  )
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width / 4.7,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEEEEE),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: MaterialButton(
                                      onPressed: () {
                                        _showPickerImage(context, '2');
                                      },
                                      padding: const EdgeInsets.all(0),
                                      child: Image.asset(
                                        'assets/logo/icons/picture.png',
                                        height: 35.0,
                                        width: 35.0,
                                        color: const Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            _showPickerImage(context, '2');
                          },
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            'assets/logo/icons/picture.png',
                            height: 35.0,
                            width: 35.0,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                      ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'รูปถ่ายสีสวมชุดครุยเนติบัณฑิตขนาด 2 นิ้วจํานวน 2 รูป (ถ่ายไว้ไม่เกิน6เดือน)',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage3['imageUrl'] != "" &&
                              itemImage3['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage3['id'].toString(), "3");
                                },
                                padding: const EdgeInsets.all(0),
                                child: itemImage3['isPdf']
                                    ? Image.asset(
                                        'assets/images/file-other.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.contain)
                                    : Image.network(
                                        itemImage3['imageUrl'],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  _showPickerImage(context, '3');
                                },
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset(
                                  'assets/logo/icons/picture.png',
                                  height: 35.0,
                                  width: 35.0,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'สําเนาบัตรประจําตัวสมาชิกสภาทนายความจํานวน 1 ฉบับ',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage4['imageUrl'] != "" &&
                              itemImage4['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage4['id'].toString(), "4");
                                },
                                padding: const EdgeInsets.all(0),
                                child: itemImage4['isPdf']
                                    ? Image.asset(
                                        'assets/images/file-other.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.contain)
                                    : Image.network(
                                        itemImage4['imageUrl'],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  _showPickerImage(context, '4');
                                },
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset(
                                  'assets/logo/icons/picture.png',
                                  height: 35.0,
                                  width: 35.0,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'หลักฐานการเปลี่ยนแปลงข้อมูลฯเช่นเปลี่ยนชื่อตัว-ชื่อสกุลจํานวน 1 ชุด(ถ้ามีการเปลี่ยนแปลง)',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'แนบไฟล์ลายมือชื่อ',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImageSign['imageUrl'] != "" &&
                              itemImageSign['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImageSign['id'].toString(), "5");
                                },
                                padding: const EdgeInsets.all(0),
                                child: itemImageSign['isPdf']
                                    ? Image.asset(
                                        'assets/images/file-other.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.contain)
                                    : Image.network(
                                        itemImageSign['imageUrl'],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  _showPickerImage(context, '5');
                                },
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset(
                                  'assets/logo/icons/picture.png',
                                  height: 35.0,
                                  width: 35.0,
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'ลายมือชื่อ',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'ที่อยู่จัดส่งไปรษณีย์',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSA(
                    txtShippingFirstName,
                    '',
                    'ชื่อ',
                    'ชื่อ',
                    'ชื่อ',
                    true,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSA(
                      txtShippingLastName,
                      '',
                      'นามสกุล',
                      'นามสกุล',
                      'นามสกุล',
                      true,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSA(
                    txtShippingName,
                    '',
                    'ชื่อสำนักงาน/บริษัท',
                    'ชื่อสำนักงาน/บริษัท',
                    'ชื่อสำนักงาน/บริษัท',
                    true,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSA(
                      txtShippingAddress,
                      '',
                      'เลขที่',
                      'เลขที่',
                      'เลขที่',
                      true,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSANoValidator(
                    txtShippingBuilding,
                    '',
                    'อาคาร',
                    'อาคาร',
                    true,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSANoValidator(
                      txtShippingMoo,
                      '',
                      'หมู่ที่',
                      'หมู่ที่',
                      true,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      child: textFormFieldNSANoValidator(
                    txtShippingSoi,
                    '',
                    'ตรอก/ซอย',
                    'ตรอก/ซอย',
                    true,
                    false,
                    false,
                    false,
                  )),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSANoValidator(
                      txtShippingRoad,
                      '',
                      'ถนน',
                      'ถนน',
                      true,
                      false,
                      false,
                      false,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorShippingProvince
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == '' || value == null) {
                            setState(() {
                              _hasErrorShippingProvince = true;
                            });
                            return null;
                          } else {
                            setState(() {
                              _hasErrorShippingProvince = false;
                            });
                            return null;
                          }
                        },
                        hint: const Text(
                          'จังหวัด',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _selectedShippingProvince,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedShippingDistrict = "";
                            _itemShippingDistrict = [];
                            _selectedShippingSubDistrict = "";
                            _itemShippingSubDistrict = [];
                            _selectedShippingPostalCode = "";
                            _itemShippingPostalCode = [];
                            _selectedShippingProvince = newValue as String;
                            _hasErrorShippingProvince = false;
                          });
                          getShippingDistrict();
                        },
                        items: _itemShippingProvince.map((item) {
                          return DropdownMenuItem(
                            value: item['code'],
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF758C29),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorShippingProvince)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกจังหวัด',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorShippingDistrict
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == '' || value == null) {
                            setState(() {
                              _hasErrorShippingDistrict = true;
                            });
                            return null;
                          } else {
                            setState(() {
                              _hasErrorShippingDistrict = false;
                            });
                            return null;
                          }
                        },
                        hint: const Text(
                          'อำเภอ',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemShippingDistrict.any((item) =>
                                item['code'] == _selectedShippingDistrict)
                            ? _selectedShippingDistrict
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedShippingSubDistrict = "";
                            _itemShippingSubDistrict = [];
                            _selectedShippingPostalCode = "";
                            _itemShippingPostalCode = [];
                            _selectedShippingDistrict = newValue as String;
                            _hasErrorShippingDistrict = false;
                          });
                          getShippingSubDistrict();
                        },
                        items: _itemShippingDistrict.map((item) {
                          return DropdownMenuItem(
                            value: item['code'],
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF758C29),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorShippingDistrict)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกอำเภอ',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorShippingSubDistrict
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == '' || value == null) {
                            setState(() {
                              _hasErrorShippingSubDistrict = true;
                            });
                            return null;
                          } else {
                            setState(() {
                              _hasErrorShippingSubDistrict = false;
                            });
                            return null;
                          }
                        },
                        hint: const Text(
                          'ตำบล',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemShippingSubDistrict.any((item) =>
                                item['code'] == _selectedShippingSubDistrict)
                            ? _selectedShippingSubDistrict
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedShippingPostalCode = "";
                            _itemShippingPostalCode = [];
                            _selectedShippingSubDistrict = newValue as String;
                            _hasErrorShippingSubDistrict = false;
                          });
                          getShippingPostalCode();
                        },
                        items: _itemShippingSubDistrict.map((item) {
                          return DropdownMenuItem(
                            value: item['code'],
                            child: Text(
                              item['title'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF758C29),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorShippingSubDistrict)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกตำบล',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(28.5),
                        border: Border.all(
                          color: _hasErrorShippingPostalCode
                              ? Colors.red
                              : const Color(0xFF758C29).withOpacity(0.7),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                            fontSize: 0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == '' || value == null) {
                            setState(() {
                              _hasErrorShippingPostalCode = true;
                            });
                            return null;
                          } else {
                            setState(() {
                              _hasErrorShippingPostalCode = false;
                            });
                            return null;
                          }
                        },
                        hint: const Text(
                          'รหัสไปรษณีย์',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemShippingPostalCode.any((item) =>
                                item['postCode'] == _selectedShippingPostalCode)
                            ? _selectedShippingPostalCode
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          setState(() {
                            _selectedShippingPostalCode = newValue as String;
                            _hasErrorShippingPostalCode = false;
                          });
                        },
                        items: _itemShippingPostalCode.map((item) {
                          return DropdownMenuItem(
                            value: item['postCode'],
                            child: Text(
                              item['postCode'],
                              style: const TextStyle(
                                fontSize: 14.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF758C29),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_hasErrorShippingPostalCode)
                      const Padding(
                        padding: EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                          'กรุณาเลือกรหัสไปรษณีย์',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Kanit',
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSA(
              txtShippingPhone,
              '',
              'เบอร์โทรศัพท์',
              'เบอร์โทรศัพท์',
              'เบอร์โทรศัพท์',
              true,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 50),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(35),
                color: const Color(0xFFED6B2D),
                child: MaterialButton(
                  height: 30,
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      submitReporter();
                    } else {}
                  },
                  child: const Text(
                    'ถัดไป',
                    style: TextStyle(
                      fontSize: 17.0,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // txtFirstName.dispose();
    // txtLastName.dispose();
    super.dispose();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  void initState() {
    var now = DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    getProvince();
    getCompanyProvince();
    getShippingProvince();
    _callRead();
    super.initState();
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
        setState(() {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;

          txtExpDate.text = DateFormat("dd-MM-yyyy").format(date);
        });
      },
      currentTime: DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
      locale: dt_picker.LocaleType.th,
    );
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = isNewAddress == true ? result['objectData'] : [];
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

  Future<dynamic> getCompanyProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemCompanyProvince = result['objectData'];
      });
    }
  }

  Future<dynamic> getCompanyDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedCompanyProvince,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemCompanyDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getCompanySubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedCompanyProvince,
      'district': _selectedCompanyDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemCompanySubDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getCompanyPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedCompanySubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemCompanyPostalCode = result['objectData'];
      });
    }
  }

  Future<dynamic> getShippingProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemShippingProvince = result['objectData'];
      });
    }
  }

  Future<dynamic> getShippingDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedShippingProvince,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemShippingDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getShippingSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedShippingProvince,
      'district': _selectedShippingDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemShippingSubDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getShippingPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedShippingSubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemShippingPostalCode = result['objectData'];
      });
    }
  }

  void _showPickerImage(context, String type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text(
                    'ไฟล์ในเครื่อง',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imageFromFile(type);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text(
                    'อัลบั้มรูปภาพ',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromGallery(type);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera(type);
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

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    if (widget.model != null) {
      setState(() {
        txtCode_id.text = widget.model[0]['code_id'];
        _selectedPrefix = widget.model[0]['title_t'];
        txtFirstName.text = widget.model[0]['fname_t'];
        txtLastName.text = widget.model[0]['lname_t'];
        _selectedPrefixEN = (widget.model[0]['title_e']).replaceAll('.', '');
        txtFirstNameEN.text = widget.model[0]['fname_e'];
        txtLastNameEN.text = widget.model[0]['lname_e'];
        txtCom_no.text = widget.model[0]['com_no'];
      });

      setState(() {
        isChkmodel = true;
      });
    } else {
      setState(() {
        isChkmodel = false;
        selectedNewAddress = 2;
        isNewAddress = true;
      });
    }
  }

  _imageFromFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = XFile(result.files.single.path!);
      });
    }
    _upload(type);
  }

  _imgFromCamera(String type) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload(type);
  }

  _imgFromGallery(String type) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });

    _upload(type);
  }

  void _upload(String type) async {
    if (_image == null) return;

    Random random = Random();
    uploadImageX(_image).then((res) {
      setState(() {
        if (type == "1") {
          bool isPdf = res.toLowerCase().endsWith('.pdf');
          itemImage1 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
            'isPdf': isPdf,
          };
        }
        if (type == "2") {
          if (_itemImage2.length < 2) {
            bool isPdf = res.toLowerCase().endsWith('.pdf');

            _itemImage2.add({
              'imageUrl': res,
              'id': random.nextInt(100),
              'imageType': type,
              'isPdf': isPdf,
            });
          }
        }
        if (type == "3") {
          bool isPdf = res.toLowerCase().endsWith('.pdf');

          itemImage3 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
            'isPdf': isPdf,
          };
        }

        if (type == "4") {
          bool isPdf = res.toLowerCase().endsWith('.pdf');
          itemImage4 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
            'isPdf': isPdf,
          };
        }
        if (type == "5") {
          bool isPdf = res.toLowerCase().endsWith('.pdf');
          itemImageSign = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
            'isPdf': isPdf,
          };
        }
      });
    }).catchError((err) {
      print(err);
    });
  }

  dialogDeleteImage(String code, String type) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(
          'ต้องการลบรูปภาพ ใช่ไหม',
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
              "ยกเลิก",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text(
              "ลบ",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFFA9151D),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              deleteImage(code, type);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  deleteImage(String code, String type) async {
    setState(() {
      if (type == "") {
        _itemImage2.removeWhere((c) => c['id'].toString() == code.toString());
      }
      if (type == "1") {
        itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "3") {
        itemImage3 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "4") {
        itemImage4 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "5") {
        itemImageSign = {"imageUrl": "", "id": "", "imageType": ""};
      }
    });
  }

  Future<dynamic> submitReporter() async {
    _itemImage = [];
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);
    var profileCode = await storage.read(key: 'profileCode18');

    var province = _selectedProvince != "" && _selectedProvince != null
        ? _itemProvince
            .where((i) => i["code"] == _selectedProvince)
            .first['title']
        : "";
    var tambon = _selectedSubDistrict != "" && _selectedSubDistrict != null
        ? _itemSubDistrict
            .where((i) => i["code"] == _selectedSubDistrict)
            .first['title']
        : "";
    var amphoe = _selectedDistrict != "" && _selectedDistrict != null
        ? _itemDistrict
            .where((i) => i["code"] == _selectedDistrict)
            .first['title']
        : "";

    var companyProvince =
        _selectedCompanyProvince != "" && _selectedCompanyProvince != null
            ? _itemCompanyProvince
                .where((i) => i["code"] == _selectedCompanyProvince)
                .first['title']
            : "";
    var companyTambon =
        _selectedCompanySubDistrict != "" && _selectedCompanySubDistrict != null
            ? _itemCompanySubDistrict
                .where((i) => i["code"] == _selectedCompanySubDistrict)
                .first['title']
            : "";
    var companyAmphoe =
        _selectedCompanyDistrict != "" && _selectedCompanyDistrict != null
            ? _itemCompanyDistrict
                .where((i) => i["code"] == _selectedCompanyDistrict)
                .first['title']
            : "";

    var shippingProvince =
        _selectedShippingProvince != "" && _selectedShippingProvince != null
            ? _itemShippingProvince
                .where((i) => i["code"] == _selectedShippingProvince)
                .first['title']
            : "";
    var shippingTambon = _selectedShippingSubDistrict != "" &&
            _selectedShippingSubDistrict != null
        ? _itemShippingSubDistrict
            .where((i) => i["code"] == _selectedShippingSubDistrict)
            .first['title']
        : "";
    var shippingAmphoe =
        _selectedShippingDistrict != "" && _selectedShippingDistrict != null
            ? _itemShippingDistrict
                .where((i) => i["code"] == _selectedShippingDistrict)
                .first['title']
            : "";

    if (!isCertifyStatus) {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณายืนยันสถานภาพการเป็นผู้ประกอบวิชาชีพทนายความ โดยการติ๊กถูกในช่องที่กำหนด',
      );
      return;
    }

    if (!isCertifyPunish) {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณายืนยันว่าคุณไม่ได้อยู่ระหว่างถูกลงโทษฐานประพฤติผิดมรรยาททนายความ โดยการติ๊กถูกในช่องที่กำหนด',
      );
      return;
    }

    if (!isAgree) {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณายืนยันความยินยอมชำระค่าธรรมเนียมและปฏิบัติตามกฎระเบียบ โดยการติ๊กถูกในช่องที่กำหนด',
      );
      return;
    }

    if (!isEvidence) {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณายืนยันว่าคุณได้แนบหลักฐานประกอบการแจ้งเปลี่ยนแปลงข้อมูลเรียบร้อยแล้ว โดยการติ๊กถูกในช่องที่กำหนด',
      );
      return;
    }

    if (itemImage1['imageUrl'] != "") {
      _itemImage.add(itemImage1);
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'สําเนาหนังสือรับรองการเป็นทนายความผู้ทําคํารับรองฯ(ฉบับเดิม)จํานวน 1 ฉบับ',
      );
      return;
    }

    if (_itemImage2.isNotEmpty) {
      for (var c in _itemImage2) {
        _itemImage.add(c);
      }
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณาเพิ่มรูปถ่ายสีสวมชุดรุยเนติบัณฑิตขนาด 2 นิ้วจํานวน2รูป (ถ่ายไว้ไม่เกิน6เดือน)',
      );
      return;
    }

    if (itemImage3['imageUrl'] != "") {
      _itemImage.add(itemImage3);
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'สําเนาบัตรประจําตัวสมาชิกสภาทนายความจํานวน 1 ฉบับ',
      );
      return;
    }

    // if (itemImage4['imageUrl'] != "") {
    //   _itemImage.add(itemImage3);
    // } else {
    //   _dialogStatus(
    //     'แจ้งเตือน!',
    //     'หลักฐานการเปลี่ยนแปลงข้อมูลฯเช่นเปลี่ยนชื่อตัว-ชื่อสกุล จํานวน 1 ชุด(ถ้ามีการเปลี่ยนแปลง)',
    //   );
    //   return;
    // }

    if (itemImageSign['imageUrl'] != "") {
      _itemImage.add(itemImageSign);
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณาเพิ่มรูปถ่ายลายมือชื่อ',
      );
      return;
    }

    var data = {
      "code_id": txtCode_id.text,
      "prefixName": _selectedPrefix,
      "firstName": txtFirstName.text,
      "lastName": txtLastName.text,
      "prefixNameEN": _selectedPrefixEN,
      "firstNameEN": txtFirstNameEN.text,
      "lastNameEN": txtLastNameEN.text,
      "isMemberType": isMemterType,
      "lcTypeName": lcTypeName,
      "com_no": txtCom_no.text,
      "memberExpireDate": txtDate.text,
      "docNo": txtDocNo.text,
      "expireDate": txtExpDate.text,
      "isCertifyStatus": isCertifyStatus,
      "isCertifyPunish": isCertifyPunish,
      "isNewAddress": isNewAddress,
      "isAgree": isAgree,
      "isEvidence": isEvidence,
      "profileCode": profileCode,
      "createBy": user['username'] ?? '',
      "imageUrlCreateBy": user['imageUrl'] ?? '',
      "imageUrl": '',
      "gallery": _itemImage,
      "paymentAmount": '',
      "paymentDate": '',
      "paymentTime": '',
      "paymentImageUrl": '',
      "paymentType": '',
    };

    if (isNewAddress == true) {
      // data["newPrefixName"] = newPrefixName;
      data["newFirstName"] = txtNewFirstName.text;
      data["newLastName"] = txtNewLastName.text;
      // data["newPrefixNameEN"] = newPrefixNameEN;
      data["newFirstNameEN"] = txtNewFirstNameEN.text;
      data["newLastNameEN"] = txtNewLastNameEN.text;
      data["address"] = txtAddress.text;
      data["moo"] = txtMoo.text;
      data["soi"] = txtSoi.text;
      data["road"] = txtRoad.text;
      data["tambonCode"] = _selectedSubDistrict;
      data["tambon"] = tambon;
      data["amphoeCode"] = _selectedDistrict;
      data["amphoe"] = amphoe;
      data["provinceCode"] = _selectedProvince;
      data["province"] = province;
      data["postnoCode"] = _selectedPostalCode;
      data["phone"] = txtPhone.text;
      data["fax"] = txtFax.text;
      data["email"] = txtEmail.text;
      data["companyName"] = txtCompanyName.text;
      data["companyAddress"] = txtCompanyAddress.text;
      data["companyMoo"] = txtCompanyMoo.text;
      data["companyBuilding"] = txtCompanyBuilding.text;
      data["companySoi"] = txtCompanySoi.text;
      data["companyRoad"] = txtCompanyRoad.text;
      data["companyTambonCode"] = _selectedCompanySubDistrict;
      data["companyTambon"] = companyTambon;
      data["companyAmphoeCode"] = _selectedCompanyDistrict;
      data["companyAmphoe"] = companyAmphoe;
      data["companyProvinceCode"] = _selectedCompanyProvince;
      data["companyProvince"] = companyProvince;
      data["companyPostnoCode"] = _selectedCompanyPostalCode;
      data["companyPhone"] = txtCompanyPhone.text;
      data["companyFax"] = txtCompanyFax.text;
      data["companyEmail"] = txtCompanyEmail.text;
    } else {
      data["address"] = widget.model[0]["haddr_t"] ?? '-';
      data["moo"] = widget.model[0]["moo"] ?? '-';
      data["soi"] = widget.model[0]["soi"] ?? '-';
      data["road"] = widget.model[0]["road"] ?? '-';
      data["tambonCode"] = widget.model[0]["tambonCode"] ?? '-';
      data["tambon"] = widget.model[0]["tambon"] ?? '-';
      data["amphoeCode"] = widget.model[0]["amphoeCode"] ?? '-';
      data["amphoe"] = widget.model[0]["amphoe"] ?? '-';
      data["provinceCode"] = widget.model[0]["provinceCode"] ?? '-';
      data["province"] = widget.model[0]["province"] ?? '-';
      data["postnoCode"] = widget.model[0]["hzipcode"] ?? '-';
      data["phone"] = widget.model[0]["hphone"] ?? '-';
      data["fax"] = widget.model[0]["hphone"] ?? '-';
      data["email"] = widget.model[0]["email"] ?? '-';
      data["companyName"] = widget.model[0]["office_t"] ?? '-';
      data["companyAddress"] = widget.model[0]["oaddr_t"] ?? '-';
      data["companyMoo"] = widget.model[0]["companyMoo"] ?? '-';
      data["companyBuilding"] = widget.model[0]["companyBuilding"] ?? '-';
      data["companySoi"] = widget.model[0]["companySoi"] ?? '-';
      data["companyRoad"] = widget.model[0]["companyRoad"] ?? '-';
      data["companyTambonCode"] = widget.model[0]["companyTambonCode"] ?? '-';
      data["companyTambon"] = widget.model[0]["companyTambon"] ?? '-';
      data["companyAmphoeCode"] = widget.model[0]["companyAmphoeCode"] ?? '-';
      data["companyAmphoe"] = widget.model[0]["companyAmphoe"] ?? '-';
      data["companyProvinceCode"] =
          widget.model[0]["companyProvinceCode"] ?? '-';
      data["companyProvince"] = widget.model[0]["companyProvince"] ?? '-';
      data["companyPostnoCode"] = widget.model[0]["ozipcode"] ?? '-';
      data["companyPhone"] = widget.model[0]["ophone"] ?? '-';
      data["companyFax"] = widget.model[0]["ofax"] ?? '-';
      data["companyEmail"] = widget.model[0]["companyEmail"] ?? '-';
    }

    data["shippingFirstName"] = txtShippingFirstName.text;
    data["shippingLastName"] = txtShippingLastName.text;
    data["shippingName"] = txtShippingName.text;
    data["shippingAddress"] = txtShippingAddress.text;
    data["shippingBuilding"] = txtShippingBuilding.text;
    data["shippingMoo"] = txtShippingMoo.text;
    data["shippingSoi"] = txtShippingSoi.text;
    data["shippingRoad"] = txtShippingRoad.text;
    data["shippingTambonCode"] = _selectedShippingSubDistrict;
    data["shippingTambon"] = shippingTambon;
    data["shippingAmphoeCode"] = _selectedShippingDistrict;
    data["shippingAmphoe"] = shippingAmphoe;
    data["shippingProvinceCode"] = _selectedShippingProvince;
    data["shippingProvince"] = shippingProvince;
    data["shippingPostnoCode"] = _selectedShippingPostalCode;
    data["shippingPhone"] = txtShippingPhone.text;
    // print('--${json.encode(data)}');

    // String jsonString = jsonEncode(data);
    // const chunkSize = 1000; // Define the max size of each chunk
    // for (int i = 0; i < jsonString.length; i += chunkSize) {
    //   print(jsonString.substring(
    //       i,
    //       i + chunkSize > jsonString.length
    //           ? jsonString.length
    //           : i + chunkSize));
    // }
    _modelReport = await postDio(reporterT02ReadApi, {'code': profileCode});

    print('--123---$profileCode');
    if (_modelReport.length > 0) {
      data["code"] = _modelReport[0]['code'];

      final result = await postObjectData('m/v2/ReporterT02/update', data);

      if (result['status'] == 'S') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NsaReportPayForm(
              type: 'reportT02',
              title: '',
            ),
          ),
        );
      }
    } else {
      final result = await postObjectData('m/v2/ReporterT02/create', data);
      if (result['status'] == 'S') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NsaReportPayForm(
              type: 'reportT02',
              title: '',
            ),
          ),
        );
      }
    }
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
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFFED6B2D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            width:
                                MediaQuery.of(context).size.height / 100 * 14,

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
