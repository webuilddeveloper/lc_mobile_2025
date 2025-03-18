// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lc/component/header.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/widget/text_form_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final txtEmail = TextEditingController();

  @override
  void dispose() {
    txtEmail.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> submitForgotPassword() async {
    postObjectData('m/Register/forgot/password', {
      'email': txtEmail.text,
    });
    // final result = await postObjectData('m/Register/forgot/password', {
    //   'email': txtEmail.text,
    // });

    setState(() {
      txtEmail.text = '';
    });
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CupertinoAlertDialog(
            title: Text(
              'เปลี่ยนรหัสผ่านเรียบร้อยแล้ว',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: Text(" "),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFF9A1120),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );

    // if (result['status'] == 'S') {
    //   return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: Text(result['message'].toString()),
    //       );
    //     },
    //   );
    // } else {
    //   return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: Text(result['message'].toString()),
    //       );
    //     },
    //   );
    // }
  }

  void goBack() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background/login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: header(context, goBack, title: 'ลืมรหัสผ่าน'),
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Text(
                            'กรอกอีเมลเพื่อรับรหัสผ่านใหม่ ระบบจะส่งรหัสผ่านใหม่ไปยังอีเมลของคุณ',
                            style: TextStyle(
                              fontSize: 18.00,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        labelTextFormField('อีเมล'),
                        textFormField(
                          txtEmail,
                          '',
                          'อีเมล',
                          'อีเมล',
                          true,
                          false,
                          true,
                          false,
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            margin: EdgeInsets.only(
                              top: 20.0,
                              bottom: 10.0,
                            ),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color(0xFFFF7514),
                              child: MaterialButton(
                                height: 40,
                                onPressed: () {
                                  final form = _formKey.currentState;
                                  if (form!.validate()) {
                                    form.save();
                                    submitForgotPassword();
                                  }
                                },
                                child: Text(
                                  'ยืนยัน',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
