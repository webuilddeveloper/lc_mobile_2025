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
import 'package:permission_handler/permission_handler.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../../widget/header_v2.dart';
import '../../widget/text_form_field.dart';
import 'nsa_report_pay.dart';

class NsaReportRegisterPage extends StatefulWidget {
  const NsaReportRegisterPage({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NsaReportRegisterPageState createState() => _NsaReportRegisterPageState();
}

class _NsaReportRegisterPageState extends State<NsaReportRegisterPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  bool _hasErrorPrefix = false;
  final bool _hasErrorNewPrefix = false;
  bool _hasErrorPrefixEN = false;
  bool _hasErrorProvince = false;
  bool _hasErrorDistrict = false;
  bool _hasErrorSubDistrict = false;
  bool _hasErrorPostalCode = false;

  final List<dynamic> _itemPrefix = [
    {'code': '1', 'title': 'นาย'},
    {'code': '2', 'title': 'นางสาว'},
    {'code': '3', 'title': 'นาง'}
  ];
  final List<dynamic> _itemPrefixEN = [
    {'code': '1', 'title': 'Mr.'},
    {'code': '2', 'title': 'Mrs.'},
    {'code': '3', 'title': 'Miss'}
  ];
  late String _selectedPrefix = '';
  late String _selectedNewPrefix;
  late String _selectedPrefixEN = '';

  int selectLcType = 1;
  String lcTypeName = "สองปี";
  bool isMemterType = false;

  bool isLawyersConduct = false;
  bool isNoCriminal = false;
  bool isOther = false;

  dynamic _modelReport = {};

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

  List<dynamic> _itemProvince = [];
  late String _selectedProvince = '';
  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict;
  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict = '';
  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode = '';

  Color selectedColor = const Color(0xFF758C29);

  late String profileCode = '';
  dynamic _model;
  late Future<dynamic> _futureProfile;

  dynamic _modelConfig = {};
  late Future<dynamic> _futureMemberConfig;

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerNSA(context,
          callback: goBack, title: 'สมัครสมาชิก', contentRight: Container()),
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
          Center(
            child: Text(
              _modelConfig['title'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color(0xFF707070),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Center(
          //   child: Text(
          //     'การอบรมทนายรับรองลายมือชื่อ',
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 17,
          //       color: Color(0xFF707070),
          //     ),
          //   ),
          // ),
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
                value:
                    _itemPrefix.any((item) => item['title'] == _selectedPrefix)
                        ? _selectedPrefix
                        : null,
                hint: const Text(
                  'คำนำหน้า',
                  style: TextStyle(
                    fontSize: 14.00,
                    fontFamily: 'Kanit',
                    color: Color(0xFF758C29),
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
              )),
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
                // Expanded(
                //   child: Container(
                //       child: textFormFieldNSA(
                //     txtFirstName,
                //     null,
                //     'ชื่อ(ภาษาไทย)',
                //     'ชื่อ(ภาษาไทย)',
                //     'ชื่อ(ภาษาไทย)',
                //     true,
                //     false,
                //     false,
                //     false,
                //   )),
                // ),
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
                value: _itemPrefixEN
                        .any((item) => item['code'] == _selectedPrefixEN)
                    ? _selectedPrefixEN
                    : null,
                hint: const Text(
                  'คำนำหน้า',
                  style: TextStyle(
                    fontSize: 14.00,
                    fontFamily: 'Kanit',
                    color: Color(0xFF758C29),
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
                    value: item['code'],
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
              )),
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
          const SizedBox(height: 15),
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
                    controller: txtDate,
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
                      hintText: 'วัน / เดือน / ปีเกิด',
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
                      if (model!.isEmpty) {
                        return 'กรุณากรอกวันเดือนปีเกิด.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: textFormFieldNSA(
              txtIdCard,
              '',
              'เลขประจำตัวประชาชน',
              'เลขประจำตัวประชาชน',
              'เลขประจำตัวประชาชน',
              true,
              false,
              false,
              true,
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
                      txtMoo,
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
                    txtSoi,
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
                      txtRoad,
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
                          if (value == '' || value == null) {
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
                        },
                        hint: const Text(
                          'จังหวัด',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemProvince.any(
                                (item) => item['code'] == _selectedProvince)
                            ? _selectedProvince
                            : null,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
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
                        },
                        items: _itemProvince.map((item) {
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
                          horizontal: 15, vertical: 0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
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
                                color: Color(0xFF758C29),
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
                        color: const Color(0xFFFFFFFF),
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
                                color: Color(0xFF758C29),
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
                        color: const Color(0xFFFFFFFF),
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
                        },
                        hint: const Text(
                          'รหัสไปรษณีย์',
                          style: TextStyle(
                            fontSize: 14.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF758C29),
                          ),
                        ),
                        value: _itemPostalCode.any(
                                (item) => item['code'] == _selectedPostalCode)
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
              true,
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
              true,
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
              true,
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
                                  // _imageFromFiile('1');
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
                                        // _showPickerImage(context, '2');
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
                    'รูปถ่ายสีสวมชุดครุยเนติบัณฑิตขนาด 2 นิ้วจํานวน 2 รูป',
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

  Future<void> requestPermissions() async {
    // สำหรับ Android 13+
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }

    if (await Permission.videos.isDenied) {
      await Permission.videos.request();
    }

    // สำหรับการจัดการไฟล์ทั่วไป
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  _imageFromFile(String type) async {
    requestPermissions();

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

  // ignore: unused_element
  _imageFromFiile(String type) async {
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
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });
    _upload(type);
  }

  _imgFromGallery(String type) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

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
      if (type == "2") {
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

  _callRead() async {
    _futureMemberConfig = postDio(reporterMemberConfigReadApi,
        {'database': 'lc_signature_prod', 'username': 'ReporterMember'});
    _modelConfig = await _futureMemberConfig;
    _modelConfig['title'] = _modelConfig['title'].replaceAll('\\n', '\n');

    if (_modelConfig['description'] != 'A') {
      _dialogStatusConfig(
        'แจ้งเตือน!',
        'ระบบยังไม่เปิดให้ทำการสมัครสมาชิกสำหรับการอบรมทนายรับรองลายมือชื่อ',
      );
      return;
    }
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

    var data = {
      "prefixName": _selectedPrefix,
      "firstName": txtFirstName.text,
      "lastName": txtLastName.text,
      "prefixNameEN": _selectedPrefixEN,
      "firstNameEN": txtFirstNameEN.text,
      "lastNameEN": txtLastNameEN.text,
      "isMemberType": isMemterType,
      "idCard": txtIdCard.text,
      "com_no": txtCom_no.text,
      "birthDate": txtDate.text,
      "profileCode": profileCode,
      "createBy": user['username'] ?? '',
      "imageUrlCreateBy": user['imageUrl'] ?? '',
      "imageUrl": '',
      "gallery": _itemImage,
      "paymentAmount": '',
      "paymentDate": '',
      "paymentTime": '',
      "paymentImageUrl": '',
    };

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

    // String jsonString = jsonEncode(data);
    // const chunkSize = 1000; // Define the max size of each chunk
    // for (int i = 0; i < jsonString.length; i += chunkSize) {
    //   print(jsonString.substring(
    //       i,
    //       i + chunkSize > jsonString.length
    //           ? jsonString.length
    //           : i + chunkSize));
    // }

    _modelReport =
        await postDio(reporterRegisterReadApi, {'code': profileCode});
    if (_modelReport.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NsaReportPayForm(
            type: 'reportRegister',
            title: '',
          ),
        ),
      );
    } else {
      final result = await postObjectData('m/v2/ReporterRegister/create', data);
      if (result['status'] == 'S') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NsaReportPayForm(
              type: 'reportRegister',
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Future<dynamic> _dialogStatusConfig(String title, String subTitle) async {
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subTitle,
                      style: const TextStyle(
                        fontSize: 16,
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
