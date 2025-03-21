import 'package:flutter/material.dart';

Container textHeader(
  BuildContext context, {
  String title = '',
  double fontSize = 15.0,
  FontWeight fontWeight = FontWeight.w500,
  Color color = Colors.black,
}) {
  return Container(
    padding: const EdgeInsets.only(top: 5.0),
    child: Row(
      children: [
        Container(
          // margin: EdgeInsets.only(ri: 10),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        ),
      ],
    ),
  );
}
