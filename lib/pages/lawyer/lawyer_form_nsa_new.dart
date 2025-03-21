import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/teacher/text_header.dart';
import 'package:lc/component/teacher/text_row.dart';
import 'package:lc/pages/poll/poll_list_vertical.dart';

import '../profile/user_information_v2.dart';

class LawyerFormNsaNew extends StatefulWidget {
  const LawyerFormNsaNew({super.key, this.model});

  final dynamic model;
  final storage = const FlutterSecureStorage();

  @override
  // ignore: library_private_types_in_public_api
  _LawyerFormNsaNew createState() => _LawyerFormNsaNew();
}

class _LawyerFormNsaNew extends State<LawyerFormNsaNew> {
  late PollListVertical poll;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  String selectedType = '0';

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
    super.initState();
  }

  void goBack() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    // );
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
        backgroundColor: const Color(0xFFF7F7F7),
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowIndicator();
              return false;
            },
            child: card(context, widget.model)),
      ),
    );
  }

  card(BuildContext context, dynamic model) {
    // print('-----$model-----');
    bool lcCategory = model['lcCategory'] == "1" ? true : false;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 25),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/background/background_lawyer.png"),
                  fit: BoxFit.cover,
                ),
              ),
              height: 248,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    // padding: EdgeInsets.all(
                    //     '${model['imageUrl']}' != '' ? 0.0 : 5.0),
                    // margin: EdgeInsets.only(top: 20, left: 95),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black12),
                    height: 100,
                    width: 100,
                    child: GestureDetector(
                      // onTap: () => widget.nav(),
                      child:
                          model['imageUrl'] != '' && model['imageUrl'] != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage: model['imageUrl'] != null
                                      ? NetworkImage(model['imageUrl'])
                                      : null,
                                )
                              : Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/images/user_not_found.png',
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    // padding: EdgeInsets.only(right: 30),
                    child: Text(
                      model['prefixName'] +
                          ' ' +
                          model['fname_t'] +
                          ' ' +
                          model['lname_t'],
                      // '${model['prefixName']} ${model['fname_t']} ${model['lname_t']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit',
                      ),
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    // margin: EdgeInsets.only(left: 120),
                    alignment: Alignment.center,
                    child: Text(
                      'ทนายความผู้ทำคำรับรองลายมือและเอกสาร ${model['com_no']}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                      ),
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xFFED6B2D),
                    ),
                    width: 183,
                    height: 35,
                    child: const InkWell(
                        // onTap: () => widget.nav(),
                        child: Text(
                      'ขั้นตอนการต่อใบอนุญาต',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                      ),
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ],
              ),
            ),
            Container(
              width: 30.0,
              height: 30.0,
              margin: const EdgeInsets.only(top: 50, left: 15, bottom: 100),
              // padding: EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/images/back_professional_license.png',
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 0,
              child: Container(
                margin: const EdgeInsets.only(bottom: 100, right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFB5B5B5),
                ),
                padding: const EdgeInsets.all(4.0),
                width: 33,
                height: 33,
                child: InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserInformationPageV2(lcCategory: lcCategory),
                    ),
                  ),
                  child: Image.asset(
                    "assets/logo/icons/Group488.png",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: _lawyerFormNsaNew(model: model),
        ),
      ],
    );
  }

  _lawyerFormNsaNew({dynamic model}) {
    return Column(
      children: [
        Container(
          // width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          child: Column(
            children: [
              textHeader(context,
                  title: 'เลขหมายใบอนุญาตให้เป็นทนายความ ${model['com_no']}',
                  color: const Color(0xFF011895)),
              textHeader(context,
                  title: 'เลขประจำตัวประชาชน ${model['idcard']}',
                  color: const Color(0xFF011895)),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        '${model['imageUrl']}',
                        fit: BoxFit.cover,
                        height: 130,
                        // width: 100,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        textRow2(
                          context,
                          title: 'ชื่อ:',
                          value:
                              '${model['prefixName']}  ${model['fname_t']} ${model['lname_t']}',
                        ),
                        textRow2(
                          context,
                          title: 'เกิด:',
                          value: '${model['birthdate']}',
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 30.0,
                                child: Text(
                                  'ที่อยู่',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  // maxLines: 2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  model['haddr_t'] != '' &&
                                          model['haddr_t'] != null
                                      ? model['haddr_t']
                                      : '-',
                                  style: const TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  // maxLines: 5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    width: 100.0,
                    child: const Text(
                      'ลายมือชื่อ',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                      // maxLines: 2,
                    ),
                  ),
                  // SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 35),
                        child: const Text(
                          '(ดร.วิเชียร ชุบไธสง)',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          // maxLines: 5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 35),
                        child: const Text(
                          'นายกสภาทนายความ',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          // maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        Container(
          // width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          child: Column(
            children: [
              const Text(
                'บัตรประจำตัวสมาชิกสภาทนายความ',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF011895),
                ),
              ),
              const Text(
                'ประเภท 2 ปี',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF011895),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 100.0,
                    child: Text(
                      'ชื่อสำนักงาน',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${model['office_t']}',
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                      // maxLines: 2,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 100.0,
                    child: Text(
                      'เลขที่',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        '${model['oaddr_t']}',
                        style: const TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        // maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 35),
                        child: Text(
                          '${model['registerdate']}',
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          // maxLines: 5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 35),
                        child: const Text(
                          'วันที่ออกบัตร',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          // maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 35),
                        child: Text(
                          '${model['expiredate']}',
                          style: const TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          // maxLines: 5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 35),
                        child: const Text(
                          'วันที่หมดอายุ',
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                          // maxLines: 5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(right: 35),
                      child: const Text(
                        '(ดร.วิเชียร ชุบไธสง)',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        // maxLines: 5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 35),
                      child: const Text(
                        'นายกสภาทนายความ',
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        // maxLines: 5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
