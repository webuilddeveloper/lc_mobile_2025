import 'package:flutter/material.dart';

InkWell backButtonTeacher(BuildContext context) {
  return InkWell(
    onTap: () => {Navigator.pop(context)},
    child: Image.asset(
      'assets/logo/icons/arrow_left.png',
      width: 30,
    ),
  );
}
