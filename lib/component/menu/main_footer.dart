import 'package:flutter/material.dart';
import 'package:lc/component/material/button_center.dart';
import 'package:lc/pages/profile/identity_verification.dart';

Container mainFooter({required BuildContext context, String status = ''}) {
  return Container(
    height: 120,
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            // userData.status == 'N'
            //     ? 'ท่านยังไม่ได้ยืนยันตัวตนเป็นสมาชิก สภาทนายความ'
            //     : 'ยืนยันตัวตนแล้ว รอเจ้าหน้าที่ตรวจสอบข้อมูล',
            'ท่านยังไม่ได้ยืนยันตัวตนเป็นสมาชิก สภาทนายความ',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Kanit',
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        status == 'N'
            ? buttonCenter(
                context: context,
                backgroundColor: Theme.of(context).primaryColor,
                title: 'ยืนยันตัวตน',
                fontColor: Colors.white,
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IdentityVerificationPage(title: '',),
                    ),
                  );
                },
              )
            : Container(),
      ],
    ),
  );
}
