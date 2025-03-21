import 'package:flutter/material.dart';
import 'package:lc/pages/cremation/cremation_main.dart';
import 'package:lc/shared/extension.dart';

import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';

class CremationPayConfirmForm extends StatefulWidget {
  const CremationPayConfirmForm({Key? key, this.model}) : super(key: key);
  final dynamic model;

  @override
  State<CremationPayConfirmForm> createState() =>
      _CremationPayConfirmFormState();
}

class _CremationPayConfirmFormState extends State<CremationPayConfirmForm> {
  final txtCremation_no = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height + 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg_pay_confirm.png"),
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top + 70),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.bottomCenter,
                        child: _buildCard(),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 30.0,
                      height: 30.0,
                      margin: EdgeInsets.only(top: 40, left: 15, bottom: 100),
                      // padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          'assets/images/cremation_back.png',
                          // color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, left: 70, bottom: 100),
                      child: Text(
                        "ตรวจสอบข้อมูล",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFFFFFF)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                if (_loading)
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: CircularProgressIndicator(
                        color: Color(0xFFED6B2D),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtCremation_no.dispose();

    super.dispose();
  }

  Future<dynamic> _dialogStatus() async {
    double deviceHeight = MediaQuery.of(context).size.height;
    String title = 'ขอบคุณที่ชำระเงินสงเคราะห์';
    String subTitle1 =
        'ระบบจะมีการอัพเดตข้อมูลภายใน 15 วันทำการ หลังจากที่เจ้าหน้าที่ได้รับข้อมูลแล้ว';
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CustomAlertDialog(
            // contentPadding: EdgeInsets.all(0),
            content: Container(
              width: MediaQuery.of(context).size.height / 100 * 30,
              height: (deviceHeight >= 500 && deviceHeight < 800)
                  ? 210
                  : (deviceHeight >= 800)
                      ? 210
                      : deviceHeight * 0.2,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF011895),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      subTitle1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    // Text(
                    //   subTitle2,
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     fontFamily: 'Kanit',
                    //   ),
                    // ),
                    SizedBox(height: 25),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CremationMainForm(title: '',),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        width: MediaQuery.of(context).size.height / 100 * 17,
                        height: 40,
                        alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17.5),
                          color: Color(0xFFED6B2D),
                        ),
                        child: Text(
                          'ตกลง',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Kanit',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // child: //Contents here
            ),
          ),
        );
      },
    );
  }

  _buildCard() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        '${widget.model['imageUrl']}' != '' ? 0.0 : 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black12),
                    height: 70,
                    width: 70,
                    child: GestureDetector(
                      // onTap: () => widget.nav(),
                      child: widget.model['imageUrl'] != '' &&
                              widget.model['imageUrl'] != null
                          ? CircleAvatar(
                              backgroundColor: Colors.black,
                              backgroundImage: widget.model['imageUrl'] != null
                                  ? NetworkImage(widget.model['imageUrl'])
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
                  Column(
                    children: [
                      Container(
                        width: (width * 50) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          '${widget.model['name']}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D9CED),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: (width * 50) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'จ่ายเงินสงเคราะห์ล่วงหน้า',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: (width * 15) / 100,
                            // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              'จำนวน : ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF707070),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            width: (width * 35) / 100,
                            // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                              '${widget.model['payPrice']} บาท',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF011895),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: height * 25 / 100,
                        width: (width * 40) / 100,
                        child: Image.network(
                          widget.model['payImageUrl'],
                          width: (width * 40) / 100,
                          height: height * 25 / 100,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Image.asset('assets/images/arrow_down.png'),
        ),
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFFFFFF),
          ),
          // width: double.infinity,
          // margin: EdgeInsets.only(top: 190.0, left: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 1 / 100),
                      image: DecorationImage(
                        image: AssetImage("assets/images/icon_bank.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    height: height * 7 / 100,
                    width: height * 7 / 100,
                  ),
                  Column(
                    children: [
                      Container(
                        width: (width * 60) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          '948-0-17901-0',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D9CED),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: (width * 60) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'ชื่อบัญชี : สภาทนายความ ในพระบรมราชูปถัมภ์ (การฌาปนกิจ) สะพานใหม่ ดอนเมือง',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                      Container(
                        width: (width * 60) / 100,
                        // padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'ธนาคาร ธ.กรุงเทพ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF707070),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(25.0),
              color: Color(0xFFF58A33),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                height: 40,
                onPressed: () {
                  _savePay();
                },
                child: new Text(
                  'ยืนยัน',
                  style: new TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _savePay() async {
    setState(() {
      _loading = true;
    });
    final result = await postDio(server + 'cremation/payhistory/create', {
      'title': 'ชำระเงินสงเคราะห์',
      'profileCode': widget.model['profileCode'],
      'cremation_no': widget.model['cremation_no'],
      'membercategory': widget.model['membercategory'],
      'name': widget.model['name'],
      'idcard': widget.model['idcard'],
      'payPrice': widget.model['payPrice'],
      'payImageUrl': widget.model['payImageUrl'],
    });

    if (result != '' && result != null) {
      setState(() {
        _loading = false;
      });
      logWTF(result);
      _dialogStatus();
    }
  }
}
