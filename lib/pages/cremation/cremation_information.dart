import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/teacher/text_header.dart';
import 'package:lc/component/teacher/text_row.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/poll/poll_list_vertical.dart';
import 'package:lc/v3/menu_v3.dart';
import 'package:lc/v4/menu_v4.dart';

import '../../shared/extension.dart';

class CremationInformationPage extends StatefulWidget {
  CremationInformationPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  final Future<dynamic> model;

  @override
  State<CremationInformationPage> createState() =>
      _CremationInfomationPageState();
}

class _CremationInfomationPageState extends State<CremationInformationPage> {
  late PollListVertical poll;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  String selectedType = '0';
  final storage = new FlutterSecureStorage();
  String profileCode = "";
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
    // Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MenuV4(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // data from refresh api
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return card(model: snapshot.data[0]);
          } else {
            return Container();
          }
        } else if (snapshot.hasError) {
          return BlankLoading();
        } else {
          return BlankLoading();
        }
      },
    );
  }

  Widget card({dynamic model}) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF7F7F7),
        // appBar: header(context, goBack, title: widget.title),
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg_cremation_info.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 220,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            '${model['imageUrl']}' != '' ? 0.0 : 5.0),
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.black12),
                        height: 100,
                        width: 100,
                        child: GestureDetector(
                          // onTap: () => widget.nav(),
                          child: model['imageUrl'] != '' &&
                                  model['imageUrl'] != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage: model['imageUrl'] != null
                                      ? NetworkImage(model['imageUrl'])
                                      : null,
                                )
                              : Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/images/user_not_found.png',
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        // margin: EdgeInsets.only(top: 10),
                        // padding: EdgeInsets.only(left: 20),
                        child: Center(
                          child: Text(
                            '${model['name']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                            maxLines: 1,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.only(left: 120),
                        // padding: EdgeInsets.only(
                        //   left: 20,
                        // ),
                        child: Center(
                          child: Text(
                            'สมาชิกฌาปนกิจที่ ${model['cremation_no']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                            ),
                            maxLines: 1,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 30.0,
                  height: 30.0,
                  margin: EdgeInsets.only(top: 50, left: 15, bottom: 100),
                  // padding: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/back_professional_license.png',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCard(model: model),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCard({dynamic model}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          // width: double.infinity,
          // margin: EdgeInsets.only(top: 190.0, left: 15.0),
          child: Column(
            children: [
              textHeader(context, title: 'ข้อมูลส่วนบุคคล'),
              textRow(
                context,
                title: 'ชื่อ - สกุล:',
                value: '${model['name']}',
              ),
              textRow(
                context,
                title: 'หมายเลขสมาชิก:',
                value: '${model['cremation_no']}',
              ),
              textRow(
                context,
                title: 'หมายเลขประชาชน:',
                value: '${model['idcard']}',
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          // width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'ที่อยู่',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  '${model['address']}' != '' && '${model['address']}' != 'null'
                      ? '${model['address']}'
                      : '-',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Container(
          // width: double.infinity,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'หากมีข้อสงสัยกรุณาติดต่อ',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: Text(
                  'การฌาปนกิจสภาทนายความ',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                child: Text(
                  '02-522-7124 ต่อ 226,227 หรือ 083-040-8662',
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF2D9CED)),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        // SizedBox(height: 40),
      ],
    );
  }

  _callRead() async {
    var aa = await widget.model;
    logWTF(aa);
    // profileCode = await storage.read(key: 'profileCode18');
    // if (profileCode != '' && profileCode != null) {
    //   setState(() {
    //     _futureProfile = postDio(profileReadApi, {'code': profileCode});
    //   });
    // }
  }
}
