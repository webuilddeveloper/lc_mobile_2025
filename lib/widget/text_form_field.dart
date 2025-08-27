// ignore_for_file: unnecessary_null_comparison, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

labelTextFormFieldPasswordOldNew(
  String label,
  bool showSubtitle, {
  bool mandatory = false,
}) {
  String title = mandatory ? '* ' : '';
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Row(
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontFamily: 'Kanit',
                    color: Colors.red,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: label,
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Text(
              //   lable,
              //   style: TextStyle(
              //     // fontSize: 15.000,
              //     fontFamily: 'Kanit',
              //     // color: Color(0xFFA9151D),
              //   ),
              // ),
              if (showSubtitle)
                const Text(
                  '(รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร)',
                  style: TextStyle(
                    fontSize: 10.00,
                    fontFamily: 'Kanit',
                    // color: Color(0xFFFF0000),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

textFormFieldPasswordOldNew(
  TextEditingController model,
  String modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return TextFormField(
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? const Color(0xFFA9151D) : const Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? const Color(0xFFEEBA33) : const Color(0xFF707070),
      contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }
      if (isPassword && model != modelMatch && modelMatch != null) {
        return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      }

      if (isPassword) {
        String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      return null;
    },
    controller: model,
    enabled: enabled,
  );
}

labelTextFormFieldPassword(String lable) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Row(
      children: <Widget>[
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                lable,
                style: const TextStyle(
                  fontSize: 15.000,
                  fontFamily: 'Kanit',
                ),
              ),
              const Text(
                '(รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร)',
                style: TextStyle(
                  fontSize: 10.00,
                  fontFamily: 'Kanit',
                  color: Color(0xFFFF0000),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

labelTextFormField(String label, {bool mandatory = false}) {
  String title = mandatory ? '* ' : '';
  return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: RichText(
        text: TextSpan(
          text: title,
          style: const TextStyle(
            fontFamily: 'Kanit',
            color: Colors.red,
          ),
          children: <TextSpan>[
            TextSpan(
              text: label,
              style: const TextStyle(
                fontFamily: 'Kanit',
                color: Colors.black,
              ),
            ),
          ],
        ),
      )
      // Text(
      //   title,
      //   style: TextStyle(
      //     fontFamily: 'Kanit',
      //   ),
      // ),
      );
}

textFormField(
  TextEditingController model,
  String modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
  bool isEmail,
  bool isUserName,
) {
  return TextFormField(
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? const Color(0xFF4A4A4A) : const Color(0xFF4A4A4A).withOpacity(0.5),
      // fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 14.00,
    ),
    inputFormatters: [
      if (isUserName || isPassword)
        FilteringTextInputFormatter.deny(RegExp(r'\s'))
    ],
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? const Color(0xFFEEEEEE) : const Color(0xFFCCBEBE),
      contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 0.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {

      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }
      // if (isPassword && model != modelMatch && modelMatch != null) {
      //   return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      // }

      if (isUserName) {
        String pattern = r'^[a-zA-Z0-9]+$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบชื่อผู้ใช้งานให้ถูกต้อง.';
        }
      }
      if (isPassword) {
        // String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}$';
        String pattern = r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{6,}$';
        RegExp regex = RegExp(pattern);
        print(!regex.hasMatch(model));
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      // return true;
    },
    controller: model,
    enabled: enabled,
  );
}

textFormFieldNoValidator(
  TextEditingController model,
  String hintText,
  bool enabled,
  bool isEmail,
) {
  return TextFormField(
    style: TextStyle(
      color: enabled ? const Color(0xFF4A4A4A) : const Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? const Color(0xFFEEEEEE) : const Color(0xFF707070),
      contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      // hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),

    validator: (model) {
      if (isEmail && model != "") {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model!)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      // return true;
    },
    controller: model,
    // enabled: enabled,
  );
}

textFormPhoneField(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
  bool isPhone,
) {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? const Color(0xFF4A4A4A) : const Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? const Color(0xFFEEEEEE) : const Color(0xFF707070),
      contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      // hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }
      if (isPhone) {
        String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบเบอร์ติดต่อให้ถูกต้อง.';
        }
      }
    },
    controller: model,
    enabled: enabled,
  );
}

textFormIdCardField(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
) {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? const Color(0xFF4A4A4A) : const Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? const Color(0xFFEEEEEE) : const Color(0xFF707070),
      contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      // hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }

      String pattern = r'(^[0-9]\d{12}$)';
      RegExp regex = RegExp(pattern);

      if (regex.hasMatch(model)) {
        if (model.length != 13) {
          return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
        } else {
          var sum = 0.0;
          for (var i = 0; i < 12; i++) {
            sum += double.parse(model[i]) * (13 - i);
          }
          if ((11 - (sum % 11)) % 10 != double.parse(model[12])) {
            return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
          } else {
            return null;
          }
        }
      } else {
        return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
      }
    },
    controller: model,
    enabled: enabled,
  );
}

