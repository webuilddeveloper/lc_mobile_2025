import 'dart:math';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lc/pages/notarial_services_attorney/nsa_main.dart';
import 'package:lc/shared/extension.dart';
import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../../widget/header_v2.dart';
import '../../widget/text_form_field.dart';

class NsaReportPayForm extends StatefulWidget {
  const NsaReportPayForm(
      {super.key, required this.type, this.model, required this.title});
  final String type;
  final dynamic model;
  final String title;

  @override
  State<NsaReportPayForm> createState() => _NsaReportPayFormState();
}

class _NsaReportPayFormState extends State<NsaReportPayForm> {
  dynamic model;
  String memberStatus = "0";
  final txtPrice = TextEditingController();
  int totalPrice = 0;
  dynamic _modelReport = {};
  String profileCode = "";
  final storage = const FlutterSecureStorage();
  String selectedType = '0';
  late XFile _image;
  dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
  final tempPrice = TextEditingController();
  Random random = Random();
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  final txtDate = TextEditingController();
  final txtTime = TextEditingController();
  final txtCompanyName = TextEditingController();
  final txtCompanyAddress = TextEditingController();
  final txtTaxNo = TextEditingController();
  bool isPaymentType = false;
  bool isShowPaymentType = false;
  bool isShowTax = false;
  bool isTaxType = false;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  int selectPaymentType = 1;
  String paymentTypeName = "มารับเอง";
  Color selectedColor = const Color(0xFF758C29);

  int selectTaxType = 1;
  String taxTypeName = "ออกใบเสร็จในนามตนเอง";

