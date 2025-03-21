import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lc/component/header.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/widget/text_form_field.dart';

class ReporterRenewFormPage extends StatefulWidget {
  const ReporterRenewFormPage({
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
  _ReporterRenewFormPageState createState() => _ReporterRenewFormPageState();
}

class _ReporterRenewFormPageState extends State<ReporterRenewFormPage> {
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
  bool isCertifyStatus = false;
  bool isCertifyPunish = false;
  bool isAgree = false;
  bool isEvidence = false;
  bool isChkmodel = false;
  int selectedNewAddress = 1;
  late String profileCode;
  dynamic _model;
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
  final txtCompanyBuilding = TextEditingController();
  final txtCompanyAddress = TextEditingController();
  final txtCompanyMoo = TextEditingController();
  final txtCompanySoi = TextEditingController();
  final txtCompanyRoad = TextEditingController();
  final txtCompanyPhone = TextEditingController();
  final txtCompanyEmail = TextEditingController();
  final txtCompanyFax = TextEditingController();
  final txtother = TextEditingController();
  final txtFullName = TextEditingController();
  final txtComno = TextEditingController();
  final txtNewFullName = TextEditingController();
  final txtNewFullNameEN = TextEditingController();
  final txtFax = TextEditingController();
  final txtNewEmail = TextEditingController();
  final txtTitle = TextEditingController();
  final txtDescription = TextEditingController();
  final txtPrefixNameEN = TextEditingController();
  final txtFirstNameEN = TextEditingController();
  final txtLastNameEN = TextEditingController();
  final txtFullNameEN = TextEditingController();
  final txtNewFirstName = TextEditingController();
  final txtNewLastName = TextEditingController();
  final txtNewFirstNameEN = TextEditingController();
  final txtNewLastNameEN = TextEditingController();
  final txtDocNo = TextEditingController();
  double latitude = 13.743894;
  double longitude = 100.538592;

  late String currentLocation;
  bool isShowMap = true;
  int selectedPrefix = 1;
  String prefixName = "นาย";
  int selectedPrefixEN = 1;
  String prefixNameEN = "Mr.";
  int selectedMemberType = 1;
  bool isMemterType = false;

  int selectedNewPrefix = 1;
  String newPrefixName = "นาย";
  int selectedNewPrefixEN = 1;
  String newPrefixNameEN = "Mr.";
  List<dynamic> _itemImage = [];
  List<dynamic> _itemImage2 = [];
  late Future<dynamic> _futureProfile;
  dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage2 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage3 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage4 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage5 = {"imageUrl": "", "id": "", "imageType": ""};

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
  TextEditingController txtExpDate = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = ScrollController();

  late XFile _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int _selectedExpDay = 0;
  int _selectedExpMonth = 0;
  int _selectedExpYear = 0;
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
    // txtDate.dispose();
    txtTitle.dispose();
    super.dispose();
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
      _selectedExpYear = now.year;
      _selectedExpMonth = now.month;
      _selectedExpDay = now.day;
    });
    _callRead();
    _getLocation();
    getProvince();
    getCompanyProvince();
    futureModel = _getCurrentPosition();

    scrollController = ScrollController();

