import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lc/shared/extension.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../../widget/text_form_field.dart';
import 'cremation_register_policy.dart';

class CremationRegisterSecondForm extends StatefulWidget {
  const CremationRegisterSecondForm({Key? key, this.model}) : super(key: key);
  final dynamic model;

  @override
  State<CremationRegisterSecondForm> createState() =>
      _CremationRegisterSecondFormState();
}

class _CremationRegisterSecondFormState
    extends State<CremationRegisterSecondForm> {
  final _formKey = GlobalKey<FormState>();

  final txtidcard = TextEditingController();
  final txtPhone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/bg_cremation_second.png"),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.contain,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.2), BlendMode.dstATop),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).padding.top + 60),
                        Container(
                          child: Align(
                            child: Image.asset(
                              "assets/images/fram_register_second.png",
                              fit: BoxFit.contain,
                              height: 100.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        Expanded(
                          child: _builCard(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 45.0,
                    height: 45.0,
                    margin: EdgeInsets.only(top: 55, left: 15, bottom: 100),
                    // padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/images/cremation_back.png',
                        // color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _builCard() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              height: 40,
              // margin: const EdgeInsets.symmetric(vertical: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 1.0),
                  child: Text(
                    'สวัสดีสมาชิก',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 30,
                        color: Color(0xFF2D9CED)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 1.0),
                  child: Text(
                    '${widget.model['name']}',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Color(0xFF2D9CED)),
                  ),
                ),
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 1.0),
                  child: Text(
                    'หมายเลขสมาชิก ${widget.model['cremation_no']}',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                        color: Color(0xFF707070)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 1.0),
                  child: Text(
                    'กรุณากรอกข้อมูล',
                    style: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Color(0xFF000000)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            textFormIdCardFieldV2(
              txtidcard,
              'รหัสประจำตัวประชาชน',
              'รหัสประจำตัวประชาชน',
              'รหัสประจำตัวประชาชน',
              true,
            ),
            SizedBox(height: 20),
            textFormPhoneFieldV2(
              txtPhone,
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              true,
              true,
            ),
            SizedBox(height: 50),
            Container(
              alignment: Alignment.bottomCenter,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            color: Color(0xFFED6B2D),
                            // minWidth: MediaQuery.of(context).size.width,
                            height: 40,
                            // minWidth: 50,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(73)),
                            onPressed: () {
                              goBack();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'ย้อนกลับ',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            color: Color(0xFFED6B2D),
                            // minWidth: MediaQuery.of(context).size.width,
                            height: 40,
                            // minWidth: 50,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(73)),
                            onPressed: () {
                              final form = _formKey.currentState;
                              if (form!.validate()) {
                                form.save();
                                nextStepPolicy();
                              } else {}
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'ถัดไป',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    logWTF(widget.model);
    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtidcard.dispose();
    txtPhone.dispose();
    super.dispose();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  _callRead() async {}

  nextStepPolicy() async {
    setState(() {
      widget.model['idcard'] = txtidcard.text;
      widget.model['phone'] = txtPhone.text;
    });

    Dio dio = new Dio();
    var response = await dio.post('${server}cremation/registerRead', data: {
      'skip': 0,
      'limit': 1,
      'idcard': txtidcard.text,
    });
    var modelRegister = response.data['objectData'];
    if (modelRegister.length <= 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CremationRegisterPolicyForm(model: widget.model),
        ),
      );
    } else {
      _dialogStatus(
          'หมายเลขบัตรประชาชนซ้ำ',
          'เลขบัตรประชาชนของท่านมีในระบบแล้ว',
          'กรุณาตรวจสอบข้อมูลที่กรอกอีกครั้ง');
    }
  }

  Future<dynamic> _dialogStatus(
      String title, String subTitle1, String subTitle2) async {
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
              height: 170,
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
                        fontSize: 14,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    Text(
                      subTitle2,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    SizedBox(height: 25),
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
                              color: Color(0xFFDDDDDD),
                            ),
                            child: Text(
                              'ยกเลิก',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Kanit',
                                color: Color(0xFF707070),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
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
}
