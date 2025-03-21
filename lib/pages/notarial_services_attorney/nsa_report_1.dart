// ignore_for_file: missing_return, no_leading_underscores_for_local_identifiers, duplicate_ignore

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

class NsaReport1Page extends StatefulWidget {
  const NsaReport1Page({
    super.key,
    this.model,
  });

  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _NsaReport1PageState createState() => _NsaReport1PageState();
}

class _NsaReport1PageState extends State<NsaReport1Page> {
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
  late String _selectedPrefix;
  late String _selectedPrefixEN;

  int selectLcType = 1;
  String lcTypeName = "2 ปี";

  bool isLawyersConduct = false;
  bool isNoCriminal = false;
  bool isOther = false;

  bool _loading = false;

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

  List<dynamic> _itemImage = [];
  final List<dynamic> _itemImage3 = [];
  late XFile _image;

  DateTime selectedDate = DateTime.now();
  final txtDate = TextEditingController();
  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;
  dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage2 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage3 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImageSign = {"imageUrl": "", "id": "", "imageType": ""};

  dynamic _modelReport = {};

  List<dynamic> _itemProvince = [];
  String? _selectedProvince;
  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict;
  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict;
  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode;

  List<dynamic> _itemCompanyProvince = [];
  String? _selectedCompanyProvince;

  List<dynamic> _itemCompanyDistrict = [];
  late String _selectedCompanyDistrict;
  List<dynamic> _itemCompanySubDistrict = [];
  late String _selectedCompanySubDistrict;
  List<dynamic> _itemCompanyPostalCode = [];
  late String _selectedCompanyPostalCode;

  List<dynamic> _itemShippingProvince = [];
  String? _selectedShippingProvince;
  List<dynamic> _itemShippingDistrict = [];
  late String _selectedShippingDistrict;
  List<dynamic> _itemShippingSubDistrict = [];
  late String _selectedShippingSubDistrict;
  List<dynamic> _itemShippingPostalCode = [];
  late String _selectedShippingPostalCode;

  Color selectedColor = const Color(0xFF758C29);

