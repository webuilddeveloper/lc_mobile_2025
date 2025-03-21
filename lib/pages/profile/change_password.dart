import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/profile/change_password_success.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v3/widget/header_v3.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordPage> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  final txtPasswordOld = TextEditingController();
  final txtPasswordNew = TextEditingController();
  bool showVisibilityOld = false;
  bool statusVisibilityOld = true;
  bool showVisibilityNew = false;
  bool statusVisibilityNew = true;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtPasswordOld.dispose();
    txtPasswordNew.dispose();
    super.dispose();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> submitChangePassword() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    user['password'] = txtPasswordOld.text;
    user['newPassword'] = txtPasswordNew.text;

    final result = await postObjectData('m/Register/change', user);
    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginLC',
        value: jsonEncode(result['objectData']),
      );
      return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => ChangePasswordSuccessPage(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text(
            'เปลี่ยนรหัสผ่านไม่สำเร็จ',
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
                  color: Color(0xFF9A1120),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () => goBack(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        appBar: headerV3(context, goBack, title: 'เปลี่ยนรหัสผ่าน'),
        backgroundColor: Colors.white,
        body: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(right: 15, left: 15, top: 30),
          children: <Widget>[
            // _buildHeader(),
            const SizedBox(height: 21),
            Image.asset(
              "assets/images/logo_change_password.png",
              width: 125,
              height: 125,
            ),
            const SizedBox(height: 25),
            const Text(
              'เปลี่ยนรหัสผ่าน',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF000000),
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: SizedBox(
                width: 278,
                child: Text(
                  'ท่านสามารถทำการเปลี่ยนรหัสผ่านด้วยตัวของท่านเอง โดยรหัสผ่านใหม่ต้องมี 8 ตัวอักษรขึ้นไป',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF707070),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      onTap: () => {Navigator.pop(context, true)},
      child: Row(
        children: [
          Image.asset(
            "assets/images/back_arrow_v2.png",
            width: 30,
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTextFormField(
            model: txtPasswordOld,
            hintText: 'รหัสผ่านเดิม',
            labelText: 'รหัสผ่านเดิม',
            showVisibility: showVisibilityOld,
            visibility: statusVisibilityOld,
            enabled: true,
            isPassword: true,
            onChanged: () {
              if (txtPasswordOld.text.isNotEmpty)
                setState(() {
                  showVisibilityOld = true;
                });
              else
                setState(() {
                  showVisibilityOld = false;
                });
            },
            callback: () {
              setState(() {
                statusVisibilityOld = !statusVisibilityOld;
              });
            },
          ),
          const SizedBox(height: 30),
          _buildTextFormField(
            model: txtPasswordNew,
            hintText: 'รหัสผ่านใหม่',
            labelText: 'รหัสผ่านใหม่',
            showVisibility: showVisibilityNew,
            visibility: statusVisibilityNew,
            enabled: true,
            isPassword: true,
            onChanged: () {
              if (txtPasswordNew.text.isNotEmpty)
                setState(() {
                  showVisibilityNew = true;
                });
              else
                setState(() {
                  showVisibilityNew = false;
                });
            },
            callback: () {
              setState(() {
                statusVisibilityNew = !statusVisibilityNew;
              });
            },
          ),
          const SizedBox(height: 50),
          Center(
            child: InkWell(
              onTap: () {
                final form = _formKey.currentState;
                if (form!.validate()) {
                  form.save();
                  submitChangePassword();
                }
              },
              child: Container(
                height: 40,
                width: 170,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFED6B2D),
                  borderRadius: BorderRadius.circular(73),
                ),
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    TextEditingController? model,
    String? hintText,
    bool enabled = true,
    bool isPassword = false,
    bool showVisibility = false,
    bool visibility = true,
    String labelText = "",
    Function? callback,
    Function? onChanged,
  }) {
    return TextFormField(
      inputFormatters: [
        // FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9.@_]')),
        FilteringTextInputFormatter.deny(RegExp(r'\s'))
      ],
      // keyboardType: TextInputType.number,
      obscureText: isPassword ? visibility : false,
      controller: model,
      onChanged: (String value) {
        onChanged!();
      },
      validator: (model) {
        String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}$';
        RegExp regex = RegExp(pattern);

        if (model!.isEmpty) {
          return 'กรุณากรอก$labelText.';
        }

        if (labelText == 'รหัสผ่านใหม่') {
          if (!regex.hasMatch(model)) {
            return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
          }
        }
        return null;
      },
      enabled: enabled,
      cursorColor: const Color(0xFF2D9CED),
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontFamily: 'Kanit',
        fontSize: 13,
        color: Color(0xFF2D9CED),
      ),
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                splashColor: Colors.transparent,
                color: const Color(0xFF1B6CA8),
                iconSize: 20,
                icon: visibility
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
                onPressed: () {
                  callback!();
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        hintText: '',
        labelText: labelText,
        labelStyle: const TextStyle(
          fontFamily: 'Kanit',
          fontSize: 13,
          color: Color(0x802D9CED),
        ),
        border: OutlineInputBorder(
          // borderSide: BorderSide(
          //   width: 1,
          //   color: Colors.yellow,
          // ),
          borderRadius: BorderRadius.circular(28.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFF216DA6),
          ),
          borderRadius: BorderRadius.circular(28.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Color(0xFF216DA6),
          ),
          borderRadius: BorderRadius.circular(28.5),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(28.5),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'Kanit',
          fontSize: 13,
        ),
      ),
    );
  }
  //
}
