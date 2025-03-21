import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:lc/pages/profile/setting_notification.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v3/about_us.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../organization.dart';
import '../../policy.dart';
import '../../shared/google.dart';
import '../../shared/line.dart';
import '../../widget/dialog.dart';
import 'change_password.dart';
import 'edit_user_information_v2.dart';
import 'identity_verification_v2.dart';

class UserInformationPageV2 extends StatefulWidget {
  const UserInformationPageV2({super.key, this.lcCategory = false});

  final bool lcCategory;

  @override
  // ignore: library_private_types_in_public_api
  _UserInformationPageV2State createState() => _UserInformationPageV2State();
}

class _UserInformationPageV2State extends State<UserInformationPageV2> {
  final storage = const FlutterSecureStorage();

  late String profileCode;
  late String _username;
  late String _password;
  late String _facebookID;
  late String _appleID;
  late String _googleID;
  late String _lineID;
  late String _email;
  late String _imageUrl = '';
  late String _category = '';
  late String _prefixName;
  late String _firstName = '';
  late String _lastName = '';
  late String _idCard = '';
  late String _status = '';

  final bool _isLoginSocial = false;
  final bool _isLoginSocialHaveEmail = false;
  final bool _isShowStep1 = true;
  final bool _checkedValue = false;

  late String _dataPolicy;

  final _formKey = GlobalKey<FormState>();

  final List<String> _prefixNames = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;

  int selectedLanguage = 1;
  String languageName = "th";

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();

  late Future<dynamic> futureModel = Future.value();
  late Future<dynamic> _futureAboutUs;
  late Future<dynamic> _futureProfile;

  // ignore: non_constant_identifier_names
  dynamic CheckDeleteModel = {};

