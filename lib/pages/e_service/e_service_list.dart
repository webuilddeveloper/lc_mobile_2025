import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lc/pages/poll/poll_list_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v3/apply_exam_v3/apply_exam_list_v3.dart';
import 'package:lc/v3/reporter_v3/reporter_list_category_v3.dart';
import 'package:lc/v3/training_v3/training_main_v3.dart';
import 'package:lc/v4/widget/header_v4.dart';

class EserviceList extends StatefulWidget {
  const EserviceList({
    super.key,
    required this.title,
    this.isCategory = false,
  });

  final String title;
  final bool isCategory;

  @override
  // ignore: library_private_types_in_public_api
  _EserviceList createState() => _EserviceList();
}

class _EserviceList extends State<EserviceList> {
  final storage = const FlutterSecureStorage();
  late PollListVertical poll;
  bool hideSearch = true;
  late String keySearch;
  late String category;
  late String profileCode;
  late String reference;

  bool hasCheckIn = false;
  bool hasCheckOut = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: headerV4(context, () {
          Navigator.pop(context);
        }, title: widget.title),
        body: Column(
          children: [
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: const Text(
                      'โปรดเลือกบริการ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Color(0xFF2D9CED),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplyExamListV3(
                          title: 'สมัครสอบ',
                          isCategory: widget.isCategory,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 10),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/applyExam.png"),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              height: 100,
                              width: 100,
                            ),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(right: 20, top: 10),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 15, right: 15, bottom: 10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: Color(0xFFFFFFFF),
                                ),
                                width: 100,
                                height: 100,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'สมัครสอบ',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D9CED),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ท่านสามารถสมัครสอบต่างๆ เกี่ยวกับทนายความได้แล้ว',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 13.0,
                                        color: Color(0xFF707070),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrainingMainV3(
                          title: 'อบรม',
                          isCategory: widget.isCategory,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 10),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/train.png"),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              height: 100,
                              width: 100,
                            ),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(right: 20, top: 10),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 15, right: 15, bottom: 10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: Color(0xFFFFFFFF),
                                ),
                                width: 100,
                                height: 100,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'อบรม',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D9CED),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ท่านสามารถหาโครงการอบรมที่เหมาะสมกับท่านได้แล้ว',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 13.0,
                                        color: Color(0xFF707070),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReporterListCategoryV3(
                          title: 'ร้องเรียนแจ้งเหตุ',
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 10),
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/report.png"),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                              ),
                              height: 100,
                              width: 100,
                            ),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.only(right: 20, top: 10),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 15, right: 15, bottom: 10),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: Color(0xFFFFFFFF),
                                ),
                                width: 100,
                                height: 100,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ร้องเรียนแจ้งเหตุ',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D9CED),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ท่านสามารถแจ้งเหตุที่ท่านพบเจอกับสภาทนายความได้เลยที่บริการนี้',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Kanit',
                                        fontSize: 13.0,
                                        color: Color(0xFF707070),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    _readCheckIn();
  }

  _readCheckIn() async {
    // read checkIn
    var now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    var dateString = DateFormat('yyyyMMdd').format(date).toString();
    reference = '$profileCode-${dateString}070000';
    // reference = "20210216111726-103-860-20220817070000";
    var resCheckIn = await postDio(
        '${server}m/v2/volunteeLawyer/checkIn/read', {
      "reference": '$profileCode-${dateString}070000',
      "profileCode": profileCode
    });
    if (resCheckIn != null) {
      if (resCheckIn.length > 0) {
        setState(() {
          if (resCheckIn.length > 1) {
            hasCheckOut = true;
          }
          hasCheckIn = true;
        });
      }
    }
  }
}