  String totalAmount = '0';
  String updateDate = '-';
  final List<dynamic> _itemImage = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: headerNSAV2(context, callback: goBack, title: widget.title),
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          // onWillPop: () => confirmExit(),
          // ignore: missing_return
          onWillPop: () {
            return Future.value(false);
          },
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [_buildContent()],
          ),
        ),
      ),
    );
  }

  _buildContent() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          // width: double.infinity,
          // margin: EdgeInsets.only(top: 190.0, left: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 1 / 100),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/icon_bank_nsa.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    height: height * 8 / 100,
                    width: height * 8 / 100,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: const Text(
                          '134-757-9250',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF758C29),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: const Text(
                          'ชื่อบัญชี : สภาทนายความ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      SizedBox(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: const Text(
                          'ธนาคาร : ธ.กรุงเทพ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          _downloadQR(); // เรียกฟังก์ชันเมื่อถูกแตะ
                          print(
                              '--------select_downloadQR--------'); // พิมพ์แค่ตอนกด
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: height * 5 / 100,
                          width: (width * 50) / 100,
                          child: Image.asset(
                            'assets/images/icon_downloadQR_nsa.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Form(
          key: _formKey,
          child: Container(
            // width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFFFFFFFF),
            ),
            child: Column(
              children: [
                isShowPaymentType
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      const Color(0xFF758C29),
                                  radioTheme: RadioThemeData(
                                    fillColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (states) => selectedColor,
                                    ),
                                  ),
                                ),
                                child: RadioListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  value: 1,
                                  groupValue: selectPaymentType,
                                  title: const Text(
                                    "มารับเอง",
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        fontFamily: 'Kanit',
                                        color: Color(0xFF758C29)),
                                  ),
                                  onChanged: (value) => setState(
                                    (() {
                                      selectPaymentType = 1;
                                      paymentTypeName = "มารับเอง";
                                      isPaymentType = true;
                                      selectedColor = const Color(0xFF758C29);
                                      totalPrice = totalPrice - 80;
                                    }),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Theme(
                                data: ThemeData(
                                  unselectedWidgetColor:
                                      const Color(0xFF758C29),
                                  radioTheme: RadioThemeData(
                                    fillColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (states) => selectedColor,
                                    ),
                                  ),
                                ),
                                child: RadioListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  value: 2,
                                  groupValue: selectPaymentType,
                                  title: const Text("ส่งไปรษณีย์",
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17,
                                          fontFamily: 'Kanit',
                                          color: Color(0xFF758C29))),
                                  onChanged: (value) => setState(
                                    (() {
                                      selectPaymentType = 2;
                                      paymentTypeName = "ส่งไปรษณีย์";
                                      isPaymentType = false;
                                      selectedColor = const Color(0xFF758C29);
                                      totalPrice = totalPrice + 80;
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 0,
                  ),
                  child: Text(
                    'ยอดที่ต้องชำระ : $totalPrice บาท',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF758C29),
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
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
                          hintText: 'วัน / เดือน / ปีที่ชำระเงิน',
                          hintStyle: TextStyle(
                            color: const Color(0xFF758C29).withOpacity(0.9),
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
                        // ignore: missing_return
                        validator: (model) {
                          if (model!.isEmpty) {
                            return 'กรุณากรอกวันเดือนปีที่ชำระเงิน';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    // horizontal: 15,
                    vertical: 0,
                  ),
                  child: GestureDetector(
                    onTap: () => dialogOpenPickerTime(),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: txtTime,
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
                          hintText: 'เวลาที่ชำระ',
                          hintStyle: TextStyle(
                            color: const Color(0xFF758C29).withOpacity(0.9),
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
                        // ignore: missing_return
                        validator: (model) {
                          if (model!.isEmpty) {
                            return 'กรุณากรอกเวลาที่ชำระ';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                itemImage1['imageUrl'] != "" && itemImage1['imageUrl'] != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 25 / 100,
                            height: 160,
                            child: MaterialButton(
                              onPressed: () {
                                _showPickerImage(context, '1');
                              },
                              padding: const EdgeInsets.all(0),
                              child: Image.network(
                                itemImage1['imageUrl'],
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          InkWell(
                            onTap: () => _showPickerImage(context, '1'),
                            child: Container(
                              child: const Text(
                                'แก้ไขรูปภาพ',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2D9CED),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      )
                    : InkWell(
                        onTap: () => _showPickerImage(context, '1'),
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 6 / 100,
                          width: (width * 60) / 100,
                          child: Image.asset(
                            'assets/images/nsa_upload.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                const SizedBox(height: 10),
                isShowTax
                    ? Column(
                        children: [
                          Container(
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor: const Color(0xFF758C29),
                                radioTheme: RadioThemeData(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (states) => selectedColor,
                                  ),
                                ),
                              ),
                              child: RadioListTile(
                                contentPadding: const EdgeInsets.all(0),
                                value: 1,
                                groupValue: selectTaxType,
                                title: const Text(
                                  "ออกใบเสร็จในนามตนเอง",
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      fontFamily: 'Kanit',
                                      color: Color(0xFF758C29)),
                                ),
                                onChanged: (value) => setState(
                                  (() {
                                    selectTaxType = 1;
                                    taxTypeName = "ออกใบเสร็จในนามตนเอง";
                                    isTaxType = false;
                                    txtCompanyName.text = '';
                                    txtCompanyAddress.text = '';
                                    txtTaxNo.text = '';
                                    selectedColor = const Color(0xFF758C29);
                                  }),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor: const Color(0xFF758C29),
                                radioTheme: RadioThemeData(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (states) => selectedColor,
                                  ),
                                ),
                              ),
                              child: RadioListTile(
                                contentPadding: const EdgeInsets.all(0),
                                value: 2,
                                groupValue: selectTaxType,
                                title: const Text("ออกใบเสร็จในนามนิติบุคคล",
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17,
                                        fontFamily: 'Kanit',
                                        color: Color(0xFF758C29))),
                                onChanged: (value) => setState(
                                  (() {
                                    selectTaxType = 2;
                                    taxTypeName = "ออกใบเสร็จในนามนิติบุคคล";
                                    isTaxType = true;
                                    selectedColor = const Color(0xFF758C29);
                                  }),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              child: textFormFieldNSA(
                            txtCompanyName,
                            '',
                            'ชื่อบริษัท',
                            'ชื่อบริษัท',
                            'ชื่อบริษัท',
                            isTaxType,
                            false,
                            false,
                            false,
                          )),
                          const SizedBox(height: 10),
                          Container(
                              child: textFormFieldNSA(
                            txtCompanyAddress,
                            '',
                            'ที่อยู่บริษัท',
                            'ที่อยู่บริษัท',
                            'ที่อยู่บริษัท',
                            isTaxType,
                            false,
                            false,
                            false,
                          )),
                          const SizedBox(height: 10),
                          Container(
                              child: textFormFieldNSA(
                            txtTaxNo,
                            '',
                            'เลขประจำตัวผู้เสียภาษี',
                            'เลขประจำตัวผู้เสียภาษี',
                            'เลขประจำตัวผู้เสียภาษี',
                            isTaxType,
                            false,
                            false,
                            false,
                          )),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(25.0),
                      color: const Color(0xFFF58A33),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        height: 40,
                        onPressed: () {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            _payConfirm();
                          } else {}
                        },
                        child: const Text(
                          'ถัดไป',
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
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  @override
  initState() {
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtPrice.dispose();
    tempPrice.dispose();
    super.dispose();
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    if (profileCode != '' && profileCode != null) {}
    if (widget.type == "reportT01") {
      setState(() {
        isShowPaymentType = true;
      });
      _modelReport = await postDio(reporterT01ReadApi, {'code': profileCode});
    } else if (widget.type == "reportT02") {
      _modelReport = await postDio(reporterT02ReadApi, {'code': profileCode});
      setState(() {
        isShowPaymentType = true;
      });
    } else if (widget.type == "report03_21" || widget.type == "report03_22") {
      _modelReport =
          await postDio(reporter03ReadApi, {'profileCode': profileCode});
      setState(() {
        isShowPaymentType = false;
      });
    } else if (widget.type == "report04") {
      _modelReport =
          await postDio(reporter04ReadApi, {'profileCode': profileCode});
      setState(() {
        isShowPaymentType = false;
      });
    } else if (widget.type == "reportRegister") {
      _modelReport =
          await postDio(reporterRegisterReadApi, {'code': profileCode});
      setState(() {
        isShowPaymentType = false;
        isShowTax = true;
      });
    } else if (widget.type == "reportCertify") {
      _modelReport =
          await postDio(reporterCertifyReadApi, {'code': profileCode});
      setState(() {
        isShowPaymentType = false;
      });
    }

    _selectPaymentType();
  }

  _selectPaymentType() {
    setState(() {
      if (widget.type == "reportT01") {
        totalPrice = 4000;
      } else if (widget.type == "reportT02") {
        totalPrice = 2000;
      } else if (widget.type == "report03_21") {
        totalPrice = 300;
      } else if (widget.type == "report03_22") {
        totalPrice = 800;
      } else if (widget.type == "report04") {
        totalPrice = 100;
      } else if (widget.type == "reportRegister") {
        totalPrice = 8000;
      } else if (widget.type == "reportCertify") {
        int total = int.parse(_modelReport[0]['doc_total']);
        totalPrice = 100 * total;
      }
    });
  }

  Future<dynamic> _dialogStatus() async {
    String title = 'ขออภัยไม่พบข้อมูล';
    String subTitle1 = 'กรุณาแนบรูปภาพหลักฐานการโอนเงิน';
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
              width: MediaQuery.of(context).size.height / 100 * 30,
              height: 160,
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
                      subTitle1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Future<dynamic> _dialogSuccess() async {
    if (!context.mounted) return; // ป้องกัน context หาย

    double deviceHeight = MediaQuery.of(context).size.height;
    String title = 'ขอบคุณที่ชำระเงิน!';
    String subTitle1 = 'เจ้าหน้าที่กำลังตรวจสอบเอกสาร';
    String subTitle2 = 'และการชำระเงินของท่าน โปรดรอรับการแจ้งเตือน';

    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // ใช้ dialogContext แทน context
        return WillPopScope(
          onWillPop: () async => false,
          child: CustomAlertDialog(
            content: Container(
              width: MediaQuery.of(dialogContext).size.height / 100 * 40,
              height: (deviceHeight >= 500 && deviceHeight < 800)
                  ? 210
                  : (deviceHeight >= 800)
                      ? 210
                      : deviceHeight * 0.2,
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
                        fontSize: 18,
                        color: Color(0xFF011895),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subTitle1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    Text(
                      subTitle2,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    const SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                          Navigator.pushReplacement(
                            dialogContext,
                            MaterialPageRoute(
                              builder: (context) => const NSAMainForm(
                                title: '',
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        width:
                            MediaQuery.of(dialogContext).size.height / 100 * 17,
                        height: 40,
                        alignment: Alignment.center,
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
              ),
            ),
          ),
        );
      },
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
      });

      // setState(() {
      //   _imageUrl = res;
      // });
    }).catchError((err) {
      print(err);
    });
  }

  dialogDeleteImage(String code) async {
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
                color: Color(0xFF236F3C),
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
                color: Color(0xFF1B6CA8),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              deleteImage(code);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  deleteImage(String code) async {
    setState(() {
      _itemImage.removeWhere((c) => c['id'].toString() == code.toString());
    });
  }

  _payConfirm() async {
    if (itemImage1['imageUrl'] == "" || itemImage1['imageUrl'] == null) {
      _dialogStatus();
      return;
    }

    var model = {
      'code': _modelReport[0]['code'],
      'paymentAmount': totalPrice.toString(),
      'paymentDate': txtDate.text,
      'paymentTime': txtTime.text,
      'paymentType': paymentTypeName,
      'paymentImageUrl': itemImage1['imageUrl'],
    };

    if (isTaxType) {
      model['taxType'] = taxTypeName;
      model['companyName'] = txtCompanyName.text;
      model['companyAddress'] = txtCompanyAddress.text;
      model['tax_no'] = txtTaxNo.text;
    }

    var result;
    if (widget.type == "reportT01") {
      result = await postDio(server + 'm/v2/ReporterT01/updatePayment', model);
    } else if (widget.type == "reportT02") {
      result = await postDio(server + 'm/v2/ReporterT02/updatePayment', model);
    } else if (widget.type == "report03_21" || widget.type == "report03_22") {
      result = await postDio(server + 'reporter/tr03/updatePayment', model);
    } else if (widget.type == "report04") {
      result = await postDio(server + 'reporter/tr04/updatePayment', model);
    } else if (widget.type == "reportRegister") {
      result =
          await postDio(server + 'm/v2/ReporterRegister/updatePayment', model);
    } else if (widget.type == "reportCertify") {
      result =
          await postDio(server + 'm/v2/ReporterCertify/updatePayment', model);
    }
    logWTF(result);

    if (result != '' && result != null) {
      _dialogSuccess();
    }
  }

  late String imageData;
  bool dataLoaded = false;

  _downloadQR() async {
    var _url =
        "https://lc.we-builds.com/lc-document/images/mainPopup/480fc513-34f7-4467-be05-437bc2a9e1cc/qrpayment.jpg";
    try {
      var response = await Dio()
          .get(_url, options: Options(responseType: ResponseType.bytes));
      print('Image fetched successfully');

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "_imageQR",
      );
      print('Save result: $result');

      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ดาวน์โหลดรูปภาพเรียบร้อย')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('การดาวน์โหลดล้มเหลว')),
        );
      }
    } catch (e) {
      print('Error downloading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการดาวน์โหลด')),
      );
    }
  }

  void goBack() async {
    Navigator.pop(context, false);
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

  dialogOpenPickerTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF1B6CA8),
            timePickerTheme: TimePickerThemeData(
              dialTextColor: const Color(0xFF1B6CA8),
              hourMinuteTextColor: const Color(0xFF1B6CA8),
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color(0xFF1B6CA8)),
          ),
          child: child ?? Container(), // แก้ child null
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        txtTime.text = pickedTime.format(context); // ใช้ txtTime.text
      });
    }
  }
}
