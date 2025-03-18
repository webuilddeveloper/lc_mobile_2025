import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/lawyer/lawyer_candidate_information_from_vertical.dart';
import 'package:lc/shared/api_provider.dart';

class LawyerCandidateInformationFrom extends StatefulWidget {
  LawyerCandidateInformationFrom({
    Key key,
    this.code,
  }) : super(key: key);

  final String code;
  final storage = new FlutterSecureStorage();

  @override
  _LawyerCandidateInformationFrom createState() =>
      _LawyerCandidateInformationFrom();
}

class _LawyerCandidateInformationFrom
    extends State<LawyerCandidateInformationFrom> {
  String keySearch;
  String category;
  Future<dynamic> futureModel;
  ScrollController scrollController = new ScrollController();
  ScrollController scrollController2 = new ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.s
    super.dispose();
  }

  @override
  void initState() {
    futureModel = postDio(employeeDetailElectionLcApi, {'code': widget.code});
    super.initState();
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
        backgroundColor: Color(0xFFF7F7F7),
        body: Column(
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 15,
                  right: 15,
                  // bottom: 20,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo/icons/backLeft.png',
                      height: 25,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'ข้อมูลผู้สมัคร',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                      ),
                      // maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: futureBuilder(),
            ),
          ],
        ),
      ),
    );
  }

  futureBuilder() {
    return FutureBuilder<dynamic>(
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // data from refresh api
        if (snapshot.hasData) {
          return card(context, snapshot.data);
        } else if (snapshot.hasError) {
          return BlankLoading();
        } else {
          return BlankLoading();
        }
      },
    );
  }

  card(BuildContext context, dynamic model) {
    return ListView(
      controller: scrollController,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Text(
              '${model['prefixName']} ${model['firstName']} ${model['lastName']}',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFF2D9CED),
              ),
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'หมายเลข ${model['numberCandidate']}',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w400,
              ),
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 190),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  model['imageUrl'],
                  height: 345,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 50,
              right: 50,
              child: Container(
                height: 260,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.88),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView(
                  controller: scrollController2,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    Text(
                      'ข้อมูลพื้นฐาน',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'ผู้สมัคร${model['position']}',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    textFrom('ข้อมูลพื้นฐาน',
                        '${model['prefixName']} ${model['firstName']} ${model['lastName']}'),
                    textFrom('อายุ', model['age']),
                    textFrom(
                      'ที่อยู่',
                      'ที่อยู่',
                      address: '${model['address']}',
                      moo: '${model['moo']}',
                      soi: '${model['soi']}',
                      road: '${model['road']}',
                      tambonCode: '${model['tambonCode']}',
                      amphoeCode: '${model['amphoeCode']}',
                      provinceCode: '${model['provinceCode']}',
                      postnoCode: '${model['postnoCode']}',
                    ),
                    textFrom('คติประจำใจ', model['motto']),
                    textFrom('การศึกษา', model['learning']),
                    textFrom('ประวัติการทำงาน', model['experience']),
                    textFrom('ชื่อสำนักงาน', model['officeName']),
                    textFrom('ที่อยู่สำนักงาน', model['officeAddress']),
                    textFrom('อีเมล', model['email']),
                    textFrom('เกี่ยวกับทีมผู้สมัคร', model['aboutTeam']),
                    textFrom(
                        'ปัญหาที่ควรได้รับการแก้ไข', model['problemFixed']),
                    textFrom('นโยบายทีม', model['policyTeam']),
                    textFrom('ตารางลงพื้นที่หาเสียง', model['campaignTable']),
                    textFrom(
                        'ช่องทางการติดต่ออื่น ๆ ของทีม', model['otherTeam']),
                  ],
                ),
              ),
            )
          ],
        ),
        model['employee'].length > 0
            ? column(model['employee'], model['affiliation'])
            : Container(),
        SizedBox(height: 30),
      ],
    );
  }

  column(model, affiliation) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              affiliation,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        LawyerCandidateInformationFromVertical(
          model: model,
        ),
      ],
    );
  }

  textFrom(
    String title1,
    String title2, {
    address,
    moo,
    soi,
    road,
    tambonCode,
    amphoeCode,
    provinceCode,
    postnoCode,
  }) {
    return title2 != ''
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                title1,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              title1 == 'ที่อยู่'
                  ? rowTextFromAddress(
                      address: address,
                      moo: moo,
                      soi: soi,
                      road: road,
                      tambonCode: tambonCode,
                      amphoeCode: amphoeCode,
                      provinceCode: provinceCode,
                      postnoCode: postnoCode,
                    )
                  : Text(
                      title2,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
            ],
          )
        : Container();
  }

  rowTextFromAddress({
    address,
    moo,
    soi,
    road,
    tambonCode,
    amphoeCode,
    provinceCode,
    postnoCode,
  }) {
    return Wrap(
      children: [
        address != ''
            ? Text(
                address,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
        moo != ''
            ? Text(
                ' หมู่ที่ ${moo}',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
        soi != ''
            ? Text(
                ' ซอย ${soi}',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
        road != ''
            ? Text(
                ' ถนน ${road}',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
        tambonCode != ''
            ? Text(
                ' ตำบล ${tambonCode}',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
        amphoeCode != ''
            ? Text(
                ' อำเภอ ${amphoeCode}',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
        provinceCode != ''
            ? Text(
                ' จังหวัด ${provinceCode}',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
        postnoCode != ''
            ? Text(
                ' ${postnoCode}',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              )
            : Container(),
        // ${model['address']} ${model['moo']} ${model['soi']} ${model['road']} ${model['tambonCode']} ${model['amphoeCode']} ${model['provinceCode']} ${model['postnoCode']}
      ],
    );
  }
  //
}
