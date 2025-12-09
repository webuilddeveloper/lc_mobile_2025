import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lc/shared/extension.dart';
import 'package:lc/v4/menu_v4.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../../v3/menu_v3.dart';
import '../../widget/text_form_field.dart';
import 'cremation_register_second.dart';

class CremationRegisterFirstForm extends StatefulWidget {
  const CremationRegisterFirstForm({super.key, required this.title});
  final String title;

  @override
  State<CremationRegisterFirstForm> createState() =>
      _CremationRegisterFirstFormState();
}

class _CremationRegisterFirstFormState
    extends State<CremationRegisterFirstForm> {
  dynamic model;
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final txtCremation_no = TextEditingController();
  late Future<dynamic> _futureCremationMember;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 25),
                height: 1000,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/bg_cremation_first.png"),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.contain,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/images/fram_register_first.png",
                    width: 300,
                    height: (deviceHeight >= 500 && deviceHeight < 800)
                        ? 200
                        : (deviceHeight >= 800)
                            ? 400
                            : deviceHeight * 0.2,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    // height:  MediaQuery.of(context).size.height * .650,
                    height: (deviceHeight >= 500 && deviceHeight < 800)
                        ? 430
                        : (deviceHeight >= 800)
                            ? 450
                            : deviceHeight * 0.2,
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
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
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 1.0),
                                    child: Text(
                                      'เข้าสู่ระบบฌาปนกิจ',
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20,
                                          color: Color(0xFF2D9CED)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          textFormFieldV2(
                              txtCremation_no,
                              '',
                              'หมายเลขสมาชิกฌาปนกิจ',
                              'หมายเลขสมาชิกฌาปนกิจ',
                              'กรุณากรอกหมายเลขสมาชิกฌาปนกิจ',
                              true,
                              false,
                              false,
                              isPattern: false,
                              textInputType: TextInputType.number),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                // width: MediaQuery.of(context).size.width * 0.7,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                // margin: EdgeInsets.only(top: 120.0, bottom: 10.0),
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
                          nextStep();
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
              if (_loading)
                Positioned.fill(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: CircularProgressIndicator(
                      color: Color(0xFFED6B2D),
                    ),
                  ),
                ),
              Container(
                width: 45.0,
                height: 45.0,
                margin: EdgeInsets.only(top: 55, left: 15, bottom: 100),
                // padding: EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuV4(),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/cremation_back.png',
                    // color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    _callRead();

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtCremation_no.dispose();

    super.dispose();
  }

  _callRead() async {}

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
              width: MediaQuery.of(context).size.height / 100 * 30,
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
                    SizedBox(height: 5),
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
                    Text(
                      subTitle2,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width:
                                MediaQuery.of(context).size.height / 100 * 14,
                            height: 35,
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
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            width:
                                MediaQuery.of(context).size.height / 100 * 14,
                            height: 35,
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

  nextStep() async {
    setState(() {
      _loading = true;
      _futureCremationMember = postDio('${server}cremation/read',
          {'skip': 0, 'limit': 3, 'cremation_no': txtCremation_no.text});
    });

    var modelMember = await _futureCremationMember;

    logWTF(modelMember);
    if (modelMember != null) {
      if (modelMember.length == 1) {
        // logWTF(aa);
        Dio dio = new Dio();
        var response = await dio.post('${server}cremation/registerRead', data: {
          'skip': 0,
          'limit': 1,
          'cremation_no': txtCremation_no.text
        });
        var modelRegister = response.data['objectData'];

        // _futureRegisterCremation = postLogin('${server}cremation/registerRead',
        //     {'skip': 0, 'limit': 1, 'cremation_no': txtCremation_no.text});

        logWTF(modelRegister.length);
        setState(() {
          _loading = false;
        });
        if (modelRegister.length <= 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CremationRegisterSecondForm(model: modelMember[0]),
            ),
          );
        } else {
          _dialogStatus('เลขสมาชิกฌาปนกิจซ้ำ', 'ข้อมูลของท่านมีในระบบแล้ว',
              'กรุณาตรวจสอบข้อมูลที่กรอกอีกครั้ง');
        }
      } else {
        _dialogStatus('ขออภัยไม่พบข้อมูลของท่าน', 'ระบบไม่พบข้อมูลของท่าน',
            'กรุณาตรวจสอบข้อมูลที่กรอกอีกครั้ง');
      }
    } else {
      setState(() {
        _loading = false;
      });
      _dialogStatus('ขออภัยไม่พบข้อมูลของท่าน', 'ระบบไม่พบข้อมูลของท่าน',
          'กรุณาตรวจสอบข้อมูลที่กรอกอีกครั้ง');
    }
  }
}
