import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/teacher/text_header.dart';
import 'package:lc/component/teacher/text_row.dart';
// ignore: unused_import
import 'package:lc/menu_v2.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/lawyer/lawyer_contact.dart';
import 'package:lc/pages/lawyer/lawyer_news_form.dart';
import 'package:lc/pages/poll/poll_list_vertical.dart';
import 'package:lc/pages/profile/user_information_v2.dart';
import 'package:lc/shared/api_provider.dart';

import '../../component/teacher/check_certificate_teacher.dart';
import 'lawyer_form_nsa_new.dart';

class LawyerList extends StatefulWidget {
  const LawyerList({
    super.key,
    required this.model,
    this.selectedVote = false,
  });

  final Future<dynamic> model;
  final bool selectedVote;

  @override
  // ignore: library_private_types_in_public_api
  _LawyerList createState() => _LawyerList();
}

class _LawyerList extends State<LawyerList> {
  late PollListVertical poll;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  String selectedType = '0';
  final storage = const FlutterSecureStorage();
  late Future<dynamic> _futureNews;
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
    super.initState();

    if (widget.selectedVote == true) {
      setState(() {
        selectedType = '2';
      });
    }
    _futureNews = postDio(newsElectionLcApi, {});
  }

  void goBack() async {
    // Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    // );
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
            return card(model: snapshot.data);
          } else {
            return Container();
          }
        } else if (snapshot.hasError) {
          return const BlankLoading();
        } else {
          return const BlankLoading();
        }
      },
    );
  }

  Widget card({dynamic model}) {
    bool lcCategory = model['lcCategory'] == "1" ? true : false;
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
        // appBar: header(context, goBack, title: widget.title),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image:
                          AssetImage("assets/background/background_lawyer.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 248,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                            '${model['imageUrl']}' != '' ? 0.0 : 5.0),
                        margin: const EdgeInsets.only(top: 30),
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
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/images/user_not_found.png',
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${model['prefixName']} ${model['fname_t']} ${model['lname_t']}',
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
                      Center(
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
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFFED6B2D),
                        ),
                        width: 280,
                        height: 35,
                        child: const InkWell(
                          // onTap: () => widget.nav(),
                          child: Center(
                            child: Text(
                              'ต่อใบอนุญาต ติดต่อ nsa_lct@hotmail.com',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Kanit',
                              ),
                              // maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
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
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedType = '0';
                              });
                            },
                            child: Container(
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectedType == '0'
                                    ? const Color(0xFF1EB7D7)
                                    : const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'ใบอนุญาต',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decorationColor: selectedType == '0'
                                      ? const Color(0xFF2D9CED)
                                      : Colors.transparent,
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedType = '1';
                              });
                            },
                            child: Container(
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectedType == '1'
                                    ? const Color(0xFF1EB7D7)
                                    : const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'ข้อมูลอื่นๆ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decorationColor: selectedType == '1'
                                      ? const Color(0xFF2D9CED)
                                      : Colors.transparent,
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   flex: 1,
                        //   child: InkWell(
                        //     onTap: () {
                        //       setState(() {
                        //         selectedType = '2';
                        //       });
                        //     },
                        //     child:  Container(
                        //       height: 35,
                        //       alignment: Alignment.center,
                        //       decoration:  BoxDecoration(
                        //         color:  selectedType == '2' ? Color(0xFF1EB7D7) : Color(0xFFD9D9D9),
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //       child: Text(
                        //         'เลือกตั้ง',
                        //         style: TextStyle(
                        //           color: Colors.white,
                        //           fontFamily: 'Kanit',
                        //           fontSize: 15,
                        //           fontWeight: FontWeight.w500,
                        //           decorationColor: selectedType == '2'
                        //               ? Color(0xFF2D9CED)
                        //               : Colors.transparent,
                        //           decorationThickness: 2,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  selectedType == '0'
                      ? _tap1(model: model)
                      : selectedType == '1'
                          ? _tap2(model: model)
                          : _tap3(model: model),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tap1({dynamic model}) {
    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFFFFFFF),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LawyerFormNsaNew(model: model),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  // margin: EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xFF011895),
                  ),
                  width: 8,
                  height: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ทนายความผู้ทำคำรับรองลายมือและเอกสาร',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF011895),
                            ),
                          ),
                          Text(
                            '${model['com_no']}',
                            style: const TextStyle(
                              color: Color(0xFF011895),
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFDEEAFC),
              ),
              padding: const EdgeInsets.all(7),
              width: 33,
              height: 33,
              child: Image.asset(
                "assets/logo/icons/right.png",
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tap2({dynamic model}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          // width: double.infinity,
          // margin: EdgeInsets.only(top: 190.0, left: 15.0),
          child: Column(
            children: [
              textHeader(context, title: 'ข้อมูลส่วนบุคคล'),
              textRow(
                context,
                title: 'ชื่อ - สกุล:',
                value:
                    '${model['prefixName']}  ${model['fname_t']} ${model['lname_t']}',
              ),
              textRow(
                context,
                title: 'ตำแหน่ง:',
                value: '${model['ocategory']}',
              ),
              textRow(
                context,
                title: 'ความถนัด:',
                value: '-',
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
              textHeader(context, title: 'เกี่ยวกับใบประกอบวิชาชีพ'),
              // textRow(
              //   context,
              //   title: 'สถานะใบประกอบวิชาชีพ:',
              //   value: '-',
              // ),
              Row(
                children: [
                  const SizedBox(
                    width: 135.0,
                    child: Text(
                      'สถานะใบประกอบ วิชาชีพ:',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    child: checkCertificateTeacher(model),
                  ),
                ],
              ),
              textRow(
                context,
                title: 'ประเภทใบประกอบวิชาชีพ:',
                value: 'ใบอนุญาตก่ารว่าความ',
              ),
              textRow(
                context,
                title: 'วันออกใบอนุญาต:',
                value: '${model['registerdate']}',
              ),
              textRow(
                context,
                title: 'วันหมดอายุ:',
                value: '${model['expiredate']}',
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
              Container(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ข้อมูลติดต่อ',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LawyerContact(
                              model: model,
                              code: '',
                              url: '',
                            ),
                          ),
                        ).then((value) => {_callRead()}),
                      },
                      icon: Image.asset(
                        "assets/Vector.png",
                      ),
                    ),
                  ],
                ),
              ),
              textRow(
                context,
                title: 'อีเมล:',
                value: '${model['oemail']}',
              ),
              textRow(
                context,
                title: 'เบอร์ติดต่อ:',
                value: '${model['ophone']}',
              ),
              textRow(
                context,
                title: 'ชื่อสำนักงาน:',
                value: '${model['office_t']}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  _tap3({dynamic model}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          child: Column(
            children: [
              textHeader(context, title: 'ข้อมูลการเลือกตั้ง'),
              textRow(
                context,
                title: 'ชื่อ - สกุล:',
                value:
                    '${model['prefixName']}  ${model['fname_t']} ${model['lname_t']}',
              ),
              textRow(
                context,
                title: 'ตำแหน่ง:',
                value: '${model['ocategory']}',
              ),
              textRowGo(
                context,
                title: 'สถานที่เลือก:',
                value: 'ศาลจังหวัดนนทบุรี',
                typeBtn: 'googlemap',
                lat: '13.862206',
                lng: '100.517093',
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          child: Column(
            children: [
              textHeader(context, title: 'ข้อมูลอื่นๆ'),
              textRowButtonGo(
                context,
                title: 'ข้อมูลผู้สมัคร:',
                // typeBtn: 'pageCI',
                value: 'http://lawyerselection2565.com/#/applicant',
                typeBtn: 'link',
              ),
              textRowButtonGo(
                context,
                title: 'ติดตามผลการเลือกตั้ง:',
                // typeBtn: 'pageRVOC',
                value: 'http://lawyerselection2565.com/#/count-votes',
                typeBtn: 'link',
              ),
              textRowButtonGo(
                context,
                title: 'ติดต่อศูนย์อำนวยการเลือกตั้ง:',
                value: 'https://www.facebook.com/lawyerselection2565/',
                typeBtn: 'link',
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        FutureBuilder<dynamic>(
          future: _futureNews, // function where you call your api
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            // AsyncSnapshot<Your object type>
            // data from refresh api
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return news(snapshot.data);
              } else {
                return Container();
              }
            } else if (snapshot.hasError) {
              return const BlankLoading();
            } else {
              return const BlankLoading();
            }
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  //
  news(model) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFFFFFFF),
      ),
      child: Column(
        children: [
          textHeader(context, title: 'ข่าวสารเกี่ยวกับเลือกตั้ง'),
          const SizedBox(height: 10),
          SizedBox(
            height: 85,
            width: double.infinity,
            child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                shrinkWrap: true, // 1st add
                physics: const ClampingScrollPhysics(), // 2nd
                itemCount: model.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LawyerNewsForm(
                            model: model[index],
                            code: model[index]['code'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 85,
                      width: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFF707070),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(model[index]['imageUrl']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    // print('------------------------$profileCode----------------------');
    if (profileCode != '' && profileCode != null) {
      setState(() {});
    }
  }
}
