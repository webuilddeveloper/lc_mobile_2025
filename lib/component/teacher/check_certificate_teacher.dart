import 'package:flutter/material.dart';

checkCertificateTeacher(dynamic model) {
  // int codeC = int.parse(model['certificateColor']);
  // Color color = Color(codeC);
  // String statusName = model['certificateStatusName'];

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: const Color(0xFF408C40),
    ),
    child: const Text(
      'มีใบประกอบวิชาชีพ',
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Kanit',
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}
