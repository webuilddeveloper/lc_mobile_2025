// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

labelTextField(String label, Icon icon) {
  return Row(
    children: <Widget>[
      icon,
      Text(
        ' $label',
        style: TextStyle(
          fontSize: 20.000,
          fontFamily: 'Kanit',
        ),
      ),
    ],
  );
}

textField(
  TextEditingController model,
  TextEditingController modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return SizedBox(
    height: 45.0,
    child: TextField(
      // keyboardType: TextInputType.number,
      obscureText: isPassword,
      controller: model,
      enabled: enabled,
      style: TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFC5DAFC),
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

textFieldLogin({
  required TextEditingController model,
  String? hintText,
  bool enabled = true,
  bool isPassword = false,
  bool showVisibility = false,
  bool visibility = true,
  String labelText = "",
  Function? callback,
  Function? onChanged,
}) {
  return SizedBox(
    height: 40.0,
    child: TextField(
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      obscureText: isPassword ? visibility : false,
      controller: model,
      onChanged: (String value) {
        if (onChanged != null) {
          onChanged();
        }
      },
      enabled: enabled,
      cursorColor: Color(0xFF216DA6),
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
                splashColor: Colors.transparent,
                color: Color(0xFF8AD2FF),
                iconSize: 20,
                icon: visibility
                    ? Icon(Icons.visibility)
                    : Icon(Icons.visibility_off),
                onPressed: () {
                  if (callback != null) {
                    callback();
                  }
                },
              )
            : null,
        contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 5.0, 5.0),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'Kanit',
          fontSize: 13,
          color: Color(0xFF216DA6),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Color(0xFF216DA6),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Color(0xFF216DA6),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Color(0xFF216DA6),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 13.0,
        ),
      ),
    ),
  );
}