  bool isNewAddress = true;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerNSA(context,
          callback: goBack, title: 'แบบ ทรอ.1', contentRight: Container()),
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
              'คำขอขึ้นทะเบียนเป็นทนายความ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const Center(
            child: Text(
              'ผู้ทำคำรับรองลายมือชื่อและเอกสาร',
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
                    ),
                  ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    child: textFormFieldNSA(
                      txtAge,
                      '',
                      'อายุ',
                      'อายุ',
                      'อายุ',
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
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'ประเภททนายความ',
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
                          selectedColor = const Color(0xFF758C29);
                        }),
                      ),
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
          Container(
            alignment: Alignment.centerLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: Text(
                'ที่อยู่ปัจจุบัน',
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
                          horizontal: 10, vertical: 0),
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
                        // value: _selectedProvince,
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
                        // items: _itemProvince.map((item) {
                        //   return DropdownMenuItem(
                        //     value: item['code'],
                        //     child: Text(
                        //       item['title'],
                        //       style: const TextStyle(
                        //         fontSize: 14.00,
                        //         fontFamily: 'Kanit',
                        //         color: Color(0xFF758C29),
                        //       ),
                        //     ),
                        //   );
                        // }).toList(),
                        items: _itemProvince.toSet().map((item) {
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
                          horizontal: 8, vertical: 0),
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
                'ที่อยู่สำนักงาน / บริษัท',
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
                child: textFormFieldNSA(
              txtCompanyAddress,
              '',
              'สำนักงาน/บริษัท เลขที่',
              'สำนักงาน/บริษัทเลขที่',
              'สำนักงาน/บริษัทเลขที่',
              true,
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
                          },
                          hint: const Text(
                            'จังหวัด',
                            style: TextStyle(
                              fontSize: 14.00,
                              fontFamily: 'Kanit',
                              color: Color(0xFF758C29),
                            ),
                          ),
                          // value: _selectedCompanyProvince,
                          value: _itemCompanyProvince.any((item) =>
                                  item['code'] == _selectedCompanyProvince)
                              ? _selectedCompanyProvince
                              : null,

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
                                  color: Color(0xFF758C29),
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
                  ),
                ),
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
                                color: Color(0xFF758C29),
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
                        color: const Color(0xFFFFFFFF),
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
                                color: Color(0xFF758C29),
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
                        color: const Color(0xFFFFFFFF),
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
              txtCompanyFax,
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
              txtCompanyEmail,
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
                'ข้าพเจ้าขอรับรองว่า',
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data:
                      ThemeData(unselectedWidgetColor: const Color(0xFF758C29)),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.all(0),
                    value: isLawyersConduct,
                    title: const Text(
                        "ข้าพเจ้าไม่เคยต้องโทษคดีมรรยาททนายความ (โทษภาคทัณฑ์)",
                        style: TextStyle(
                          fontFamily: 'Kanit',
                        )),
                    onChanged: (value) => setState(
                      (() {
                        isLawyersConduct = value!;
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Theme(
                  data:
                      ThemeData(unselectedWidgetColor: const Color(0xFF758C29)),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.all(0),
                    value: isNoCriminal,
                    title: const Text(
                        "ขณะยื่นคำขอนี้ ข้าพเจ้ายังมีสถานภาพเป็นทนายความ ไม่อยู่ระหว่างถูกดำเนินคดีอาญา (ยกเว้นคดีเกี่ยวกับความผิดฐานประมาทและลหุโทษ) หรืออยู่ระหว่างถูกสอบสวนว่ากระทำผิดมรรยาททนายความหรือถูกฟ้องเป็นคดีล้มละลาย",
                        style: TextStyle(
                          fontFamily: 'Kanit',
                        )),
                    onChanged: (value) => setState(
                      (() {
                        isNoCriminal = value!;
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data:
                      ThemeData(unselectedWidgetColor: const Color(0xFF758C29)),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: const EdgeInsets.all(0),
                    value: isOther,
                    title: const Text("ข้าพเจ้าเคยถูกลงโทษคดีมรรยาททนายความ",
                        style: TextStyle(
                          fontFamily: 'Kanit',
                        )),
                    onChanged: (value) => setState(
                      (() {
                        isOther = value!;
                        if (!isOther) txtOtherDetail.text = '';
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
                child: textFormFieldNSANoValidator(
              txtOtherDetail,
              '',
              'ระบุ..',
              'ระบุ..',
              isOther,
              false,
              false,
              false,
            )),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
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
                                  // _imageFromFile('1');
                                  // pickFileWithPermission();
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
                    'สําเนาหนังสือรับรองการเป็นทนายความผู้ทําคํารับรองลายมือชื่อๆ(ฉบับเดิม)จํานวน 1 ฉบับ',
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
                      itemImage2['imageUrl'] != "" &&
                              itemImage2['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage2['id'].toString(), "2");
                                },
                                padding: const EdgeInsets.all(0),
                                child: itemImage2['isPdf']
                                    ? Image.asset(
                                        'assets/images/file-other.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.contain)
                                    : Image.network(
                                        itemImage2['imageUrl'],
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
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'สำเนาบัตรประจำตัวสมาชิกสภาทนายความ จำนวน 1 ฉบับ',
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
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _itemImage3.isNotEmpty
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
                                      _itemImage3[0]['id'].toString(), "");
                                },
                                padding: const EdgeInsets.all(0),
                                child: _itemImage3[0]['isPdf']
                                    ? Image.asset(
                                        'assets/images/file-other.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.contain)
                                    : Image.network(
                                        _itemImage3[0]['imageUrl'],
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 100,
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                            _itemImage3.length == 2
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 4.7,
                                    height: 100,
                                    child: MaterialButton(
                                      onPressed: () {
                                        dialogDeleteImage(
                                            _itemImage3[1]['id'].toString(),
                                            "");
                                      },
                                      padding: const EdgeInsets.all(0),
                                      child: _itemImage3[1]['isPdf']
                                          ? Image.asset(
                                              'assets/images/file-other.png',
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 100,
                                              fit: BoxFit.contain)
                                          : Image.network(
                                              _itemImage3[1]['imageUrl'],
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
                                        _showPickerImage(context, '3');
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
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  padding: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'รูปถ่ายสีสวมชุดรุยเนติบัณฑิตขนาด 2 นิ้วจํานวน 2 รูป (ถ่ายไว้ไม่เกิน6เดือน)',
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
                                      itemImageSign['id'].toString(), "4");
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
                          horizontal: 10, vertical: 0),
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
                        value: _itemShippingProvince.any((item) =>
                                item['code'] == _selectedShippingProvince)
                            ? _selectedShippingProvince
                            : null, // ป้องกัน error ถ้าค่าไม่มีใน list
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          TextEditingController().clear();
                        },
                        onChanged: (newValue) {
                          print("Selected Province: $newValue");
                          print(
                              "Province List: ${_itemShippingProvince.map((e) => e['code']).toList()}");

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
                            _selectedShippingPostalCode = "";
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
    if (mounted) {
      Navigator.pop(context, false);
    }
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
    _callRead();
    getProvince();
    getCompanyProvince();
    getShippingProvince();

    super.initState();
  }

  void _callRead() {
    if (widget.model == null || widget.model == '') return;

    if (widget.model['profileCode'] != null &&
        widget.model['profileCode'] != '') {
      print('---1---update');
      _updateExistingData();
    } else {
      print('---1---newCreate');
      _createNewData();
    }
  }

  void _updateExistingData() {
    setState(() {
      // Update personal details
      txtCode_id.text = widget.model['code_id'];
      _selectedPrefix = widget.model['prefixName'];
      txtFirstName.text = widget.model['firstName'];
      txtLastName.text = widget.model['lastName'];
      _selectedPrefixEN = widget.model['prefixNameEN'];
      txtFirstNameEN.text = widget.model['firstNameEN'];
      txtLastNameEN.text = widget.model['lastNameEN'];

      // Update birthdate details
      if (widget.model['birthDate'] != null &&
          widget.model['birthDate'] != '') {
        _parseAndSetBirthDate(widget.model['birthDate']);
      }

      // Update other fields
      txtAge.text = widget.model['age'];
      txtIdCard.text = widget.model['idCard'];
      txtCom_no.text = widget.model['com_no'];
      lcTypeName = widget.model['lcTypeName'];
      selectLcType = lcTypeName == 'สองปี' ? 1 : 2;

      // Update address
      _updateAddressFields();
      _updateCompanyDetails();
      _updateShippingDetails();

      // Fetch dependent dropdown data
      getDistrict();
      getSubDistrict();
      getPostalCode();
      getCompanyDistrict();
      getCompanySubDistrict();
      getCompanyPostalCode();
      getShippingDistrict();
      getShippingSubDistrict();
      getShippingPostalCode();
    });
  }

  void _createNewData() {
    setState(() {
      txtCode_id.text = widget.model['code_id'];
      _selectedPrefix = widget.model['title_t'];
      txtFirstName.text = widget.model['fname_t'];
      txtLastName.text = widget.model['lname_t'];
      _selectedPrefixEN = (widget.model['title_e']).replaceAll('.', '');
      txtFirstNameEN.text = widget.model['fname_e'];
      txtLastNameEN.text = widget.model['lname_e'];

      // Parse and set birthdate
      String date = widget.model['birthdate'];
      if (date != null && date.isNotEmpty) {
        _parseAndSetBirthDate(date, isThaiYear: true);
      }

      // Update other fields
      txtIdCard.text = widget.model['card_id'] ?? '';
      txtCom_no.text = widget.model['com_no'] ?? '';
      txtAddress.text = widget.model['haddr_t'] ?? '';
      txtPhone.text = widget.model['hphone'] ?? '';
      txtFax.text = widget.model['hfax'] ?? '';
      txtCompanyName.text = widget.model['office_t'] ?? '';
      txtCompanyAddress.text = widget.model['oaddr_t'] ?? '';
      txtCompanyPhone.text = widget.model['ophone'] ?? '';
      txtCompanyFax.text = widget.model['ofax'] ?? '';
    });
  }

  void _parseAndSetBirthDate(String date, {bool isThaiYear = false}) {
    List<String> parts = date.split('/');
    if (parts.length == 3) {
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      if (isThaiYear) year -= 543;
      DateTime birthDate = DateTime(year, month, day);

      setState(() {
        _selectedYear = birthDate.year;
        _selectedMonth = birthDate.month;
        _selectedDay = birthDate.day;
        txtDate.text = DateFormat("dd-MM-yyyy").format(birthDate);

        // Calculate and set age
        int age = calculateAge(birthDate, DateTime.now());
        txtAge.text = age.toString();
      });
    }
  }

  void _updateAddressFields() {
    txtAddress.text = widget.model['address'] ?? '';
    txtMoo.text = widget.model['moo'] ?? '';
    txtSoi.text = widget.model['soi'] ?? '';
    txtRoad.text = widget.model['road'] ?? '';
    _selectedProvince = widget.model['provinceCode'] ?? '';
    _selectedDistrict = widget.model['amphoeCode'] ?? '';
    _selectedSubDistrict = widget.model['tambonCode'] ?? '';
    _selectedPostalCode = widget.model['postnoCode'] ?? '';
    txtPhone.text = widget.model['phone'] ?? '';
    txtFax.text = widget.model['fax'] ?? '';
    txtEmail.text = widget.model['email'] ?? '';
  }

  void _updateCompanyDetails() {
    txtCompanyAddress.text = widget.model['companyAddress'] ?? '';
    txtCompanyName.text = widget.model['companyName'] ?? '';
    _selectedCompanyProvince = widget.model['companyProvinceCode'];
    _selectedCompanyDistrict = widget.model['companyAmphoeCode'] ?? '';
    _selectedCompanySubDistrict = widget.model['companyTambonCode'] ?? '';
    _selectedCompanyPostalCode = widget.model['companyPostnoCode'] ?? '';
    txtCompanyPhone.text = widget.model['companyPhone'] ?? '';
    txtCompanyFax.text = widget.model['companyFax'] ?? '';
    txtCompanyEmail.text = widget.model['companyEmail'] ?? '';
  }

  void _updateShippingDetails() {
    txtShippingFirstName.text = widget.model['shippingFirstName'] ?? '';
    txtShippingLastName.text = widget.model['shippingLastName'] ?? '';
    txtShippingName.text = widget.model['shippingName'] ?? '';
    txtShippingAddress.text = widget.model['shippingAddress'] ?? '';
    txtShippingMoo.text = widget.model['shippingMoo'] ?? '';
    txtShippingSoi.text = widget.model['shippingSoi'] ?? '';
    txtShippingBuilding.text = widget.model['shippingBuilding'] ?? '';
    txtShippingRoad.text = widget.model['shippingRoad'] ?? '';
    _selectedShippingProvince = widget.model['shippingProvinceCode'] ?? '';
    _selectedShippingDistrict = widget.model['shippingAmphoeCode'] ?? '';
    _selectedShippingSubDistrict = widget.model['shippingTambonCode'] ?? '';
    _selectedShippingPostalCode = widget.model['shippingPostnoCode'] ?? '';
    txtShippingPhone.text = widget.model['shippingPhone'] ?? '';
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

  int calculateAge(DateTime birthDate, DateTime currentDate) {
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--; // ยังไม่ถึงวันเกิดในปีนี้
    }
    return age;
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

  _imgFromCamera(String type) async {
    // ignore: no_leading_underscores_for_local_identifiers
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
          bool isPdf = res.toLowerCase().endsWith('.pdf');

          itemImage2 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
            'isPdf': isPdf,
          };
        }
        if (type == "3") {
          if (_itemImage3.length < 2) {
            bool isPdf = res.toLowerCase().endsWith('.pdf');

            _itemImage3.add({
              'imageUrl': res,
              'id': random.nextInt(100),
              'imageType': type,
              'isPdf': isPdf,
            });
          }
        }
        if (type == "4") {
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
        _itemImage3.removeWhere((c) => c['id'].toString() == code.toString());
      }
      if (type == "1") {
        itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "2") {
        itemImage2 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "4") {
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

    if (!isLawyersConduct) {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณายืนยันว่าคุณไม่เคยต้องโทษคดีมรรยาททนายความ โดยการติ๊กถูกในช่องที่กำหนด',
      );
      return;
    }

    if (!isNoCriminal) {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณายืนยันสถานภาพของคุณโดยการติ๊กถูกในช่องก่อนดำเนินการต่อ',
      );
      return;
    }

    if (itemImage1['imageUrl'] != "") {
      _itemImage.add(itemImage1);
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณาเพิ่มสําเนาหนังสือรับรองการเป็นทนายความผู้ทําคํารับรองลายมือชื่อๆ(ฉบับเดิม)จํานวน1ฉบับ',
      );
      return;
    }
    if (itemImage2['imageUrl'] != "") {
      _itemImage.add(itemImage2);
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณาเพิ่มสำเนาบัครประจำตัวสมาชิกสภาทนายความ จำนวน 1 ฉบับ',
      );
      return;
    }

    if (_itemImage3.isNotEmpty) {
      for (var c in _itemImage3) {
        _itemImage.add(c);
      }
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณาเพิ่มรูปถ่ายสีสวมชุดรุยเนติบัณฑิตขนาด2นิ้วจํานวน2รูป (ถ่ายไว้ไม่เกิน6เดือน)',
      );
      return;
    }
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
      "birthDate": DateFormat("yyyyMMdd").format(
        DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
      ),
      "age": txtAge.text,
      "idCard": txtIdCard.text,
      "com_no": txtCom_no.text,
      "isNoCriminal": isNoCriminal,
      "isLawyersConduct": isLawyersConduct,
      "isOther": isOther,
      "lcTypeName": lcTypeName,
      "otherDetail": txtOtherDetail.text,
      "generation": txtGeneration.text,
      "profileCode": profileCode,
      "createBy": user['username'] ?? '',
      "imageUrlCreateBy": user['imageUrl'] ?? '',
      "gallery": _itemImage,
      "paymentAmount": '',
      "paymentDate": '',
      "paymentTime": '',
      "paymentImageUrl": '',
      "paymentType": '',
    };

    // if (isNewAddress == true) {
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

    _modelReport = await postDio(reporterT01ReadApi, {'code': profileCode});
    if (_modelReport.length > 0) {
      data["code"] = _modelReport[0]['code'];

      final result = await postObjectData('m/v2/ReporterT01/update', data);

      if (result['status'] == 'S') {
        setState(() {
          _loading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NsaReportPayForm(
              type: 'reportT01',
              title: 'ชำระค่าบริการ',
            ),
          ),
        );
      }
    } else {
      final result = await postObjectData('m/v2/ReporterT01/create', data);

      if (result['status'] == 'S') {
        setState(() {
          _loading = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NsaReportPayForm(
              type: 'reportT01',
              title: '',
            ),
          ),
        );
      }
    }
    // else {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return WillPopScope(
    //         onWillPop: () {
    //           return Future.value(false);
    //         },
    //         child: CupertinoAlertDialog(
    //           title: new Text(
    //             'บันทึกข้อมูลไม่สำเร็จ',
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
    //                   color: Color(0xFF005C9E),
    //                   fontWeight: FontWeight.normal,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //                 // Navigator.of(context).pop();
    //                 // goBack();
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // }
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
