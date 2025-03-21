import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrivilegeSpecialComingSoon extends StatefulWidget {
  PrivilegeSpecialComingSoon({
    Key? key,
  }) : super(key: key);

  @override
  _PrivilegeSpecialComingSoonState createState() =>
      _PrivilegeSpecialComingSoonState();
}

class _PrivilegeSpecialComingSoonState
    extends State<PrivilegeSpecialComingSoon> {
  _PrivilegeSpecialComingSoonState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/bg_privilege_special_coming_soon.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.only(right: 15, left: 15, top: 30),
          child: Column(
            children: [
              InkWell(
                onTap: () => {
                  Navigator.pop(context),
                },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/back_privilege_special_coming_soon.png",
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 90),
              _buildCard(),
            ],
          ),
        ),
      ),
    );
  }

  _buildCard() {
    return Container(
      child: Card(
          color: Color(0xBFFFFFFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 22),
                Image.asset(
                  "assets/images/icon_privilege_special_coming_soon.png",
                  height: 253,
                  width: 238,
                ),
                SizedBox(height: 21),
                Text(
                  'ขออภัย',
                  style: TextStyle(
                    color: Color(0xFF011895),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'อยู่ในระหว่างเชื่อมต่อกับระบบของสภาทนายความฯ',
                  style: TextStyle(
                    color: Color(0xFF707070),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 65),
              ],
            ),
          )),
    );
  }
  //
}
