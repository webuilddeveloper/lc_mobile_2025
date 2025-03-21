import 'package:flutter/material.dart';
import 'package:lc/pages/lawyer/lawyer_list.dart';
import 'package:lc/pages/voluntee_lawyer/check_in.dart';
import 'package:lc/pages/voluntee_lawyer/check_out.dart';
import 'package:lc/pages/voluntee_lawyer/voluntee_lawyer_from.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../pages/tracking/tracking_signature_page.dart';

buildModalVolunteeLawyer(
  BuildContext context,
  Future<dynamic> _futureProfile,
  String title,
  bool hasCheckIn,
  bool hasCheckOut,
  String page,
) {
  print('hasCheckIn : ${hasCheckIn}');
  print('hasCheckOut : ${hasCheckOut}');
  return showCupertinoModalBottomSheet(
      context: context,
      barrierColor: Colors.white.withOpacity(0.4),
      backgroundColor: Colors.white.withOpacity(0.4),
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: new Container(
            height: 300,
            width: double.infinity,
            margin: EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0.75, 0),
                    color: Colors.grey.withOpacity(0.4),
                  )
                ]),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          title,
                          style:
                              TextStyle(fontSize: 20, color: Color(0xFF011895)),
                        ),
                      ),
                      SizedBox(height: 37),
                      // if (!hasCheckOut)
                      //   GestureDetector(
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => hasCheckIn
                      //               ? CheckOutPage()
                      //               : CheckInPage(page: page),
                      //         ),
                      //       );
                      //     },
                      //     child: Container(
                      //       height: 30,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             hasCheckIn
                      //                 ? 'เช็คเอาท์ทนายอาสา'
                      //                 : 'เช็คอินทนายอาสา',
                      //             style: TextStyle(
                      //               fontSize: 17,
                      //             ),
                      //           ),
                      //           Image.asset(
                      //             'assets/images/box_arrow_right.png',
                      //             height: 30,
                      //             width: 30,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // if (hasCheckIn && !hasCheckOut) SizedBox(height: 20),
                      // if (hasCheckIn && !hasCheckOut)
                      //   GestureDetector(
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => VolunteeLawyerFrom(),
                      //         ),
                      //       );
                      //     },
                      //     child: Container(
                      //       height: 40,
                      //       width: double.infinity,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             'บันทึกงานทนายอาสา',
                      //             style: TextStyle(
                      //               fontSize: 17,
                      //             ),
                      //           ),
                      //           Image.asset(
                      //             'assets/images/box_arrow_right.png',
                      //             height: 30,
                      //             width: 30,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // if (hasCheckIn && !hasCheckOut) SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LawyerList(model: _futureProfile),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'โปรไฟล์ของฉัน',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                              Image.asset(
                                'assets/images/box_arrow_right.png',
                                height: 30,
                                width: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackingSignaturePage(),
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ติดตามสถานะ ทนายความรับรองลายมือชื่อ',
                                style: TextStyle(
                                    // fontSize: 17,
                                    ),
                              ),
                              Image.asset(
                                'assets/images/box_arrow_right.png',
                                height: 30,
                                width: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF28A34),
                      ),
                      child: Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
