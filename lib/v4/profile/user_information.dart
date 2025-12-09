import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lc/component/header.dart';
import 'package:lc/organization.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:lc/pages/profile/identity_verification.dart';
import 'package:lc/pages/profile/setting_notification.dart';
import 'package:lc/shared/api_provider.dart';
import '../../policy.dart';
import 'change_password_v4.dart';
import 'edit_user_information.dart';

class UserInformationV4Page extends StatefulWidget {
  const UserInformationV4Page({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserInformationV4PageState createState() => _UserInformationV4PageState();
}

class _UserInformationV4PageState extends State<UserInformationV4Page> {
  final storage = const FlutterSecureStorage();

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
  late String _idCard;
  late String _status;

  final bool _isLoginSocial = false;
  final bool _isLoginSocialHaveEmail = false;
  final bool _isShowStep1 = true;
  final bool _isShowStep2 = false;
  final bool _checkedValue = false;

  late String _dataPolicy;

  final _formKey = GlobalKey<FormState>();

  final List<String> _prefixNames = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();

  late Future<dynamic> futureModel;
  late Future<dynamic> _futureAboutUs;

  ScrollController scrollController = ScrollController();

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
    // Navigator.popUntil(context, ModalRoute.withName(MenuV2().routeName));
    // Navigator.of(context).popUntil(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    // );
  }

  // static final FacebookLogin facebookSignIn = new FacebookLogin();

  void logout() async {
    var category = await storage.read(key: 'profileCategory');

    // ignore: no_leading_underscores_for_local_identifiers
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    if (category == 'google') {
      _googleSignIn.signOut();
    } else if (category == 'facebook') {
      // await facebookSignIn.logOut();
    }

    // delete
    await storage.deleteAll();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);
    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        _firstName = user['firstName'] ?? '';
        _lastName = user['lastName'] ?? '';
        _idCard = user['idCard'] ?? '';
        _status = user['status'] ?? '';
      });
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: const EdgeInsets.all(15), child: contentCard()),
    );
  }

  contentCard() {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(10.0),
      // padding: EdgeInsets.only(top: 65.0),
      children: <Widget>[
        ButtonTheme(
          child: TextButton(
            child: rowContentButton(
              "assets/logo/icons/Group105.png",
              "ข้อมูลผู้ใช้งาน",
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditUserInformationV4Page(),
              ),
            ).then(
              (value) => readStorage(),
            ),
          ),
        ),
        ButtonTheme(
          child: TextButton(
            child: rowContentButton(
              "assets/logo/icons/Group103.png",
              "ตั้งค่าการแจ้งเตือน",
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingNotificationPage(),
              ),
            ).then(
              (value) => readStorage(),
            ),
          ),
        ),
        // ButtonTheme(
        //   child: FlatButton(
        //     padding: EdgeInsets.all(0.0),
        //     child: rowContentButton(
        //       "assets/logo/icons/noun_Globe.png",
        //       "เปลี่ยนภาษา",
        //     ),
        //     // onPressed: () => Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) => ConnectSSOPage(goHome: false),
        //     //   ),
        //     // ).then(
        //     //   (value) => readStorage(),
        //     // ),
        //   ),
        // ),
        // ButtonTheme(
        //   child: FlatButton(
        //     padding: EdgeInsets.all(0.0),
        //     child: rowContentButton(
        //       "assets/logo/icons/Group109.png",
        //       "การเชื่อมต่อ",
        //     ),
        //     onPressed: () => Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ConnectSocialPage(),
        //       ),
        //     ).then(
        //       (value) => readStorage(),
        //     ),
        //   ),
        // ),
        ButtonTheme(
          child: TextButton(
            // padding: EdgeInsets.all(0.0),
            child: rowContentButton(
              "assets/logo/icons/Group221.png",
              "เปลี่ยนรหัสผ่าน",
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordV4Page(),
              ),
            ).then(
              (value) => readStorage(),
            ),
          ),
        ),
        // if (_status == 'N')
        ButtonTheme(
          child: TextButton(
            // padding: EdgeInsets.all(0.0),
            child: rowContentButton(
              "assets/logo/icons/2985813.png",
              "ยืนยันตัวตน",
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IdentityVerificationPage(
                  title: '',
                ),
              ),
            ).then(
              (value) => readStorage(),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        ButtonTheme(
          child: TextButton(
            // padding: EdgeInsets.all(0.0),
            child: rowContentButton(
              "assets/icon_user_information_organization.png",
              "ประเภทสมาชิก",
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OrganizationPage(),
              ),
            ).then((value) => {} //readStorage(),
                ),
          ),
        ),
        ButtonTheme(
          child: TextButton(
            // padding: EdgeInsets.all(0.0),
            child: rowContentButton(
              "assets/logo/icons/2985813.png",
              "นโยบาย",
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                // ignore: missing_required_param
                builder: (context) => const PolicyPage(),
              ),
            ).then((value) => {} //readStorage(),
                ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
      ],
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
    return Scaffold(
      appBar: header(context, goBack, title: 'ข้อมูลผู้ใช้งาน'),
      backgroundColor: const Color(0xFFDDDDDD),
      body: FutureBuilder<dynamic>(
        future: futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return dialogFail(context);
          } else
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
                          Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  'assets/background/backgroundUserInfo.png',
                                ),
                              ),
                            ),
                            height: 150.0,
                          ),
                          Container(
                            height: 10.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                  'assets/background/backgroundUserInfoColor.png',
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
                                  borderRadius: BorderRadius.circular(45),
                                  color: Colors.white70),
                              height: 90,
                              width: 90,
                              margin: const EdgeInsets.only(top: 30.0),
                              child: _imageUrl != null && _imageUrl != ''
                                  ? CircleAvatar(
                                      backgroundColor: Colors.black,
                                      backgroundImage:
                                          _imageUrl != null && _imageUrl != ''
                                              ? NetworkImage(_imageUrl)
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
                      Container(
                        color: Colors.white,
                        child: contentCard(),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        color: Colors.white,
                        child: ButtonTheme(
                          child: TextButton(
                            onPressed: () => {logout()},
                            // padding: EdgeInsets.all(10.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.power_settings_new,
                                  color: Colors.red,
                                ),
                                Text(
                                  " ออกจากระบบ",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Color(0xFFFC4137),
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ],
                            ),
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
        },
      ),
    );
  }
}
