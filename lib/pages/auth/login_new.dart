// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:lc/pages/auth/forgot_password.dart';
import 'package:lc/pages/auth/text_field.dart';
// import 'package:lc/menu_v2.dart';
import 'package:lc/shared/apple_firebase.dart';
import 'package:lc/shared/google_firebase.dart';
import 'package:lc/shared/line.dart';
import 'package:lc/register.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/v3/menu_v3.dart';

DateTime now = DateTime.now();
// void main() {
//   // Intl.defaultLocale = 'th';
//   runApp(LoginPage());
// }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.title});
  final String? title;
  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = FlutterSecureStorage();

  late String _username;
  late String _password;
  late String _facebookID;
  late String _appleID;
  late String _googleID;
  late String _lineID;
  late String _email;
  late String _imageUrl;
  late String _category;
  late String _prefixName;
  late String _firstName;
  late String _lastName;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  bool showVisibility = false;
  bool statusVisibility = true;

  @override
  void initState() {
    setState(() {
      _username = "";
      _password = "";
      _facebookID = "";
      _appleID = "";
      _googleID = "";
      _lineID = "";
      _email = "";
      _imageUrl = "";
      _category = "";
      _prefixName = "";
      _firstName = "";
      _lastName = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    txtUsername.dispose();
    txtPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: _buildScreen(),
      ),
    );
  }

  _buildScreen() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Color(0xFF011895),
              ),
            ),
            Positioned.fill(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo/logo.png",
                        fit: BoxFit.contain,
                        height: 100.0,
                      ),
                      SizedBox(width: 30),
                      RichText(
                        text: TextSpan(
                          text: 'ยินดีต้อนรับ\n',
                          style: TextStyle(
                            color: Color(0xFF8AD2FF),
                            fontFamily: 'Kanit',
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'เข้าสู่ระบบ',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Kanit',
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 70),
                  Expanded(
                    child: _buildCard(),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Container _buildCard() {
    return Container(
      // constraints: BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'เข้าสู่ระบบผ่านบัญชีโซเชียล',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B6CA8),
            ),
          ),
          SizedBox(height: 15.0),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildButtonSocial(
                    icon: Image.asset(
                      "assets/images/facebook_circle.png",
                    ),
                    title: 'facebook',
                    press: () async {
                      pressFacebook();
                    },
                  ),
                  _buildButtonSocial(
                    icon: Image.asset(
                      "assets/images/google_circle.png",
                    ),
                    title: 'google',
                    press: () async {
                      pressGoogle();
                    },
                  ),
                  _buildButtonSocial(
                    icon: Image.asset(
                      "assets/images/line_circle.png",
                    ),
                    title: 'line',
                    press: () async {
                      pressLine();
                    },
                  ),
                  if (Platform.isIOS)
                    _buildButtonSocial(
                      icon: Image.asset(
                        "assets/images/apple_circle.png",
                      ),
                      title: 'apple ID',
                      press: () async {
                        pressApple();
                      },
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.0),
          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: Color(0xFF2D9CED),
                          width: double.infinity,
                          height: 1,
                        ),
                      ),
                      Text(
                        ' หรือลงทะเบียนผ่าน ',
                        style: TextStyle(
                            fontSize: 10.00,
                            fontFamily: 'Kanit',
                            color: Color(0xFF2D9CED)),
                      ),
                      Expanded(
                        child: Container(
                          color: Color(0xFF2D9CED),
                          width: double.infinity,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.0),
                  textFieldLogin(
                    model: txtUsername,
                    hintText: 'ชื่อผู้ใช้งาน',
                    labelText: 'ชื่อผู้ใช้งาน',
                  ),
                  SizedBox(height: 15.0),
                  textFieldLogin(
                    model: txtPassword,
                    hintText: 'รหัสผ่าน',
                    labelText: 'รหัสผ่าน',
                    showVisibility: showVisibility,
                    visibility: statusVisibility,
                    enabled: true,
                    isPassword: true,
                    onChanged: () {
                      if (txtPassword.text.isNotEmpty) {
                        setState(() {
                          showVisibility = true;
                        });
                      } else {
                        setState(() {
                          showVisibility = false;
                        });
                      }
                    },
                    callback: () {
                      setState(() {
                        statusVisibility = !statusVisibility;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        "ลืมรหัสผ่าน ?",
                        style: TextStyle(
                          fontSize: 10.00,
                          fontFamily: 'Kanit',
                          color: Color(0xFF2D9CED),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          _buildLoginButton(),
          SizedBox(height: 15.0),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage(
                      username: "",
                      password: "",
                      facebookID: "",
                      appleID: "",
                      googleID: "",
                      lineID: "",
                      email: "",
                      imageUrl: "",
                      category: "guest",
                      prefixName: "",
                      firstName: "",
                      lastName: "",
                    ),
                  ),
                );
              },
              child: Text(
                "สมัครสมาชิก",
                style: TextStyle(
                  fontSize: 10.00,
                  fontFamily: 'Kanit',
                  color: Color(0xFF2D9CED),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => ForgotPasswordPage(),
          //           ),
          //         );
          //       },
          //       child: Text(
          //         "ลืมรหัสผ่าน",
          //         style: TextStyle(
          //           fontSize: 10.00,
          //           fontFamily: 'Kanit',
          //         ),
          //       ),
          //     ),
          //     Container(
          //       height: 10,
          //       width: 1,
          //       color: Colors.blue,
          //       margin: EdgeInsets.symmetric(horizontal: 5),
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (BuildContext context) => new RegisterPage(
          //               username: "",
          //               password: "",
          //               facebookID: "",
          //               appleID: "",
          //               googleID: "",
          //               lineID: "",
          //               email: "",
          //               imageUrl: "",
          //               category: "guest",
          //               prefixName: "",
          //               firstName: "",
          //               lastName: "",
          //             ),
          //           ),
          //         );
          //       },
          //       child: Text(
          //         "สมัครสมาชิก",
          //         style: TextStyle(
          //           fontSize: 10.00,
          //           fontFamily: 'Kanit',
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: 15.0),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  test() {}

  _buildButtonSocial(
      {required Widget icon, required String title, required Function press}) {
    return Column(
      children: [
        Container(
          alignment: FractionalOffset(0.5, 0.5),
          height: 45.0,
          width: 45.0,
          child: IconButton(
            onPressed: () async {
              press();
            },
            icon: icon,
            padding: EdgeInsets.all(5.0),
          ),
        ),
        // Text(title)
      ],
    );
  }

  _buildLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Container(
            height: 40,
            width: 300,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.red,
              gradient: LinearGradient(
                colors: [
                  Color(0xFFED6B2D),
                  Color(0xFFED6B2D),
                ],
                begin: Alignment.centerLeft,
                end: Alignment(1.0, 0.0),
              ),
            ),
            child: Text(
              'เข้าสู่ระบบ',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => loginWithGuest(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDialog(String param) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          param,
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
                color: Color(0xFF000070),
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
  }

  //login username / password
  Future<dynamic> login() async {
    if ((_username == null || _username == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            'กรุณากรอกชื่อผู้ใช้',
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
                  color: Color(0xFF000070),
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
    } else if ((_password == null || _password == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            'กรุณากรอกรหัสผ่าน',
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
                  color: Color(0xFF000070),
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
    } else {
      print('----- start login -----');

      // String url = _category == 'guest'
      //     ? 'm/Register/login'
      //     : 'm/Register/${_category}/login';

      // print('----- url ----- $url');

      // final result = await postLoginRegister(url, {
      //   'username': _username.toString(),
      //   'password': _password.toString(),
      //   'category': _category.toString(),
      //   'email': _email.toString(),
      // });

      Dio dio = Dio();
      var response = await dio.post(
        '${server}m/register/login',
        data: {
          'username': _username.toString(),
          'password': _password.toString()
        },
      );
      // ignore: avoid_print
      print('----- response ----- ${response.toString()}');

      if (response.data['status'] == 'S') {
        FocusScope.of(context).unfocus();
        TextEditingController().clear();
        createStorageApp(
          model: response.data['objectData'],
          category: 'guest',
        );

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MenuV3(),
        //   ),
        // );
      } else {
        showDialog(
          barrierDismissible: false,
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(
              'ชื่อผู้ใช้งาน/รหัสผ่าน ไม่ถูกต้อง',
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
                    color: Color(0xFF000070),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  TextEditingController().clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  Future<dynamic> register() async {
    final result = await postLoginRegister('m/Register/create', {
      'username': _username,
      'password': _password,
      'category': _category,
      'email': _email,
      'facebookID': _facebookID,
      'appleID': _appleID,
      'googleID': _googleID,
      'lineID': _lineID,
      'imageUrl': _imageUrl,
      'prefixName': _prefixName,
      'firstName': _firstName,
      'lastName': _lastName,
      'status': "N",
      'platform': Platform.operatingSystem.toString(),
      'birthDay': "",
      'phone': "",
      'countUnit': "[]"
    });

    if (result.status == 'S') {
      await storage.write(
        key: 'dataUserLoginLC',
        value: jsonEncode(result.objectData),
      );

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => MenuV3(),
      //   ),
      //   (Route<dynamic> route) => false,
      // );
    } else {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            result.message,
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
                  color: Color(0xFF000070),
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
    }
  }

  //login guest
  void loginWithGuest() async {
    setState(() {
      _category = 'guest';
      _username = txtUsername.text;
      _password = txtPassword.text;
      _facebookID = "";
      _appleID = "";
      _googleID = "";
      _lineID = "";
      _email = "";
      _imageUrl = "";
      _prefixName = "";
      _firstName = "";
      _lastName = "";
    });
    login();
  }

  TextStyle style = TextStyle(
    fontFamily: 'Kanit',
    fontSize: 18.0,
  );

  pressFacebook() async {
    await FacebookAuth.instance.logOut();
    // var obj = await signInWithFacebook();
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
    // or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken? accessToken = result.accessToken;

      if (accessToken != null) {
        // user is logged
        print(accessToken.toString());
        final userData = await FacebookAuth.i.getUserData();
        print(
            '---------------- Facebook ----------------' + userData.toString());

        try {
          var model = {
            "username": userData['email'].toString(),
            "email": userData['email'].toString(),
            "imageUrl": userData['picture']['data']['url'].toString(),
            "firstName": userData['name'].toString(),
            "lastName": '',
            "facebookID": userData['id'].toString()
          };

          Dio dio = Dio();
          var response = await dio.post(
            '${server}m/v2/register/facebook/login',
            data: model,
          );

          setState(() async {
            await storage.write(
              key: 'categorySocial',
              value: 'Facebook',
            );

            await storage.write(
              key: 'imageUrlSocial',
              value: userData['picture']['data']['url'].toString(),
            );

            await createStorageApp(
              model: response.data['objectData'],
              category: 'facebook',
            );

            // if (accessToken != null) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => MenuV3(),
            //     ),
            //   );
            // }
          });

          // setState(() => _loadingSubmit = false);
        } catch (e) {
          // setState(() => _loadingSubmit = false);
        }
      }
    } else {
      print(result.status);
      print(result.message);
    }
  }

  pressGoogle() async {
    var obj = await signInWithGoogle();
    // print('----- Login Google ----- ' + obj.toString());
    if (obj != null) {
      var model = {
        "username": obj.user!.email,
        "email": obj.user!.email,
        "imageUrl": obj.user!.photoURL ?? '',
        "firstName": obj.user!.displayName,
        "lastName": '',
        "googleID": obj.user!.uid
      };

      Dio dio = Dio();
      var response = await dio.post(
        '${server}m/v2/register/google/login',
        data: model,
      );

      await storage.write(
        key: 'categorySocial',
        value: 'Google',
      );

      await storage.write(
        key: 'imageUrlSocial',
        value: obj.user!.photoURL ?? '',
      );

      createStorageApp(
        model: response.data['objectData'],
        category: 'google',
      );

      if (obj != null) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MenuV3(),
        //   ),
        // );
      }
    }
  }

  pressLine() async {
    var obj = await loginLine();

    // _buildDialog(obj.toString());
    // print('----- obj -----' +
    //     obj.toString());
    final idToken = obj.accessToken.idToken;
    // _buildDialog('----- idToken -----' +
    //     idToken.toString());

    // _buildDialog(idToken.toString());
    // print('----- idToken -----' +
    //     idToken.toString());
    final userEmail = (idToken != null) ? idToken['email'] ?? '' : '';

    // _buildDialog('----- userEmail -----' +
    //     userEmail);

    // _buildDialog(
    //     '----- userProfile -----' +
    //         obj.userProfile.toString());

    if (obj != null) {
      var model = {
        "username": (userEmail != '' && userEmail != null)
            ? userEmail
            : obj.userProfile!.userId,
        "email": userEmail,
        "imageUrl": (obj.userProfile!.pictureUrl != '' &&
                obj.userProfile!.pictureUrl != null)
            ? obj.userProfile!.pictureUrl
            : '',
        "firstName": obj.userProfile!.displayName,
        "lastName": '',
        "lineID": obj.userProfile!.userId
      };

      // _buildDialog('----- model -----' +
      //     model.toString());

      Dio dio = Dio();
      var response = await dio.post(
        '${server}m/v2/register/line/login',
        data: model,
      );

      // print(response.data['objectData']['code']);
      // storage.write(
      //   key: 'profileCode18',
      //   value: response.data['objectData']['code'],
      // );

      // storage.write(key: 'profileCategory', value: 'line');

      await storage.write(
        key: 'categorySocial',
        value: 'Line',
      );

      await storage.write(
        key: 'imageUrlSocial',
        value: (obj.userProfile!.pictureUrl != '' &&
                obj.userProfile!.pictureUrl != null)
            ? obj.userProfile!.pictureUrl
            : '',
      );

      createStorageApp(
        model: response.data['objectData'],
        category: 'line',
      );

      if (obj != null) {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MenuV3(),
        //   ),
        // );
      }
    }
  }

  pressApple() async {
    var obj = await signInWithApple();
    var model = {
      "username": obj.user!.email ?? obj.user?.uid,
      "email": obj.user?.email ?? '',
      "imageUrl": '',
      "firstName": obj.user?.email,
      "lastName": '',
      "appleID": obj.user?.uid
    };
    Dio dio = Dio();
    var response = await dio.post(
      '${server}m/v2/register/apple/login',
      data: model,
    );
    createStorageApp(
      model: response.data['objectData'],
      category: 'apple',
    );
    if (obj != null) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => MenuV3(),
      //   ),
      // );
    }
  }
}
