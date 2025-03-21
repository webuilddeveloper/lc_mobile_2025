import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lc/component/header.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/widget/text_form_field.dart';

class ReporterInfomationFormPage extends StatefulWidget {
  const ReporterInfomationFormPage({
    super.key,
    required this.title,
    required this.code,
    required this.imageUrl,
  });

  final String title;
  final String code;
  final String imageUrl;

  @override
  // ignore: library_private_types_in_public_api
  _ReporterInfomationFormPageState createState() =>
      _ReporterInfomationFormPageState();
}

class _ReporterInfomationFormPageState
    extends State<ReporterInfomationFormPage> {
  final storage = const FlutterSecureStorage();

  late String _imageUrl;
  late String _code;
  List<dynamic> _itemProvince = [];
  late String _selectedProvince;
  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict;
  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict;
  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode;

  List<dynamic> _itemCompanyProvince = [];
  late String _selectedCompanyProvince;
  List<dynamic> _itemCompanyDistrict = [];
  late String _selectedCompanyDistrict;
  List<dynamic> _itemCompanySubDistrict = [];
  late String _selectedCompanySubDistrict;
  List<dynamic> _itemCompanyPostalCode = [];
  late String _selectedCompanyPostalCode;
  bool isNewName = false;
  bool isNewCompanyAddress = false;
  bool isNewAddress = false;
  bool isOther = false;

  final _formKey = GlobalKey<FormState>();

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
  final txtCompanyName = TextEditingController();
  final txtCompanyAddress = TextEditingController();
  final txtCompanyMoo = TextEditingController();
  final txtCompanySoi = TextEditingController();
  final txtCompanyRoad = TextEditingController();
  final txtCompanyPhone = TextEditingController();
  final txtCompanyEmail = TextEditingController();
  final txtother = TextEditingController();
  final txtFullName = TextEditingController();
  final txtComno = TextEditingController();
  final txtNewFullName = TextEditingController();
  final txtNewFullNameEN = TextEditingController();

  final txtTitle = TextEditingController();
  final txtDescription = TextEditingController();
  final txtPrefixNameEN = TextEditingController();
  final txtFirstNameEN = TextEditingController();
  final txtLastNameEN = TextEditingController();
  final txtDocNo = TextEditingController();
  final txtNewFirstName = TextEditingController();
  final txtNewLastName = TextEditingController();
  final txtNewFirstNameEN = TextEditingController();
  final txtNewLastNameEN = TextEditingController();

  double latitude = 13.881074;
  double longitude = 100.598547;

  late String currentLocation;
  bool isShowMap = true;
  int selectedPrefix = 1;
  String prefixName = "นาย";
  int selectedPrefixEN = 1;
  String prefixNameEN = "Mr.";

  final List<dynamic> _itemImage = [];

  dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage2 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage3 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage4 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage5 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage6 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage7 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage8 = {"imageUrl": "", "id": "", "imageType": ""};

  List<Marker> markers = [];
  List<Marker> markerSelect = [];

  addMarker(latLng, newSetState) {
    setState(() {
      latitude = latLng.latitude;
      longitude = latLng.longitude;
    });
    newSetState(() {
      markers.clear();

      markers.add(Marker(markerId: const MarkerId('New'), position: latLng));
    });
  }

  selectMarker() async {
    setState(() {
      markerSelect = markers;
      isShowMap = true;
    });
  }

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = ScrollController();

  late XFile _image;

  final int _selectedDay = 0;
  final int _selectedMonth = 0;
  final int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

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
    txtTitle.dispose();
    txtDate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getLocation();
    getProvince();
    getCompanyProvince();
    futureModel = _getCurrentPosition();

    scrollController = ScrollController();

    super.initState();
  }

  Future<dynamic> _getCurrentPosition() async {
    // var res = await getCurrentPosition();
    // setState(() {
    //   latitude = res.latitude;
    //   longitude = res.longitude;
    //   markers.add(
    //     Marker(
    //       markerId: MarkerId('New'),
    //       position: LatLng(res.latitude, res.longitude),
    //     ),
    //   );
    // });
  }

  void _getLocation() async {
    // Position position = await getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.best,
    // );

    // final coordinates = new Coordinates(position.latitude, position.longitude);

    // var address = await Geocoder.google(
    //   'AIzaSyD-pkE26l2sWEU_CrbDz6b2myMe5Ab7jJo',
    //   language: 'th',
    // ).findAddressesFromCoordinates(coordinates);

    // setState(() {
    //   currentLocation = address.first.adminArea;
    // });
  }

  Future<dynamic> submitReporter() async {
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

    if (itemImage1['ImageUrl'] != "") _itemImage.add(itemImage1);
    if (itemImage2['ImageUrl'] != "") _itemImage.add(itemImage2);
    if (itemImage3['ImageUrl'] != "") _itemImage.add(itemImage3);
    if (itemImage4['ImageUrl'] != "") _itemImage.add(itemImage4);
    if (itemImage5['ImageUrl'] != "") _itemImage.add(itemImage5);
    if (itemImage6['ImageUrl'] != "") _itemImage.add(itemImage6);
    if (itemImage7['ImageUrl'] != "") _itemImage.add(itemImage7);
    if (itemImage8['ImageUrl'] != "") _itemImage.add(itemImage8);

    var data = {
      "prefixName": prefixName,
      "firstName": txtFirstName.text,
      "lastName": txtLastName.text,
      "com_no": txtComno.text,
      "isNewName": isNewName,
      "newFirstName": txtNewFirstName.text,
      "newLastName": txtNewLastName.text,
      "newPrefixNameEN": prefixNameEN,
      "newFirstNameEN": txtNewFirstNameEN.text,
      "newLastNameEN": txtNewLastNameEN.text,
      "docNo": txtDocNo.text,
      "isNewAddress": isNewAddress,
      "address": txtAddress.text,
      "moo": txtMoo.text,
      "soi": txtSoi.text,
      "road": txtRoad.text,
      "tambonCode": _selectedSubDistrict ,
      "tambon": tambon,
      "amphoeCode": _selectedDistrict ,
      "amphoe": amphoe,
      "provinceCode": _selectedProvince ,
      "province": province,
      "postnoCode": _selectedPostalCode ,
      "phone": txtPhone.text,
      "isNewCompanyAddress": isNewCompanyAddress,
      "companyName": txtCompanyName.text,
      "companyAddress": txtCompanyAddress.text,
      "companyMoo": txtCompanyMoo.text,
      "companySoi": txtCompanySoi.text,
      "companyRoad": txtCompanyRoad.text,
      "companyTambonCode": _selectedCompanySubDistrict ,
      "companyTambon": companyTambon,
      "companyAmphoeCode": _selectedCompanyDistrict ,
      "companyAmphoe": companyAmphoe,
      "companyProvinceCode": _selectedCompanyProvince ,
      "companyProvince": companyProvince,
      "companyPostnoCode": _selectedCompanyPostalCode ,
      "companyPhone": txtCompanyPhone.text,
      "companyEmail": txtCompanyEmail.text,
      "isOther": isOther,
      "other": txtother.text,
      "profileCode": profileCode,
      "createBy": user['username'] ,
      "imageUrlCreateBy": user['imageUrl'] ,
      "imageUrl": widget.imageUrl ,
      "gallery": _itemImage,
    };

    // print('--${data.toString()}');

    final result =
        await postObjectData('m/v2/ReporterInformation/create', data);

    if (result['status'] == 'S') {
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
                'บันทึกข้อมูลเรียบร้อยแล้ว',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: const Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF005C9E),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    goBack();
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
              title: const Text(
                'บันทึกข้อมูลไม่สำเร็จ',
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
                      color: Color(0xFF005C9E),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                    // goBack();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  contentCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            const Text(
              'แบบ ทรอ.4',
              style: TextStyle(
                fontSize: 20.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                // color: Color(0xFFBC0611),
              ),
            ),
            labelTextFormField('ข้าพเจ้า'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: 1,
                    groupValue: selectedPrefix,
                    title: const Text("นาย"),
                    onChanged: (value) => setState(
                      (() {
                        selectedPrefix = 1;
                        prefixName = "นาย";
                      }),
                    ),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: 2,
                    groupValue: selectedPrefix,
                    title: const Text("นาง"),
                    onChanged: (value) => setState(
                      (() {
                        selectedPrefix = 2;
                        prefixName = "นาง";
                      }),
                    ),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: 3,
                    groupValue: selectedPrefix,
                    title: const Text("นางสาว"),
                    onChanged: (value) => setState(
                      (() {
                        selectedPrefix = 3;
                        prefixName = "นางสาว";
                      }),
                    ),
                  ),
                ),
              ],
            ),
            labelTextFormField('ชื่อ'),
            textFormField(
              txtFirstName,
              '',
              'กรุณากรอก ชื่อ',
              'กรุณากรอก ชื่อ',
              true,
              false,
              false,
              false,
            ),
            labelTextFormField('นามสกุล'),
            textFormField(
              txtLastName,
              '',
              'กรุณากรอก นามสกุล',
              'กรุณากรอก นามสกุล',
              true,
              false,
              false,
              false,
            ),
            labelTextFormField('ใบอนุญาตทนายความเลขที่'),
            textFormField(
              txtComno,
              '',
              'กรุณากรอกใบอนุญาตทนายความเลขที่',
              'กรุณากรอกใบอนุญาตทนายความเลขที่',
              true,
              false,
              false,
              false,
            ),
            labelTextFormField(
                'ทะเบียนทนายความผู้ทำคำรับรองลายมาชื่อเอกสารเลขที่'),
            textFormField(
              txtDocNo,
              '',
              'เอกสารเลขที่',
              'เอกสารเลขที่',
              true,
              false,
              false,
              false,
            ),
            const SizedBox(height: 10),
            const Text(
              'มีความประสงค์ขอ',
              style: TextStyle(
                fontSize: 20.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                // color: Color(0xFFBC0611),
              ),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              value: isNewName,
              title: const Text("เปลี่ยนชื่อ จากชื่อเดิมเป็น"),
              onChanged: (value) => setState(
                (() {
                  isNewName = value!;
                }),
              ),
            ),
            labelTextFormField('ชื่อ'),
            textFormField(
              txtNewFirstName,
              '',
              'กรุณากรอก ชื่อ',
              'กรุณากรอก ชื่อ',
              isNewName,
              false,
              false,
              false,
            ),
            labelTextFormField('นามสกุล'),
            textFormField(
              txtNewLastName,
              '',
              'กรุณากรอก นามสกุล',
              'กรุณากรอก นามสกุล',
              isNewName,
              false,
              false,
              false,
            ),
            labelTextFormField('นามสกุล ภาษาอังกฤษ'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: 1,
                    groupValue: selectedPrefixEN,
                    title: const Text("Mr."),
                    onChanged: (value) => isNewName
                        ? setState(
                            (() {
                              selectedPrefixEN = 1;
                              prefixNameEN = "Mr.";
                            }),
                          )
                        : null,
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: 2,
                    groupValue: selectedPrefixEN,
                    title: const Text("Mrs."),
                    onChanged: (value) => isNewName
                        ? setState(
                            (() {
                              selectedPrefixEN = 2;
                              prefixNameEN = "Mrs.";
                            }),
                          )
                        : null,
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.all(0),
                    value: 3,
                    groupValue: selectedPrefixEN,
                    title: const Text("Miss"),
                    onChanged: (value) => isNewName
                        ? setState(
                            (() {
                              selectedPrefixEN = 3;
                              prefixNameEN = "Miss";
                            }),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            labelTextFormField('ชื่อ ภาษาอังกฤษ'),
            textFormField(
              txtNewFirstNameEN,
              '',
              'กรุณากรอก ชื่อ ภาษาอังกฤษ',
              'กรุณากรอก ชื่อ ภาษาอังกฤษ',
              isNewName,
              false,
              false,
              false,
            ),
            labelTextFormField('นามสกุล ภาษาอังกฤษ'),
            textFormField(
              txtNewLastNameEN,
              '',
              'กรุณากรอก นามสกุล ภาษาอังกฤษ',
              'กรุณากรอก นามสกุล ภาษาอังกฤษ',
              isNewName,
              false,
              false,
              false,
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              value: isNewAddress,
              title: const Text("เปลี่ยนที่อยู่ตามทะเบียนบ้านเป็น"),
              onChanged: (value) => setState(
                (() {
                  isNewAddress = value!;
                  getProvince();
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('เลขที่ และ หมู่ที่'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 83,
                            child: textFormField(
                              txtAddress,
                              '',
                              'เลขที่',
                              'เลขที่',
                              isNewAddress,
                              false,
                              false,
                              false,
                            ),
                          ),
                          // SizedBox(width: 5),
                          SizedBox(
                            width: 83,
                            child: textFormField(
                              txtMoo,
                              '',
                              'หมู่ที่',
                              'หมู่ที่',
                              isNewAddress,
                              false,
                              false,
                              false,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('ตรอก / ซอย'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtSoi,
                          '',
                          'ตรอก / ซอย',
                          'ตรอก / ซอย',
                          isNewAddress,
                          false,
                          false,
                          false,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('ถนน'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
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
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('จังหวัด'),
                      Container(
                        width: 5000.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isNewAddress
                              ? const Color(0xFFEEEEEE)
                              : const Color(0xFFCCBEBE),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: (_selectedProvince != '')
                            ? DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'จังหวัด'
                                        : null,
                                hint: const Text(
                                  'จังหวัด',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                value: _selectedProvince,
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
                                        color: Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'จังหวัด'
                                        : null,
                                hint: const Text(
                                  'จังหวัด',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedDistrict = "";
                                    _itemDistrict = [];
                                    _selectedSubDistrict = "";
                                    _itemSubDistrict = [];
                                    _selectedPostalCode = "";
                                    _itemPostalCode = [];
                                    _selectedProvince = newValue as String;
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
                                        color: Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('เขต / อำเภอ'),
                      Container(
                        width: 5000.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isNewAddress
                              ? const Color(0xFFEEEEEE)
                              : const Color(0xFFCCBEBE),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: (_selectedDistrict != '')
                            ? DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'อำเภอ'
                                        : null,
                                hint: const Text(
                                  'อำเภอ',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                value: _selectedDistrict,
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
                                    getSubDistrict();
                                  });
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
                              )
                            : DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'อำเภอ'
                                        : null,
                                hint: const Text(
                                  'อำเภอ',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedSubDistrict = "";
                                    _itemSubDistrict = [];
                                    _selectedPostalCode = "";
                                    _itemPostalCode = [];
                                    _selectedDistrict = newValue as String;
                                    getSubDistrict();
                                  });
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
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('แขวง / ตำบล'),
                      Container(
                        width: 5000.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isNewAddress
                              ? const Color(0xFFEEEEEE)
                              : const Color(0xFFCCBEBE),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: (_selectedSubDistrict != '')
                            ? DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'ตำบล'
                                        : null,
                                hint: const Text(
                                  'ตำบล',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                value: _selectedSubDistrict,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  TextEditingController().clear();
                                },
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedPostalCode = "";
                                    _itemPostalCode = [];
                                    _selectedSubDistrict = newValue as String;
                                    getPostalCode();
                                  });
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
                              )
                            : DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'ตำบล'
                                        : null,
                                hint: const Text(
                                  'ตำบล',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedPostalCode = "";
                                    _itemPostalCode = [];
                                    _selectedSubDistrict = newValue as String;
                                    getPostalCode();
                                  });
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
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('รหัสไปรษณีย์'),
                      Container(
                        width: 5000.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isNewAddress
                              ? const Color(0xFFEEEEEE)
                              : const Color(0xFFCCBEBE),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: (_selectedPostalCode != '')
                            ? DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'รหัสไปรษณีย์'
                                        : null,
                                hint: const Text(
                                  'รหัสไปรษณีย์',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                value: _selectedPostalCode,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  TextEditingController().clear();
                                },
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedPostalCode = newValue as String;
                                  });
                                },
                                items: _itemPostalCode.map((item) {
                                  return DropdownMenuItem(
                                    value: item['code'],
                                    child: Text(
                                      item['postCode'],
                                      style: const TextStyle(
                                        fontSize: 14.00,
                                        fontFamily: 'Kanit',
                                        color: Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'รหัสไปรษณีย์'
                                        : null,
                                hint: const Text(
                                  'รหัสไปรษณีย์',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedPostalCode = newValue as String;
                                  });
                                },
                                items: _itemPostalCode.map((item) {
                                  return DropdownMenuItem(
                                    value: item['code'],
                                    child: Text(
                                      item['postCode'],
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
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('โทร'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtPhone,
                          '',
                          '0__-___-____',
                          '0__-___-____',
                          isNewAddress,
                          false,
                          false,
                          false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              value: isNewCompanyAddress,
              title: const Text("เปลี่ยนที่อยู่ตามทะเบียนบ้านเป็น"),
              onChanged: (value) => setState(
                (() {
                  isNewCompanyAddress = value!;
                  getCompanyProvince();
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('เลขที่ และ หมู่ที่'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 83,
                            child: textFormField(
                              txtCompanyAddress,
                              '',
                              'เลขที่',
                              'เลขที่',
                              isNewCompanyAddress,
                              false,
                              false,
                              false,
                            ),
                          ),
                          // SizedBox(width: 5),
                          SizedBox(
                            width: 83,
                            child: textFormField(
                              txtCompanyMoo,
                              '',
                              'หมู่ที่',
                              'หมู่ที่',
                              isNewCompanyAddress,
                              false,
                              false,
                              false,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('ตรอก / ซอย'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtCompanySoi,
                          '',
                          'ตรอก / ซอย',
                          'ตรอก / ซอย',
                          isNewCompanyAddress,
                          false,
                          false,
                          false,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('ถนน'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtCompanyRoad,
                          '',
                          'ถนน',
                          'ถนน',
                          isNewCompanyAddress,
                          false,
                          false,
                          false,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('จังหวัด'),
                      Container(
                        width: 5000.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isNewCompanyAddress
                              ? const Color(0xFFEEEEEE)
                              : const Color(0xFFCCBEBE),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: (_selectedCompanyProvince != '')
                            ? DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'จังหวัด'
                                        : null,
                                hint: const Text(
                                  'จังหวัด',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
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
                                    _selectedCompanyProvince =
                                        newValue as String;
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
                              )
                            : DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'จังหวัด'
                                        : null,
                                hint: const Text(
                                  'จังหวัด',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCompanyDistrict = "";
                                    _itemCompanyDistrict = [];
                                    _selectedCompanySubDistrict = "";
                                    _itemCompanySubDistrict = [];
                                    _selectedCompanyPostalCode = "";
                                    _itemCompanyPostalCode = [];
                                    _selectedCompanyProvince =
                                        newValue as String;
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
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('เขต / อำเภอ'),
                      Container(
                        width: 5000.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isNewCompanyAddress
                              ? const Color(0xFFEEEEEE)
                              : const Color(0xFFCCBEBE),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: (_selectedCompanyDistrict != '')
                            ? DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'อำเภอ'
                                        : null,
                                hint: const Text(
                                  'อำเภอ',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                value: _selectedCompanyDistrict,
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
                                    _selectedCompanyDistrict =
                                        newValue as String;
                                    getCompanySubDistrict();
                                  });
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
                              )
                            : DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'อำเภอ'
                                        : null,
                                hint: const Text(
                                  'อำเภอ',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCompanySubDistrict = "";
                                    _itemCompanySubDistrict = [];
                                    _selectedCompanyPostalCode = "";
                                    _itemCompanyPostalCode = [];
                                    _selectedCompanyDistrict =
                                        newValue as String;
                                    getCompanySubDistrict();
                                  });
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
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('แขวง / ตำบล'),
                      Container(
                        width: 5000.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isNewCompanyAddress
                              ? const Color(0xFFEEEEEE)
                              : const Color(0xFFCCBEBE),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: (_selectedCompanySubDistrict != '')
                            ? DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'ตำบล'
                                        : null,
                                hint: const Text(
                                  'ตำบล',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                value: _selectedCompanySubDistrict,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  TextEditingController().clear();
                                },
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCompanyPostalCode = "";
                                    _itemCompanyPostalCode = [];
                                    _selectedCompanySubDistrict =
                                        newValue as String;
                                    getCompanyPostalCode();
                                  });
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
                              )
                            : DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'ตำบล'
                                        : null,
                                hint: const Text(
                                  'ตำบล',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCompanyPostalCode = "";
                                    _itemCompanyPostalCode = [];
                                    _selectedCompanySubDistrict =
                                        newValue as String;
                                    getCompanyPostalCode();
                                  });
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
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('รหัสไปรษณีย์'),
                      Container(
                        width: 5000.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: isNewCompanyAddress
                              ? const Color(0xFFEEEEEE)
                              : const Color(0xFFCCBEBE),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: (_selectedCompanyPostalCode != '')
                            ? DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'รหัสไปรษณีย์'
                                        : null,
                                hint: const Text(
                                  'รหัสไปรษณีย์',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                value: _selectedCompanyPostalCode,
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  TextEditingController().clear();
                                },
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCompanyPostalCode =
                                        newValue as String;
                                  });
                                },
                                items: _itemCompanyPostalCode.map((item) {
                                  return DropdownMenuItem(
                                    value: item['code'],
                                    child: Text(
                                      item['postCode'],
                                      style: const TextStyle(
                                        fontSize: 14.00,
                                        fontFamily: 'Kanit',
                                        color: Color(0xFF4A4A4A),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            : DropdownButtonFormField(
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
                                    value == '' || value == null
                                        ? 'รหัสไปรษณีย์'
                                        : null,
                                hint: const Text(
                                  'รหัสไปรษณีย์',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedCompanyPostalCode =
                                        newValue as String;
                                  });
                                },
                                items: _itemCompanyPostalCode.map((item) {
                                  return DropdownMenuItem(
                                    value: item['code'],
                                    child: Text(
                                      item['postCode'],
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
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('โทร'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtCompanyPhone,
                          '',
                          '0__-___-____',
                          '0__-___-____',
                          isNewCompanyAddress,
                          false,
                          false,
                          false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.all(0),
              value: isOther,
              title: const Text("อื่นๆ"),
              onChanged: (value) => setState(
                (() {
                  isOther = value!;
                }),
              ),
            ),
            textFormField(
              txtother,
              '',
              'อื่นๆ',
              'อื่นๆ',
              isOther,
              false,
              false,
              false,
            ),
            const SizedBox(height: 10),
            const Text(
              'พร้อมกันนี้ ข้าพเจ้าได้แนบหลักฐานต่างๆมาด้วยคือ',
              style: TextStyle(
                fontSize: 18.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                // color: Color(0xFFBC0611),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage1['imageUrl'] != "" &&
                              itemImage1['imageUrl'] != null

                          // _itemImage.any((element) => element['type'] == "1")
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage1['id'].toString(), "1");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage1['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
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
                      const SizedBox(height: 10),
                      const Text(
                        'ใบสำคัญการขึ้นทะเบียน',
                        style: TextStyle(
                          fontSize: 14.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage2['imageUrl'] != "" &&
                              itemImage2['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage2['id'].toString(), "2");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage2['imageUrl'],
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
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
                      const SizedBox(height: 10),
                      const Text(
                        'สำเนาใบเปลี่ยนชื่อ/นามสกุล',
                        style: TextStyle(
                          fontSize: 14.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
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
                              height: 120,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage3['id'].toString(), "3");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage3['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
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
                      const SizedBox(height: 10),
                      const Text(
                        'สำเนาทะเบียนบ้าน',
                        style: TextStyle(
                          fontSize: 14.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage4['imageUrl'] != "" &&
                              itemImage4['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage4['id'].toString(), "4");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage4['imageUrl'],
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
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
                      const SizedBox(height: 10),
                      const Text(
                        'ใบแจ้งความจากเจ้าพนักงาน',
                        style: TextStyle(
                          fontSize: 14.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage5['imageUrl'] != "" &&
                              itemImage5['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage5['id'].toString(), "5");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage5['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
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
                      const SizedBox(height: 10),
                      const Text(
                        'ครุยเนติบัณฑิต 2 นิ้ว รูปที่ 1',
                        style: TextStyle(
                          fontSize: 14.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage6['imageUrl'] != "" &&
                              itemImage6['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage6['id'].toString(), "6");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage6['imageUrl'],
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  _showPickerImage(context, '6');
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
                      const SizedBox(height: 10),
                      const Text(
                        'ครุยเนติบัณฑิค 2 นิ้ว รูปที่ 2',
                        style: TextStyle(
                          fontSize: 14.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage7['imageUrl'] != "" &&
                              itemImage7['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage7['id'].toString(), "7");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage7['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  _showPickerImage(context, '7');
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
                      const SizedBox(height: 10),
                      const Text(
                        'อื่นๆ',
                        style: TextStyle(
                          fontSize: 14.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      itemImage8['imageUrl'] != "" &&
                              itemImage8['imageUrl'] != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage8['id'].toString(), "8");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage8['imageUrl'],
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  height: 120,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  _showPickerImage(context, '8');
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
                      const SizedBox(height: 10),
                      const Text(
                        'ตัวอย่างลายมือชื่อ',
                        style: TextStyle(
                          fontSize: 14.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: const Color(0XFF011895),
                  child: MaterialButton(
                    height: 40,
                    onPressed: () {
                      submitReporter();

                      // final form = _formKey.currentState;
                      // if (form.validate()) {
                      //   form.save();
                      //   submitReporter();
                      // }
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
          ],
        ),
      ),
    );
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
      // _itemImage.removeWhere((c) => c['id'].toString() == code.toString());
      if (type == "1") {
        itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "2") {
        itemImage2 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "3") {
        itemImage3 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "4") {
        itemImage4 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "5") {
        itemImage5 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "6") {
        itemImage6 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "7") {
        itemImage7 = {"imageUrl": "", "id": "", "imageType": ""};
      }
      if (type == "8") {
        itemImage8 = {"imageUrl": "", "id": "", "imageType": ""};
      }
    });
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
    // ignore: no_leading_underscores_for_local_identifiers
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
          itemImage1 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type
          };
        }
        if (type == "2") {
          itemImage2 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
          };
        }
        if (type == "3") {
          itemImage3 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
          };
        }
        if (type == "4") {
          itemImage4 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
          };
        }
        if (type == "5") {
          itemImage5 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
          };
        }
        if (type == "6") {
          itemImage6 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
          };
        }
        if (type == "7") {
          itemImage7 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
          };
        }
        if (type == "8") {
          itemImage8 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type,
          };
        }
        // _itemImage.add(itemImage1);
        // _itemImage2 = _itemImage.where((i) => i['imageType'] == "2").toList();
        // _itemImage3 = _itemImage.where((i) => i['imageType'] == "3").toList();
        // _itemImage4 = _itemImage.where((i) => i['imageType'] == "4").toList();
        // _itemImage5 = _itemImage.where((i) => i['imageType'] == "5").toList();
        // _itemImage6 = _itemImage.where((i) => i['imageType'] == "6").toList();
      });
      // setState(() {
      //   _imageUrl = res;
      // });
    }).catchError((err) {
      print(err);
    });
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
        _itemCompanyProvince =
            isNewCompanyAddress == true ? result['objectData'] : [];
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

  void _showPickerImage(context, String type) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
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

  void goBack() async {
    Navigator.pop(context);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => ReporterListCategory(),
    //   ),
    // );
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
        backgroundColor: Colors.white,
        appBar: header(context, goBack, title: widget.title),
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
      ),
    );
  }
}