  ScrollController scrollController = ScrollController();
  bool hasCheckIn = false;
  bool hasCheckOut = false;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    readStorage();
    _readConfigulation();
    _futureAboutUs = post('${aboutUsApi}read', {});
    super.initState();
  }

  void goBack() async {
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
    // Navigator.pop(context, false);
    // Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.popUntil(context, ModalRoute.withName(Menu().routeName));
    // Navigator.of(context).popUntil(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
  }

  // static final FacebookLogin facebookSignIn = new FacebookLogin();

  void logout() async {
    // var category = await storage.read(key: 'profileCategory');

    // final GoogleSignIn _googleSignIn = GoogleSignIn(
    //   scopes: <String>[
    //     'email',
    //     'https://www.googleapis.com/auth/contacts.readonly',
    //   ],
    // );

    // if (category == 'google') {
    //   _googleSignIn.signOut();
    // } else if (category == 'facebook') {
    //   // await facebookSignIn.logOut();
    // }

    // // delete
    // await storage.deleteAll();
    // ignore: prefer_const_declarations
    final storage = const FlutterSecureStorage();

    var profileCategory = await storage.read(key: 'profileCategory');
    if (profileCategory != '' && profileCategory != null) {
      switch (profileCategory) {
        case 'facebook':
          // logoutFacebook();
          break;
        case 'google':
          logoutGoogle();
          break;
        case 'line':
          logoutLine();
          break;
        default:
          break;
      }
    }
    await storage.deleteAll();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  readStorage() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    var value = await storage.read(key: 'dataUserLoginLC');
    var category = await storage.read(key: 'profileCategory');
    var languageName = await storage.read(key: 'languageName');
    selectedLanguage = languageName == "th" ? 1 : 2;
    var user = json.decode(value!);
    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        _firstName = user['firstName'] ?? '';
        _lastName = user['lastName'] ?? '';
        _idCard = user['idCard'] ?? '';
        _status = user['status'] ?? '';
        _category = category!;
      });
    }
  }

  _readConfigulation() async {
    var data = await postDio(
      server + "configulation/read",
      {
        "title": "OpenDelete",
        "username": "OpenDelete",
      },
    );
    setState(() {
      CheckDeleteModel = data;
    });
  }

  // card() {
  //   return Card(
  //     color: Colors.white,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15.0),
  //     ),
  //     elevation: 5,
  //     child: Padding(padding: EdgeInsets.all(15), child: contentCard()),
  //   );
  // }

  contentCard(String title, String description, {Function? nav1}) {
    return Container(
      color: const Color(0xFFFFFFFF),
      padding:
          const EdgeInsets.only(top: 10, bottom: 10, right: 22.69, left: 25),
      child: InkWell(
        onTap: () => nav1!(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Kanit',
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            title == "เปลี่ยนภาษา"
                ? Text(selectedLanguage == 1 ? 'ไทย' : "ENG",
                    style: const TextStyle(
                      fontSize: 17.0,
                      color: Color(0xFF2D9CED),
                      fontWeight: FontWeight.w500,
                    ))
                : const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF2D9CED),
                    size: 16,
                  ),
          ],
        ),
      ),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E2E2),
            width: 1.0,
          ),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: const Color(0xFF2D9CED),
                borderRadius: BorderRadius.circular(100)),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(5.0),
            //   color: Color(0xFFFAFAF9),
            // ),
            width: 35.0,
            height: 35.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                urlImage,
                height: 5.0,
                width: 5.0,
                color: const Color(0xFFFFFFFF),
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            width: MediaQuery.of(context).size.width * 0.72,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13.0,
                color: Color(0xFF2D9CED),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              "assets/logo/icons/right.png",
              height: 20.0,
              width: 20.0,
              color: const Color(0xFF2D9CED),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('------${widget.lcCategory}');
    return Scaffold(
      // appBar: header(context, goBack, title: 'ข้อมูลผู้ใช้งาน'),
      backgroundColor: const Color(0xFFF7F7F7),
      body: FutureBuilder<dynamic>(
        future: futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return dialogFail(context);
          } else {
            return Container(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                // padding: const EdgeInsets.all(10.0),
                children: <Widget>[
                  Column(
                    // alignment: Alignment.topCenter,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Positioned(
                            left: 15,
                            top: 15,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0x408AD2FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF2D9CED),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(
                                  _imageUrl != null && _imageUrl != ''
                                      ? 0.0
                                      : 5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white70),
                              height: 90,
                              width: 90,
                              margin: const EdgeInsets.only(top: 30.0),
                              child: _imageUrl != null && _imageUrl != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(35.0),
                                      child: _imageUrl != null
                                          ? Image.network(
                                              _imageUrl,
                                              fit: BoxFit.fill,
                                            )
                                          : null,
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'assets/images/user_not_found.png',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Text(
                          '$_firstName $_lastName',
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.lcCategory == true
                              ? 'บุคคลทั่วไป'
                              : "ทนายความ",
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: const Text('ตั้งค่าผู้ใข้',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        child: contentCard(
                          "บัญชีผู้ใช้งาน",
                          "",
                          nav1: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserInformationV2Page(),
                            ),
                          ).then(
                            (value) => readStorage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        child: contentCard(
                          "ยืนยันตัวตน",
                          "",
                          nav1: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IdentityVerificationV2Page(
                                title: 'ยืนยันตัวตน',
                              ),
                            ),
                          ).then(
                            (value) => readStorage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        child: contentCard(
                          "ประเภทสมาชิก",
                          "",
                          nav1: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrganizationPage(),
                            ),
                          ).then(
                            (value) => readStorage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      _category == "guest"
                          ? Container(
                              child: contentCard(
                                "เปลี่ยนรหัสผ่าน",
                                "",
                                nav1: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePasswordPage(),
                                  ),
                                ).then(
                                  (value) => readStorage(),
                                ),
                              ),
                            )
                          : Container(),

                      // SizedBox(height: 10),
                      // Container(
                      //   child: contentCard("Status 01",
                      //       "",
                      //       nav1: () {}),
                      // ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 25),
                            child: const Text('อื่นๆ',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: contentCard(
                          "ตั้งค่าการแจ้งเตือน",
                          "",
                          nav1: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingNotificationPage(),
                            ),
                          ).then(
                            (value) => readStorage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Container(
                      //   child: contentCard(
                      //     "เปลี่ยนภาษา",
                      //     "",
                      //     nav1: () => (buildModalLanguage(
                      //       context,
                      //       'กรุณาเลือกภาษาที่ต้องการ',
                      //     )).then(
                      //       (value) => readStorage(),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 3),
                      Container(
                        child: contentCard(
                          "เกี่ยวกับเรา",
                          "",
                          nav1: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              // ignore: prefer_const_constructors
                              builder: (context) => AboutUsPage(),
                            ),
                          ).then(
                            (value) => readStorage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        child: contentCard(
                          "นโยบาย",
                          "",
                          nav1: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PolicyPage(),
                            ),
                          ).then(
                            (value) => readStorage(),
                          ),
                        ),
                      ),
                      // SizedBox(height: 10),
                      // Container(
                      //   child: contentCard(
                      //     "เปลี่ยนภาษา",
                      //     "",
                      //     nav1: () {},
                      //   ),
                      // ),
                      // SizedBox(height: 10),
                      // Container(
                      //   child: contentCard(
                      //     "การเชื่อต่อโซเชียลกับบัญชีผู้ใช้งาน",
                      //     "",
                      //     nav1: () {},
                      //   ),
                      // ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () => logout(),
                        child: Container(
                          width: 145,
                          height: 35,
                          decoration: BoxDecoration(
                            color: const Color(0x40ED6B2D),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // color: Colors.green,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/logout.png',
                                width: 15,
                                height: 18.75,
                                color: const Color(0xFFED6B2D),
                              ),
                              const Text(
                                " ออกจากระบบ",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(0xFFED6B2D),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if ((CheckDeleteModel['description'] ?? "") == "Y")
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: () => {
                              dialog(
                                context,
                                title: 'คุณต้องการลบบัญชี',
                                description:
                                    'คุณต้องการลบบัญชีออกจาก สภาทนายความ ใช่หรือไม่',
                                isYesNo: true,
                                btnOk: 'ใช่',
                                btnCancel: 'ไม่ใช่',
                                callBack: (data) {
                                  if (data) {
                                    postDio('${server}m/Register/delete', {
                                      "code": profileCode,
                                      "updateBy": _firstName
                                    });
                                    logout();
                                  }
                                },
                              ),
                            },
                            child: const Text(
                              'ลบบัญชี',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Kanit',
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(right: 5),
                        child: const Text(
                          versionName,
                          style: TextStyle(
                            color: Color(0xFF2D9CED),
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  buildModalLanguage(
    BuildContext context,
    String title,
  ) {
    return showCupertinoModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0.4),
        backgroundColor: Colors.white.withOpacity(0.4),
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(0.75, 0),
                      color: Colors.grey.withOpacity(0.4),
                    )
                  ]),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            title,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 37),
                        Container(
                          child: RadioListTile(
                            contentPadding: const EdgeInsets.all(0),
                            value: 1,
                            groupValue: selectedLanguage,
                            title: Row(
                              children: [
                                Image.asset(
                                  "assets/icon_th.png",
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  "ภาษาไทย",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: selectedLanguage == 1
                                          ? const Color(0xFF2D9CED)
                                          : Colors.black),
                                )
                              ],
                            ),
                            onChanged: (value) => setState(
                              (() async {
                                await storage.write(
                                  key: 'languageName',
                                  value: 'th',
                                );
                                selectedLanguage = value!;
                                Navigator.pop(context);
                              }),
                            ),
                            activeColor: const Color(0xFF2D9CED),
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        ),
                        Container(
                          child: RadioListTile(
                            contentPadding: const EdgeInsets.all(0),
                            value: 2,
                            groupValue: selectedLanguage,
                            title: Row(
                              children: [
                                Image.asset(
                                  "assets/icon_eng.png",
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  "ENG",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w500,
                                      color: selectedLanguage == 2
                                          ? const Color(0xFF2D9CED)
                                          : Colors.black),
                                )
                              ],
                            ),
                            onChanged: (value) => setState(
                              (() async {
                                await storage.write(
                                  key: 'languageName',
                                  value: 'en',
                                );

                                selectedLanguage = value!;
                                Navigator.pop(context);
                              }),
                            ),
                            activeColor: const Color(0xFF2D9CED),
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 15,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.clear,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
