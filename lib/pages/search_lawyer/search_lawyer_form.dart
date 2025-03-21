import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/teacher/check_certificate_teacher.dart';
import 'package:lc/component/teacher/text_header.dart';
import 'package:lc/component/teacher/text_row.dart';
import 'package:lc/pages/poll/poll_list_vertical.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchLawyerForm extends StatefulWidget {
  const SearchLawyerForm({super.key, this.model, this.lcCategory = false});

  final dynamic model;
  final storage = const FlutterSecureStorage();
  final bool lcCategory;

  @override
  // ignore: library_private_types_in_public_api
  _SearchLawyerForm createState() => _SearchLawyerForm();
}

class _SearchLawyerForm extends State<SearchLawyerForm> {
  late PollListVertical poll;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;
  String selectedType = '0';

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
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
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      footer: const ClassicFooter(
        loadingText: ' ',
        canLoadingText: ' ',
        idleText: ' ',
        idleIcon: Icon(
          Icons.arrow_upward,
          color: Colors.transparent,
        ),
      ),
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView(
        children: [
          Container(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 30.0,
                        height: 30.0,
                        margin: const EdgeInsets.only(left: 15, bottom: 100),
                        // padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Image.asset(
                            'assets/images/back_professional_license.png',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          // onTap: () => widget.nav(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                padding: EdgeInsets.all(
                                    '${model['imageUrl']}' != '' ? 0.0 : 5.0),
                                margin:
                                    const EdgeInsets.only(top: 20, left: 95),
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
                                          backgroundImage: model['imageUrl'] !=
                                                  null
                                              ? NetworkImage(model['imageUrl'])
                                              : null,
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.asset(
                                            'assets/images/user_not_found.png',
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(right: 30),
                                child: Center(
                                  child: Text(
                                    '${model['title_t']} ${model['fname_t']} ${model['lname_t']}',
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
                              ),
                              Container(
                                // margin: EdgeInsets.only(left: 120),
                                padding: const EdgeInsets.only(
                                  right: 20,
                                ),
                                child: Center(
                                  child: Text(
                                    widget.lcCategory == true
                                        ? ''
                                        : 'เลขหมายใบอนุญาตให้เป็นทนายความ ${model['com_no']}',
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: widget.lcCategory == true
                  ? _standardForm(model: model)
                  : _lawyerForm(model: model)),
        ],
      ),
    );
  }

  _lawyerForm({dynamic model}) {
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
              textHeader(context, title: 'ข้อมูลส่วนบุคคล'),
              textRow(
                context,
                title: 'ชื่อ - สกุล:',
                value:
                    '${model['title_t']} ${model['fname_t']} ${model['lname_t']}',
              ),
              textRow(
                context,
                title: 'ตำแหน่ง:',
                value: '${model['category']}',
              ),
              textRow(
                context,
                title: 'ความถนัน:',
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
              textRow(context, title: 'ประเภทใบประกอบวิชาชีพ:', value: '-'),
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
              textHeader(context, title: 'ข้อมูลติดต่อ'),
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
      ],
    );
  }

  _standardForm({dynamic model}) {
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
              textHeader(context, title: 'ข้อมูลส่วนบุคคล'),
              textRow(
                context,
                title: 'ชื่อ - สกุล:',
                value:
                    '${model['title_t']} ${model['fname_t']} ${model['lname_t']}',
              ),
              textRow(
                context,
                title: 'ตำแหน่ง:',
                value: '${model['category']}',
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Container(
          // width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          child: Column(
            children: [
              textHeader(context, title: 'ข้อมูลติดต่อ'),
              textRow(
                context,
                title: 'ชื่อสำนักงาน:',
                value: '${model['office_t']}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