textFormFieldV2(
  TextEditingController model,
  String modelMatch,
  String hintText,
  String validator,
  String labelText,
  bool enabled,
  bool isPassword,
  bool isEmail, {
  bool isPattern = false,
  TextInputType? textInputType,
}) {
  return TextFormField(
    keyboardType: textInputType,
    inputFormatters: isPattern
        ? [
            // FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@_]')),
            // new WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9@_]")),
            // TextInputFormatter.withFunction((oldValue, newValue) =>
            //     RegExp("[a-zA-Z0-9@_]").hasMatch(newValue.text)
            //         ? newValue
            //         : oldValue),
            FilteringTextInputFormatter.digitsOnly
          ]
        : null,
    obscureText: isPassword,
    cursorColor: const Color(0xFF216DA6),
    style: const TextStyle(
      color: Color(0xFF2D9CED),
      fontWeight: FontWeight.w400,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
      hintText: '',
      labelText: labelText,
      labelStyle: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 15,
        color: Color(0xFF216DA6),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 13.0,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }
      if (isPassword && model != modelMatch && modelMatch != null) {
        return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      }

      if (isPassword) {
        String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      // return true;
    },
    controller: model,
    enabled: enabled,
  );
}

textFormPhoneFieldV2(
  TextEditingController model,
  String hintText,
  String validator,
  String labelText,
  bool enabled,
  bool isPhone,
) {
  return TextFormField(
    keyboardType: TextInputType.number,
    inputFormatters: null,
    cursorColor: const Color(0xFF216DA6),
    style: const TextStyle(
      color: Color(0xFF2D9CED),
      fontWeight: FontWeight.w400,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
      hintText: '',
      labelText: labelText,
      labelStyle: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 15,
        color: Color(0xFF216DA6),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 13.0,
        color: Colors.red,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }
      if (isPhone) {
        String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบเบอร์ติดต่อให้ถูกต้อง.';
        }
      }
    },
    controller: model,
    enabled: enabled,
  );
}

textFormFieldNoValidatorV2(
  TextEditingController model,
  String hintText,
  String labelText,
  bool enabled,
  bool isEmail,
) {
  return TextFormField(
    style: const TextStyle(
      color: Color(0xFF2D9CED),
      fontWeight: FontWeight.w400,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
      hintText: '',
      labelText: labelText,
      labelStyle: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 15,
        color: Color(0xFF216DA6),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 13.0,
        color: Colors.red,
      ),
    ),

    validator: (model) {
      if (isEmail && model != "") {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model!)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      // return true;
    },
    controller: model,
    // enabled: enabled,
  );
}

textFormIdCardFieldV2(
  TextEditingController model,
  String hintText,
  String validator,
  String labelText,
  bool enabled,
) {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: const TextStyle(
      color: Color(0xFF2D9CED),
      fontWeight: FontWeight.w400,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
      hintText: '',
      labelText: labelText,
      labelStyle: const TextStyle(
        fontFamily: 'Kanit',
        fontSize: 15,
        color: Color(0xFF216DA6),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFF216DA6),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 13.0,
        color: Colors.red,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }

      String pattern = r'(^[0-9]\d{12}$)';
      RegExp regex = RegExp(pattern);

      if (regex.hasMatch(model)) {
        if (model.length != 13) {
          return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
        } else {
          var sum = 0.0;
          for (var i = 0; i < 12; i++) {
            sum += double.parse(model[i]) * (13 - i);
          }
          if ((11 - (sum % 11)) % 10 != double.parse(model[12])) {
            return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
          } else {
            return null;
          }
        }
      } else {
        return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
      }
    },
    controller: model,
    enabled: enabled,
  );
}

