import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lc/shared/extension.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../../widget/text_form_field.dart';
import 'cremation_pay_confirm.dart';

class CremationPayForm extends StatefulWidget {
  const CremationPayForm({Key? key, required this.title, this.model})
      : super(key: key);
  final String title;
  final dynamic model;

  @override
  State<CremationPayForm> createState() => _CremationPayFormState();
}

class _CremationPayFormState extends State<CremationPayForm> {
  dynamic model;
  String memberStatus = "0";
  final txtPrice = TextEditingController();
  String profileCode = "";
  final storage = new FlutterSecureStorage();
  String selectedType = '0';
  late XFile _image;
  dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
  final tempPrice = TextEditingController();
  Random random = new Random();
  final _formKey = GlobalKey<FormState>();

  String totalAmount = '0';
  String updateDate = '-';
  List<dynamic> _itemImage = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFF7F7F7),
        flexibleSpace: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Color(0x408AD2FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Color(0xFF2D9CED),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "ข้อมูลสมาชิกฌาปนกิจ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
      ),
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WillPopScope(
          // onWillPop: () => confirmExit(),
          // ignore: missing_return
          onWillPop: () async {
            return Future.value(true);
          },
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                width: 400,
              ),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 60),
                    height: 320,
                    width: 340,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        memberStatus == "0"
                            ? 'assets/images/img_main1.png'
                            : memberStatus == "1"
                                ? 'assets/images/img_main2.png'
                                : 'assets/images/img_main3.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(40.0),
                      child: Image.asset(
                          memberStatus == "0"
                              ? 'assets/images/fram_main1.png'
                              : memberStatus == "1"
                                  ? 'assets/images/fram_main2.png'
                                  : 'assets/images/fram_main3.png',
                          height: 210,
                          width: 210),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    child: Text(
                      totalAmount != null && totalAmount != ""
                          ? totalAmount
                          : '0',
                      style: TextStyle(
                        fontSize: 45.00,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 115,
                    child: Text(
                      'ข้อมูลอัพเดตเมื่อ',
                      style: TextStyle(
                        fontSize: 15.00,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 95,
                    child: Text(
                      updateDate != null && updateDate != '' ? updateDate : '-',
                      style: TextStyle(
                        fontSize: 15.00,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    memberStatus == "0"
                        ? Container(
                            child: Text(
                              "ยอดเงินสงเคราะห์ล่วงหน้าคงเหลือ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF052598)),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : memberStatus == "1"
                            ? Container(
                                child: Text(
                                  "ยอดเงินสงเคราะห์ค้างชำระ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFED6B2D)),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(
                                child: Text(
                                  "ท่านพ้นสภาพสมาชิก ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFED6B2D)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                    memberStatus == "0"
                        ? Container()
                        : memberStatus == "1"
                            ? Container(
                                child: Text(
                                  "เงินสงเคราะห์ล่วงหน้าและค่าบำรุงประจำปี",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFED6B2D)),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container(
                                child: Text(
                                  "หากประสงค์กลับเข้าเป็นสมาชิก กรุณาติดต่อสภาทนายความ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFED6B2D)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                    const SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            // padding: EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedType = '0';
                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: selectedType == '0'
                                            ? Color(0xFF2D9CED)
                                            : Color(0xFFD9D9D9),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        'ข้อมูลธนาคาร',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Kanit',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          decorationColor: selectedType == '0'
                                              ? Color(0xFF2D9CED)
                                              : Colors.transparent,
                                          decorationThickness: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedType = '1';
                                      });
                                    },
                                    child: Container(
                                      height: 35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: selectedType == '1'
                                            ? Color(0xFF2D9CED)
                                            : Color(0xFFD9D9D9),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        'วิธีการใช้',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Kanit',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          decorationColor: selectedType == '1'
                                              ? Color(0xFF2D9CED)
                                              : Colors.transparent,
                                          decorationThickness: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.bottomCenter,
                      // height: (deviceHeight >= 500 && deviceHeight < 800)
                      //     ? 430
                      //     : (deviceHeight >= 800)
                      //         ? 380
                      //         : deviceHeight * 0.2,
                      child: selectedType == '0' ? _tap1() : _tap2(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _tap1() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
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
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 1 / 100),
                      image: DecorationImage(
                        image: AssetImage("assets/images/icon_bank.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    height: height * 8 / 100,
                    width: height * 8 / 100,
                  ),
                  Column(
                    children: [
                      Container(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          '948-0-17901-0',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D9CED),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'ชื่อบัญชี : สภาทนายความ ในพระบรมราชูปถัมภ์ (การฌาปนกิจ) สะพานใหม่ ดอนเมือง',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      Container(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'ธนาคาร ธ.กรุงเทพ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () => _downloadQR(),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: height * 5 / 100,
                          width: (width * 50) / 100,
                          child: Image.asset(
                            'assets/images/icon_downloadQR.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15.0),
        Form(
          key: _formKey,
          child: Container(
            // width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xFFFFFFFF),
            ),
            child: Column(
              children: [
                //  SizedBox(height: 20),
                textFormFieldV2(
                  txtPrice,
                  '',
                  'กรอกจำนวนเงิน',
                  'กรอกจำนวนเงิน',
                  'กรุณากรอกจำนวนเงิน',
                  true,
                  false,
                  false,
                  isPattern: true,
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 20),
                itemImage1['imageUrl'] != "" && itemImage1['imageUrl'] != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 25 / 100,
                            height: 160,
                            child: MaterialButton(
                              onPressed: () {
                                _showPickerImage(context, '1');
                              },
                              padding: EdgeInsets.all(0),
                              child: Image.network(
                                itemImage1['imageUrl'],
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          InkWell(
                            onTap: () => _showPickerImage(context, '1'),
                            child: Container(
                              child: Text(
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
                            'assets/images/cremation_upload.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(25.0),
                      color: Color(0xFFF58A33),
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
                        child: new Text(
                          'ถัดไป',
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
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  _tap2() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Text(
              '1. ตรวจสอบยอดเงินสงเคราะห์ล่วงหน้า / ยอดเงินสงคราะห์คงเหลือ'),
        ),
        SizedBox(height: 15.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Text('2. เลือกวิธีการชำระเงินที่ท่านสะดวก มายังบัญชี'),
        ),
        SizedBox(height: 15.0),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
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
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 1 / 100),
                      image: DecorationImage(
                        image: AssetImage("assets/images/icon_bank.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    height: height * 8 / 100,
                    width: height * 8 / 100,
                  ),
                  Column(
                    children: [
                      Container(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          '948-0-17901-0',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D9CED),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'ชื่อบัญชี : สภาทนายความ ในพระบรมราชูปถัมภ์ (การฌาปนกิจ) สะพานใหม่ ดอนเมือง',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      Container(
                        width: (width * 55) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'ธนาคาร ธ.กรุงเทพ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: height * 5 / 100,
                        width: (width * 50) / 100,
                        child: Image.asset(
                          'assets/images/icon_downloadQR.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Text('3. เมื่อชำระเงินแล้ว ถ่ายรูปหลักฐานการชำระ'),
        ),
        SizedBox(height: 15.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Text('4. แนบรูปภาพหลักฐานพร้อมกรอกยอดที่ท่านชำระมา'),
        ),
        SizedBox(height: 15.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Text(
              '5. กดปุ่ม "ถัดไป" ตรวจสอบข้อมความถูกต้อง ของท่าน และกด "ยืนยัน"'),
        ),
        SizedBox(height: 15.0),
        Container(
          // width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Column(
            children: [
              //  SizedBox(height: 20),
              textFormFieldV2(
                tempPrice,
                '',
                'กรอกจำนวนเงิน',
                'กรอกจำนวนเงิน',
                'กรุณากรอกจำนวนเงิน',
                false,
                false,
                false,
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                height: height * 6 / 100,
                width: (width * 60) / 100,
                child: Image.asset(
                  'assets/images/cremation_upload.png',
                  fit: BoxFit.contain,
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(25.0),
                    color: Color(0xFFF58A33),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 40,
                      onPressed: () {},
                      child: new Text(
                        'ถัดไป',
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
            ],
          ),
        ),
        SizedBox(height: 15.0),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Text(
              '6. เสร็จสิ้น ระบบจะส่งข้อมูลให้เจ้าหน้าที่ทำการตรวจสอบต่อไปและจะแจ้งผลให้ท่านทราบภายใน 15 วันทำการหลังจากที่ได้รับข้อมูลแล้ว'),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  @override
  initState() {
    tempPrice.text = "500";
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

    setState(() {
      totalAmount = widget.model['totalAmount'];
      updateDate = widget.model['updateDate'];
      memberStatus = widget.model['memberStatus'];
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
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFED6B2D),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      subTitle1,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width:
                                MediaQuery.of(context).size.height / 100 * 14,

                            height: 40,
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.5),
                              color: Color(0xFFED6B2D),
                            ),
                            child: Text(
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

  void _showPickerImage(context, String type) {
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
                    _imgFromGallery(type);
                    Navigator.of(context).pop();
                  },
                ),
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
    Random random = new Random();
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
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          'ต้องการลบรูปภาพ ใช่ไหม',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: new Text(''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
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
            child: new Text(
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

    var model = widget.model;
    setState(() {
      // profile['price'] =  txtPrice.text;
      model['payPrice'] = txtPrice.text;
      model['payImageUrl'] = itemImage1['imageUrl'];
    });

    logWTF(model);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CremationPayConfirmForm(model: model),
      ),
    );
  }

  late String imageData;
  bool dataLoaded = false;

  _downloadQR() async {
    var _url =
        "https://lc.we-builds.com/lc-document/images/news/009c0b2e-2ea9-4ce6-9ee9-b1d89e5cfb4b/S__54231044.jpg";

    var response = await Dio()
        .get(_url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "_imageQR");

    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ดาวน์โหลดรูปภาพเรียบร้อย'),
        ),
      );
    }
  }
}
