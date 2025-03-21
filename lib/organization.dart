import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v3/widget/header_v3.dart';
import 'package:lc/widget/header_v2.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrganizationPageState createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  late Future<dynamic> futureModel;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  _callRead() {
    futureModel = postDio('${server}m/V2/register/organization/read', {});
  }

  void goBack() async {
    Navigator.pop(context, true);
  }

  _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerV3(context, goBack, title: 'ประเภทสมาชิก'),
      body: _buildListView(),
    );
  }

  _buildListView() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12),
      child: ListView(
        shrinkWrap: true, // use it
        children: [
          // _buildOrganization(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: _widgetTextTitileHeader(title: 'สถานะสมาชิก'),
          ),
          _buildDataApi(),
        ],
      ),
    );
  }

  _buildDataApi() {
    return FutureBuilder<dynamic>(
        future: futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true, // use it
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFEEEEEE),
                        border: Border.all(color: const Color(0xFFEEEEEE))),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _widgetTextTitileHeader(
                                  title: '${snapshot.data[index]['titleLv0']}'),
                              _widgetTextTitileDetail(
                                  title:
                                      '${snapshot.data[index]['titleLv1']} ${snapshot.data[index]['titleLv2']}  ${snapshot.data[index]['titleLv3']} ${snapshot.data[index]['titleLv4']}'),
                              Row(
                                children: [
                                  Icon(Icons.circle,
                                      color: Color(
                                          snapshot.data[index]['colorId'])),
                                  _widgetTextTitileStatus(
                                      status:
                                          '${snapshot.data[index]['status']}',
                                      color: snapshot.data[index]['colorId']),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Column(
                        //   children: [
                        //     InkWell(
                        //       onTap: () async {
                        //         dialog(context,
                        //             title: 'ท่านต้องการยกเลิกประเภทสมาชิก?',
                        //             description:
                        //                 'เมื่อทำการยกเลิกแล้ว ท่านต้อง \nเลือกประเภทสมาชิกใหม่ ท่านแน่ใจใช่หรือไม่',
                        //             isYesNo: true, callBack: () async {
                        //           await postDio(
                        //               '${server}m/v2/register/organization/delete',
                        //               {
                        //                 'lv0': snapshot.data[index]['lv0'],
                        //                 'lv1': snapshot.data[index]['lv1'],
                        //                 'lv2': snapshot.data[index]['lv2'],
                        //                 'lv3': snapshot.data[index]['lv3'],
                        //                 'lv4': snapshot.data[index]['lv4'],
                        //               });

                        //           setState(() {
                        //             _callRead();
                        //           });
                        //         });
                        //       },
                        //       child: Icon(
                        //         Icons.cancel,
                        //         color: Color(0xFFFF7514),
                        //         size: 40,
                        //       ),
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                color: Colors.white,
                child: dialogFail(context, reloadApp: true),
              ),
            );
          } else {
            return Center(
              child: Container(),
            );
          }
        });
  }

  _widgetTextTitileHeader({required String title}) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }

  _widgetTextTitileDetail({required String title}) {
    return Text(
      title,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 14,
      ),
    );
  }

  _widgetTextTitileStatus({required String status, required int color}) {
    return Text(
      status,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 15, color: Color(color)),
    );
  }
}
