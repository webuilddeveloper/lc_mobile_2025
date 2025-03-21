import 'package:flutter/material.dart';
import '../../menu_v2.dart';

class ChangePasswordSuccessPage extends StatefulWidget {
  @override
  _ChangePasswordSuccessState createState() => _ChangePasswordSuccessState();
}

class _ChangePasswordSuccessState extends State<ChangePasswordSuccessPage> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  void goHome() async {
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: header(context, goBack, title: 'เปลี่ยนรหัสผ่าน'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(right: 15, left: 15, top: 30),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'เปลี่ยนรหัสผ่านสำเร็จ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF00C75B),
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Container(
                      width: 278,
                      child: Text(
                        'เราจะยืนยันการเปลี่ยนไปในอีเมลของท่านอีกครั้งนึง ขอให้วันนี้เป็นวันที่ดี',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF707070),
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () => goHome(),
                      child: Container(
                        height: 40,
                        width: 170,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFFED6B2D),
                          borderRadius: BorderRadius.circular(73),
                        ),
                        child: Text(
                          'หน้าหลัก',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ), // _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => goHome(),
          child: Image.asset(
            "assets/images/back_arrow_v2.png",
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }

  //
}