    super.initState();
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    _futureProfile = postDio(reporterT02ReadApi, {'code': profileCode});
    _model = await _futureProfile;
    if (_model.length > 0) {
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

  dialogOpenPickerDate2(BuildContext context) {
    dt_picker.DatePicker.showDatePicker(
      context,
      theme: const dt_picker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: const TextStyle(
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
      maxTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      onConfirm: (date) {
        // ใช้ setState ต้องอยู่ใน StatefulWidget เท่านั้น
        print("Selected Date: ${DateFormat("dd-MM-yyyy").format(date)}");
      },
      currentTime: DateTime.now(),
      locale: dt_picker.LocaleType.th,
    );
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

    if (itemImage1['ImageUrl'] != "") _itemImage.add(itemImage1);
    if (_itemImage2.length > 0) {
      _itemImage2.forEach((c) {
        _itemImage.add(c);
      });
    }
    if (itemImage3['ImageUrl'] != "") _itemImage.add(itemImage3);
    if (itemImage4['ImageUrl'] != "") _itemImage.add(itemImage4);
    if (itemImage5['ImageUrl'] != "") _itemImage.add(itemImage5);

    var data = {
      "prefixName": prefixName,
      "firstName": txtFirstName.text,
      "lastName": txtLastName.text,
      "prefixNameEN": prefixNameEN,
      "firstNameEN": txtFirstNameEN.text,
      "lastNameEN": txtLastNameEN.text,
      "isMemberType": isMemterType,
      "com_no": txtComno.text,
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
      "imageUrl": widget.imageUrl,
      "gallery": _itemImage,
    };

    if (isNewAddress == true) {
      data["newPrefixName"] = newPrefixName;
      data["newFirstName"] = txtNewFirstName.text;
      data["newLastName"] = txtNewLastName.text;
      data["newPrefixNameEN"] = newPrefixNameEN;
      data["newFirstNameEN"] = txtNewFirstNameEN.text;
      data["newLastNameEN"] = txtNewLastNameEN.text;
      data["address"] = txtAddress.text;
      data["moo"] = txtMoo.text;
      data["soi"] = txtSoi.text;
      data["road"] = txtRoad.text;
      data["tambonCode"] = _selectedSubDistrict;
      data["tambon"] = tambon;
      data["amphoeCode"] = _selectedDistrict ?? '';
      data["amphoe"] = amphoe;
      data["provinceCode"] = _selectedProvince ?? '';
      data["province"] = province;
      data["postnoCode"] = _selectedPostalCode ?? '';
      data["phone"] = txtPhone.text;
      data["fax"] = txtFax.text;
      data["email"] = txtEmail.text;
      data["companyName"] = txtCompanyName.text;
      data["companyAddress"] = txtCompanyAddress.text;
      data["companyMoo"] = txtCompanyMoo.text;
      data["companyBuilding"] = txtCompanyBuilding.text;
      data["companySoi"] = txtCompanySoi.text;
      data["companyRoad"] = txtCompanyRoad.text;
      data["companyTambonCode"] = _selectedCompanySubDistrict ?? '';
      data["companyTambon"] = companyTambon;
      data["companyAmphoeCode"] = _selectedCompanyDistrict ?? '';
      data["companyAmphoe"] = companyAmphoe;
      data["companyProvinceCode"] = _selectedCompanyProvince ?? '';
      data["companyProvince"] = companyProvince;
      data["companyPostnoCode"] = _selectedCompanyPostalCode ?? '';
      data["companyPhone"] = txtCompanyPhone.text;
      data["companyFax"] = txtCompanyFax.text;
      data["companyEmail"] = txtCompanyEmail.text;
    } else {
      data["address"] = _model[0]["address"];
      data["moo"] = _model[0]["moo"];
      data["soi"] = _model[0]["soi"];
      data["road"] = _model[0]["road"];
      data["tambonCode"] = _model[0]["tambonCode"];
      data["tambon"] = _model[0]["tambon"];
      data["amphoeCode"] = _model[0]["amphoeCode"];
      data["amphoe"] = _model[0]["amphoe"];
      data["provinceCode"] = _model[0]["provinceCode"];
      data["province"] = _model[0]["province"];
      data["postnoCode"] = _model[0]["postnoCode"];
      data["phone"] = _model[0]["phone"];
      data["fax"] = _model[0]["fax"];
      data["email"] = _model[0]["email"];
      data["companyName"] = _model[0]["companyName"];
      data["companyAddress"] = _model[0]["companyAddress"];
      data["companyMoo"] = _model[0]["companyMoo"];
      data["companyBuilding"] = _model[0]["companyBuilding"];
      data["companySoi"] = _model[0]["companySoi"];
      data["companyRoad"] = _model[0]["companyRoad"];
      data["companyTambonCode"] = _model[0]["companyTambonCode"];
      data["companyTambon"] = _model[0]["companyTambon"];
      data["companyAmphoeCode"] = _model[0]["companyAmphoeCode"];
      data["companyAmphoe"] = _model[0]["companyAmphoe"];
      data["companyProvinceCode"] = _model[0]["companyProvinceCode"];
      data["companyProvince"] = _model[0]["companyProvince"];
      data["companyPostnoCode"] = _model[0]["companyPostnoCode"];
      data["companyPhone"] = _model[0]["companyPhone"];
      data["companyFax"] = _model[0]["companyFax"];
      data["companyEmail"] = _model[0]["companyEmail"];
    }

    // print('--${json.encode(data)}');
    final result = await postObjectData('m/v2/ReporterRenew/create', data);

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
              'แบบ ทรอ.2',
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
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
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
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
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
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 1,
                      groupValue: selectedPrefixEN,
                      title: const Text("Mr."),
                      onChanged: (value) => setState(
                        (() {
                          selectedPrefixEN = 1;
                          prefixNameEN = "Mr.";
                        }),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 2,
                      groupValue: selectedPrefixEN,
                      title: const Text("Mrs."),
                      onChanged: (value) => setState(
                        (() {
                          selectedPrefixEN = 2;
                          prefixNameEN = "Mrs.";
                        }),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 3,
                      groupValue: selectedPrefixEN,
                      title: const Text("Miss"),
                      onChanged: (value) => setState(
                        (() {
                          selectedPrefixEN = 3;
                          prefixNameEN = "Miss";
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            labelTextFormField('ชื่อ ภาษาอังกฤษ'),
            textFormField(
              txtFirstNameEN,
              '',
              'กรุณากรอก ชื่อ ภาษาอังกฤษ',
              'กรุณากรอก ชื่อ ภาษาอังกฤษ',
              true,
              false,
              false,
              false,
            ),
            labelTextFormField('นามสกุล ภาษาอังกฤษ'),
            textFormField(
              txtLastNameEN,
              '',
              'กรุณากรอก นามสกุล ภาษาอังกฤษ',
              'กรุณากรอก นามสกุล ภาษาอังกฤษ',
              true,
              false,
              false,
              false,
            ),
            labelTextFormField('ประเภทสมาชิก'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 1,
                      groupValue: selectedMemberType,
                      title: const Text("ตลอดชีพ"),
                      onChanged: (value) => setState(
                        (() {
                          selectedMemberType = 1;
                          isMemterType = false;
                        }),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 2,
                      groupValue: selectedMemberType,
                      title: const Text("2 ปี"),
                      onChanged: (value) => setState(
                        (() {
                          selectedMemberType = 2;
                          isMemterType = true;
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
            labelTextFormField('หมดอายุวันที่'),
            labelTextFormField('เฉพาะสมาชิกประเภท 2 ปี'),
            GestureDetector(
              onTap: () => dialogOpenPickerDate(),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: txtDate,
                  style: TextStyle(
                    color: isMemterType
                        ? const Color(0xFF4A4A4A)
                        : const Color(0xFF4A4A4A).withOpacity(0.5),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isMemterType
                        ? const Color(0xFFEEEEEE)
                        : const Color(0xFFCCBEBE),
                    contentPadding:
                        const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    hintText: "วัน / เดือน / ปี",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    errorStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 10.0,
                    ),
                  ),
                  enabled: isMemterType,
                  validator: (model) {
                    if (model!.isEmpty) {
                      return 'กรุณากรอกวันที่หมดอายุ';
                    }
                  },
                ),
              ),
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
            labelTextFormField('เอกสารจะหมดอายุลงวันที่'),
            GestureDetector(
              onTap: () => dialogOpenPickerDate2(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: txtExpDate,
                  style: const TextStyle(
                    color: Color(0xFF4A4A4A),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFEEEEEE),
                    contentPadding:
                        const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    hintText: "วัน / เดือน / ปี",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    errorStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 10.0,
                    ),
                  ),
                  // enabled: isMemterType,
                  validator: (model) {
                    if (model!.isEmpty) {
                      return 'กรุณากรอกวันที่หมดอายุ';
                    }
                  },
                ),
              ),
            ),
            labelTextFormField(
                'ข้าพเจ้ามีความประสงค์จะขอต่ออายุทะเบียนทนายความผู้ทำคำรับรองลายมื่อชื่อและเอกสารของข้าพเจ้าออกไปมีกำหนดอีก 2 ปี'),
            labelTextFormField('ข้าพเจ้าขอรับร้องว่าขณะยื่นคำขอนี้'),
            Column(
              children: [
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.blue),
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
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.blue),
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
              ],
            ),
            labelTextFormField('ในการนี้ข้าพเจ้ามีความประสงค์ดังนี้'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.blue),
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
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.blue),
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
              ],
            ),
            labelTextFormField('เปลี่ยนชื่อ นามสกุลใหม่ เป็นดังนี้'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 1,
                      groupValue: selectedNewPrefix,
                      title: const Text("นาย"),
                      onChanged: (value) => isNewAddress
                          ? setState(
                              (() {
                                selectedNewPrefix = 1;
                                newPrefixName = "นาย";
                              }),
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 2,
                      groupValue: selectedNewPrefix,
                      title: const Text("นาง"),
                      onChanged: (value) => isNewAddress
                          ? setState(
                              (() {
                                selectedNewPrefix = 2;
                                newPrefixName = "นาง";
                              }),
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 3,
                      groupValue: selectedNewPrefix,
                      title: const Text("นางสาว"),
                      onChanged: (value) => isNewAddress
                          ? setState(
                              (() {
                                selectedNewPrefix = 3;
                                newPrefixName = "นางสาว";
                              }),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
            labelTextFormField('ชื่อ'),
            textFormField(
              txtNewFirstName,
              '',
              'กรุณากรอก ชื่อ',
              'กรุณากรอก ชื่อ',
              isNewAddress,
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
              isNewAddress,
              false,
              false,
              false,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 1,
                      groupValue: selectedNewPrefixEN,
                      title: const Text("Mr."),
                      onChanged: (value) => isNewAddress
                          ? setState(
                              (() {
                                selectedNewPrefixEN = 1;
                                newPrefixNameEN = "Mr.";
                              }),
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 2,
                      groupValue: selectedNewPrefixEN,
                      title: const Text("Mrs."),
                      onChanged: (value) => isNewAddress
                          ? setState(
                              (() {
                                selectedNewPrefixEN = 2;
                                newPrefixNameEN = "Mrs.";
                              }),
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.blue),
                    child: RadioListTile(
                      contentPadding: const EdgeInsets.all(0),
                      value: 3,
                      groupValue: selectedNewPrefixEN,
                      title: const Text("Miss"),
                      onChanged: (value) => isNewAddress
                          ? setState(
                              (() {
                                selectedNewPrefixEN = 3;
                                newPrefixNameEN = "Miss";
                              }),
                            )
                          : null,
                    ),
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
              isNewAddress,
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
              isNewAddress,
              false,
              false,
              false,
            ),
            const SizedBox(height: 10),
            labelTextFormField('เปลี่ยนแปลงข้อมูลที่อยู่ปัจจุบัน เป็นดังนี้'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('เลขโทรสาร'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtFax,
                          '',
                          'เลขโทรสาร',
                          'เลขโทรสาร',
                          isNewAddress,
                          false,
                          false,
                          false,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('E-mail'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtEmail,
                          '',
                          'E-mail',
                          'E-mail',
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
            const SizedBox(height: 10),
            labelTextFormField(
                'เปลี่ยนแปลงข้อมูลสำนักงาน/บริษัทใหม่ เป็นดังนี้'),
            const SizedBox(height: 10),
            textFormField(
              txtCompanyName,
              '',
              'กรุณากรอก ชื่อสำนักงาน / บริษัท',
              'กรุณากรอก ชื่อสำนักงาน / บริษัท',
              isNewAddress,
              false,
              false,
              false,
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
                              txtCompanyMoo,
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
                      labelTextFormField('อาคาร'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtCompanyBuilding,
                          '',
                          'อาคาร',
                          'อาคาร',
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
                          isNewAddress,
                          false,
                          false,
                          false,
                        ),
                      )
                    ],
                  ),
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      labelTextFormField('โทร'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtCompanyPhone,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('โทรสาร'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtCompanyFax,
                          '',
                          'โทรสาร',
                          'โทรสาร',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelTextFormField('E-mail'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: textFormField(
                          txtCompanyEmail,
                          '',
                          'E-mail',
                          'E-mail',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.blue),
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
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.blue),
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
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'เอกสารประกอบคำขอ',
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
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage1['id'].toString(), "1");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage1['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
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
                    'สำเนาหนังสือรับรองการเป็นทนายความผู้ทำคำรับรองฯ',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _itemImage2.length > 0
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
                                child: Image.network(
                                  _itemImage2[0]['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
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
                                      child: Image.network(
                                        _itemImage2[1]['imageUrl'],
                                        width:
                                            MediaQuery.of(context).size.width,
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
                    'รูปถ่ายสีสวมชุดครุยเนติบัณฑิตขนาด 2 รูป จำนวน 2 รูป',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
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
                          // _itemImage.any((element) => element['type'] == "1")
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage3['id'].toString(), "3");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage3['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
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
                    'สำเนาบัตรประจำตัวสมาชิกสภาทนายความ',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
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
                      itemImage4['imageUrl'] != "" &&
                              itemImage4['imageUrl'] != null
                          // _itemImage.any((element) => element['type'] == "1")
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage4['id'].toString(), "4");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage4['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
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
                    'หลักฐานการเปลี่ยนแปลงข้อมูลฯ เช่น เปลี่ยนชื่อตัว-นามสกุล',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
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
                      itemImage5['imageUrl'] != "" &&
                              itemImage5['imageUrl'] != null
                          // _itemImage.any((element) => element['type'] == "1")
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width / 2.2,
                              height: 100,
                              child: MaterialButton(
                                onPressed: () {
                                  dialogDeleteImage(
                                      itemImage5['id'].toString(), "5");
                                },
                                padding: const EdgeInsets.all(0),
                                child: Image.network(
                                  itemImage5['imageUrl'],
                                  width: MediaQuery.of(context).size.width,
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
                    'ตัวอย่างลายมือชื่อ ผู้ยื่นคำขอ',
                    style: TextStyle(
                      fontSize: 14.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
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
      if (type == "") {
        _itemImage2.removeWhere((c) => c['id'].toString() == code.toString());
      }
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
    });
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
          itemImage1 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageType': type
          };
        }
        if (type == "2") {
          if (_itemImage2.length < 2) {
            _itemImage2.add({
              'imageUrl': res,
              'id': random.nextInt(100),
              'imageType': type
            });
          }
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
        _itemCompanyProvince = isNewAddress == true ? result['objectData'] : [];
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
