import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lc/component/header.dart';
import 'package:lc/pages/apply_exam/apply_exam_list.dart';

import 'package:lc/pages/lawyer/lawyer_list.dart';
import 'package:lc/pages/voluntee_lawyer/check_in.dart';
import 'package:lc/pages/voluntee_lawyer/check_out.dart';
import 'package:lc/pages/poll/poll_list_vertical.dart';
import 'package:lc/pages/reporter/reporter_infomation_form.dart';
import 'package:lc/pages/reporter/reporter_list_category.dart';
import 'package:lc/pages/training/training_main.dart';
import 'package:lc/pages/voluntee_lawyer/voluntee_lawyer_from.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../reporter/reporter_renew_form.dart';

class ReporterStatusList extends StatefulWidget {
  ReporterStatusList({Key? key, required this.title, this.isCategory = false})
      : super(key: key);

  final String title;
  final bool isCategory;

  @override
  _ReporterStatusList createState() => _ReporterStatusList();
}

class _ReporterStatusList extends State<ReporterStatusList> {
  final storage = new FlutterSecureStorage();
  late PollListVertical poll;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  late String profileCode;
  late String reference;
  int _limit = 10;

  late Future<dynamic> _futureProfile;
  late Future<dynamic> _reporterInformation;
  late Future<dynamic> _reporterRenew;

  bool hasCheckIn = false;
  bool hasCheckOut = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _controller.addListener(_scrollListener);
    _callRead();
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    // );
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;

    setState(() {
      _reporterInformation =
          postDio(reporterInformationReadApi, {'code': profileCode});
      _reporterRenew = postDio(reporterT02ReadApi, {'code': profileCode});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      _buildReporterInformation(),
                      _buildReporterRenew(),
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(35),
                    color: const Color(0xFFEEEEEE),
                    child: MaterialButton(
                      height: 30,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ReporterInfomationFormPage(
                              title: 'คำขอเปลี่ยนแปลงข้อมูล',
                              code: '',
                              imageUrl: '',
                            ),
                          ),
                        ).then((value) => _callRead());
                      },
                      child: new Text(
                        'คำขอเปลี่ยนแปลงข้อมูล',
                        style: new TextStyle(
                          fontSize: 17.0,
                          color: const Color(0XFF011895).withOpacity(0.8),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.blue[800],
                    child: MaterialButton(
                      height: 30,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReporterRenewFormPage(
                              title: 'คำขอต่ออายุทนายความผู้ทำคำรับรองฯ',
                              code: '',
                              imageUrl: '',
                            ),
                          ),
                        ).then((value) => _callRead());
                      },
                      child: new Text(
                        'ต่ออายุทนายความผู้ทำคำรับรองฯ',
                        style: new TextStyle(
                          fontSize: 17.0,
                          color: const Color(0xFFFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  _buildTest(dynamic model, String title) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 10),
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/Group6876.png"), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(15),
          ),
          height: 90,
          width: 90,
        ),
        Expanded(
          child: Container(
            // margin: EdgeInsets.only(right: 20, top: 10),
            padding: const EdgeInsets.all(20),
            height: 120,
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ส่งเมื่อวันที่ ${(model["updateDate"] ?? '').toString() != '' ? "   ${DateFormat("dd/MM/yyyy").format(DateTime.parse(model["updateDate"].substring(0, 8)))}" : ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        model['status'] == 'A'
            ? Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/logo/icons/tick.png',
                  color: Colors.blue,
                ),
              )
            : model['status'] == 'R'
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/logo/icons/close.png',
                        color: Colors.red),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/logo/icons/repeating.png',
                      color: Colors.blue,
                    ),
                  ),
      ],
    );
  }

  _buildReporterInformation() {
    return FutureBuilder<dynamic>(
      future: _reporterInformation,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true, // use it
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return _buildTest(snapshot.data[index], 'คำขอเปลี่ยนแปลงข้อมูล');
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  _buildReporterRenew() {
    return FutureBuilder<dynamic>(
      future: _reporterRenew,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true, // use it
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return _buildTest(snapshot.data[index],
                  'คำขอต่ออายุทนายความผู้ทำคำรับรองลายมือชื่อและเอกสาร');
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