textFormFieldNSA(
  TextEditingController model,
  String modelMatch,
  String hintText,
  String validator,
  String label,
  bool enabled,
  bool isPassword,
  bool isEmail,
  bool isIdCard,
) {
  return TextFormField(
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? const Color(0xFF758C29) : const Color(0xFF758C29).withOpacity(0.5),
      // fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 14.00,
    ),
    inputFormatters: [
      if (isPassword) FilteringTextInputFormatter.deny(RegExp(r'\s'))
    ],
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF758C29),
      ),
      filled: true,
      fillColor: enabled ? const Color(0xFFFFFFFF) : const Color(0xFFCCBEBE),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color.fromRGBO(204, 190, 190, 1),
        fontFamily: 'Kanit',
        fontSize: 14.0,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: const BorderSide(
          color: Color(0xFF758C29),
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: const BorderSide(
          color: Color(0xFFCCBEBE),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: BorderSide(
          color: enabled ? Colors.red : const Color(0xFFCCBEBE),
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
        fontSize: 10.0,
        color: Colors.red,
        fontFamily: 'Kanit',
      ),
      // helperText: ' ',
      // errorMaxLines: 1,
    ),
    validator: (model) {
      if (!enabled) {
        return null; // Skip validation if the field is disabled
      }
      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }
      if (isPassword && model != modelMatch && modelMatch != null) {
        return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      }

      if (isIdCard) {
        String pattern = r'(^[0-9]\d{12}$)';
        RegExp regex = RegExp(pattern);

        if (regex.hasMatch(model)) {
          if (model.length != 13) {
            return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
          } else {
            var sum = 0.0;
            for (var i = 0; i < 12; i++) {
              sum += double.parse(model[i]) * (13 - i);
            }
            if ((11 - (sum % 11)) % 10 != double.parse(model[12])) {
              return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
            } else {
              return null;
            }
          }
        } else {
          return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
        }
      }
      if (isPassword) {
        // String String = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}$';
        String pattern = r'^[a-zA-Z0-9]{6,}$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      // return true;
    },
    controller: model,
    enabled: enabled,
  );
}

textFormFieldNSAPay(
  TextEditingController model,
  String modelMatch,
  String hintText,
  String validator,
  String labelText,
  bool enabled,
  bool isPassword,
  bool isEmail, {
  bool isPattern = false,
  TextInputType? textInputType,
}) {
  return TextFormField(
    keyboardType: textInputType,
    inputFormatters: isPattern
        ? [
            // FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@_]')),
            // new WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9@_]")),
            // TextInputFormatter.withFunction((oldValue, newValue) =>
            //     RegExp("[a-zA-Z0-9@_]").hasMatch(newValue.text)
            //         ? newValue
            //         : oldValue),
            FilteringTextInputFormatter.digitsOnly
          ]
        : null,
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? const Color(0xFF758C29) : const Color(0xFFCCBEBE).withOpacity(0.5),
      // fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 14.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? const Color(0xFFFFFFFF) : const Color(0xFFCCBEBE),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFFCCBEBE),
        fontFamily: 'Kanit',
        fontSize: 14.0,
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        fontFamily: 'Kanit',
        fontSize: 15,
        color: const Color(0xFF758C29).withOpacity(0.7),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: const BorderSide(
          color: Color(0xFF758C29),
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: const BorderSide(
          color: Color(0xFFCCBEBE),
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
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก$validator.';
      }
      if (isPassword && model != modelMatch && modelMatch != null) {
        return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      }
      if (isPassword) {
        // Pattern pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}$';
        String pattern = r'^[a-zA-Z0-9]{6,}$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      // return true;
    },
    controller: model,
    enabled: enabled,
  );
}

textFormFieldNSANoValidator(
  TextEditingController model,
  String modelMatch,
  String hintText,
  String label,
  bool enabled,
  bool isPassword,
  bool isEmail,
  bool isUserName,
) {
  return TextFormField(
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? const Color(0xFF758C29) : const Color(0xFF758C29).withOpacity(0.5),
      // fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 14.00,
    ),
    inputFormatters: [
      if (isUserName || isPassword)
        FilteringTextInputFormatter.deny(RegExp(r'\s'))
    ],
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF758C29),
      ),
      filled: true,
      fillColor: enabled ? const Color(0xFFFFFFFF) : const Color(0xFFCCBEBE),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Color(0xFFCCBEBE),
        fontFamily: 'Kanit',
        fontSize: 14.0,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: const BorderSide(
          color: Color(0xFF758C29),
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28.5),
        borderSide: const BorderSide(
          color: Color(0xFFCCBEBE),
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
    validator: (model) {
      if (isPassword && model != modelMatch && modelMatch != null) {
        return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      }

      if (isUserName) {
        String pattern = r'^[a-zA-Z0-9]+$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model!)) {
          return 'กรุณากรอกรูปแบบชื่อผู้ใช้งานให้ถูกต้อง.';
        }
      }
      if (isPassword) {
        // String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}$';
        String pattern = r'^[a-zA-Z0-9]{6,}$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model!)) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model!)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      // return true;
    },
    controller: model,
    enabled: enabled,
  );
}
