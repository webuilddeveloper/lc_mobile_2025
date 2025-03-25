// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SSOOnlineServiceHorizontal extends StatefulWidget {
  const SSOOnlineServiceHorizontal(
      {super.key, required this.title, this.model});

  final String title;
  final dynamic model;

  @override
  _SSOOnlineServiceHorizontal createState() => _SSOOnlineServiceHorizontal();
}

class _SSOOnlineServiceHorizontal extends State<SSOOnlineServiceHorizontal> {
  late Future<dynamic> _futureModel;

  @override
  void initState() {
    super.initState();
    _futureModel = post(
      '${menuApi}read',
      {'skip': 0, 'limit': 100},
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Color(0xFF9A1120),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  myCircle(
                      'ขอรับเงินทดแทน',
                      '(ว่างงานหรือชราภาพ)',
                      'assets/images/e-service-1.png',
                      snapshot.data[4]['title']),
                  myCircle(
                      'เปลี่ยนโรงพยาบาล',
                      '',
                      'assets/images/e-service-2.png',
                      snapshot.data[4]['title']),
                  myCircle(
                      'การเบิกสิทธิประโยชน์',
                      '',
                      'assets/images/e-service-3.png',
                      snapshot.data[4]['title']),
                  myCircle(
                      'สมัครเป็นผู้ประกันตน',
                      '',
                      'assets/images/e-service-4.png',
                      snapshot.data[4]['title']),
                ],
              ),
            ],
          );
        } else {
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Color(0xFF9A1120),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  myCircle('', '(ว่างงานหรือชราภาพ)', '', ''),
                  myCircle('', '', '', ''),
                  myCircle('', '', '', ''),
                  myCircle('', '', '', ''),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

Widget myCircle(
    String title, String subTitle, String image, String toastMessage) {
  return InkWell(
    onTap: () {
      Fluttertoast.showToast(
        msg: toastMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
    },
    child: Container(
      height: 110.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFFC324),
            radius: 30,
            child: Image.asset(
              image,
              width: 35,
              height: 35,
            ),
          ),
          Container(
            width: 75.0,
            margin: const EdgeInsets.only(top: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9A1120),
                fontFamily: 'Kanit',
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            child: Text(
              subTitle,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9A1120),
                fontFamily: 'Kanit',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}
