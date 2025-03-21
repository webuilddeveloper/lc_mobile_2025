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

class NsaReportCertifyPage extends StatefulWidget {
  const NsaReportCertifyPage({
    super.key,
    this.model,
  });

  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _NsaReportCertifyPageState createState() => _NsaReportCertifyPageState();
}

class _NsaReportCertifyPageState extends State<NsaReportCertifyPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  bool _hasErrorPrefix = false;

  final List<dynamic> _itemPrefix = [
    {'code': '1', 'title': 'นาย'},
    {'code': '2', 'title': 'นางสาว'},
    {'code': '3', 'title': 'นาง'}
  ];

  String? _selectedPrefix;
  dynamic _modelReport = {};

  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtCom_no = TextEditingController();
  final txtDoc_no = TextEditingController();
  final txtDoc_total = TextEditingController();
  final txtRemark = TextEditingController();

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

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerNSA(context,
          callback: goBack,
          title: 'แบบคําขอให้รับรองสําเนาถูกต้อง',
          contentRight: Container()),
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
              'ของหนังสือรับรองการเป็นทนายความผู้',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const Center(
            child: Text(
              'ทําคํารับรองลายมือชื่อและเอกสาร',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: Color(0xFF707070),
              ),
            ),
          ),
          const Center(
            child: Text(
              'สภาทนายความในพระบรมราชูปถัมภ์',
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
            child: textFormFieldNSA(
              txtDoc_no,
              '',
              'เอกสารเลขที่',
              'เอกสารเลขที่',
              'เอกสารเลขที่',
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
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Text(
                'มีความประสงค์ขอให้ท่านรับรองสําเนาถูกต้องของหนังสือรับรองๆให้กับข้าพเจ้า จำนวน (ฉบับ)',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF758C29)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: textFormFieldNSAPay(
              txtDoc_total,
              '',
              'จำนวน (ฉบับ)',
              'จำนวน (ฉบับ)',
              'จำนวน (ฉบับ)',
              true,
              false,
              false,
              isPattern: true,
              textInputType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: textFormFieldNSA(
              txtRemark,
              '',
              'รายละเอียดการนำไปใช้',
              'รายละเอียดการนำไปใช้',
              'รายละเอียดการนำไปใช้',
              true,
              false,
              false,
              false,
            ),
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
                    'สําเนาหนังสือรับรองการเป็นทนายความผู้ทําคํารับรองลายมือชื่อฯ',
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
                                  // _imageFromFiile('2');
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
                    'สำเนาบัตรประจำตัวสมาชิกสภาทนายความหรือใบอนุญาตให้เป็นทนายความ',
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
                                      itemImageSign['id'].toString(), "3");
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
    _callRead();
    super.initState();
  }

  _callRead() {}

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

    if (itemImage1['imageUrl'] != "") {
      _itemImage.add(itemImage1);
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'กรุณาเพิ่มสําเนาหนังสือรับรองการเป็นทนายความผู้ทําคํารับรองลายมือชื่อฯ',
      );
      return;
    }
    if (itemImage2['imageUrl'] != "") {
      _itemImage.add(itemImage2);
    } else {
      _dialogStatus(
        'แจ้งเตือน!',
        'สำเนาบัตรประจำตัวสมาชิกสภาทนายความหรือใบอนุญาตให้เป็นทนายความ',
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
      "prefixName": _selectedPrefix,
      "firstName": txtFirstName.text,
      "lastName": txtLastName.text,
      "com_no": txtCom_no.text,
      "doc_no": txtDoc_no.text,
      "doc_total": txtDoc_total.text,
      "remark": txtRemark.text,
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

    // logWTF(data);

    // String jsonString = jsonEncode(data);
    // const chunkSize = 1000; // Define the max size of each chunk
    // for (int i = 0; i < jsonString.length; i += chunkSize) {
    //   print(jsonString.substring(
    //       i,
    //       i + chunkSize > jsonString.length
    //           ? jsonString.length
    //           : i + chunkSize));
    // }

    _modelReport = await postDio(reporterCertifyReadApi, {'code': profileCode});
    if (_modelReport.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NsaReportPayForm(
            type: 'reportCertify',
            title: '',
          ),
        ),
      );
    } else {
      final result = await postObjectData('m/v2/ReporterCertify/create', data);
      if (result['status'] == 'S') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NsaReportPayForm(
              type: 'reportCertify',
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
