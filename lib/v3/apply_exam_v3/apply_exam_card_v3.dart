import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lc/pages/apply_exam/apply_exam_form.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/shared/extension.dart';

import '../../component/loadingImageNetwork.dart';

newsCardV3(BuildContext context, dynamic model) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApplyExamForm(
              code: model['code'],
              model: model,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     spreadRadius: 0,
                  //     blurRadius: 7,
                  //     offset: Offset(0, 3), // changes position of shadow
                  //   ),
                  // ],
                ),
                margin: EdgeInsets.only(bottom: 5.0),
                // height: 334,
                width: 600,
                child: Stack(
                  children: [
                    // Container(
                    //   height: 55,
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFF2D9CED),
                    //     borderRadius: new BorderRadius.only(
                    //       topLeft: const Radius.circular(5.0),
                    //       topRight: const Radius.circular(5.0),
                    //     ),
                    //   ),
                    //   padding: EdgeInsets.all(5),
                    //   alignment: Alignment.centerLeft,
                    //   child: Row(
                    //     children: [
                    //       // Column(
                    //       //   mainAxisAlignment: MainAxisAlignment.center,
                    //       //   crossAxisAlignment: CrossAxisAlignment.center,
                    //       //   children: [
                    //       //     Container(
                    //       //       margin: EdgeInsets.all(3),
                    //       //       height: 35,
                    //       //       width: 35,
                    //       //       child: CircleAvatar(
                    //       //         backgroundColor: Colors.white,
                    //       //         backgroundImage:
                    //       //             model['imageUrlCreateBy'] != null
                    //       //                 ? NetworkImage(
                    //       //                     model['imageUrlCreateBy'],
                    //       //                   )
                    //       //                 : null,
                    //       //       ),
                    //       //     ),
                    //       //   ],
                    //       // ),

                    //     ],
                    //   ),
                    // ),

                 
                    Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0x268AD2FF),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: loadingImageNetwork(
                                  model['imageUrl'],
                                  height: MediaQuery.of(context).size.width - 30,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    Positioned(
                      // bottom: 10,
                      bottom: 20,
                              left: 15,
                              right: 15,
                      child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  // height: 98,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(0, 255, 255, 255).withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                '${model['title']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                               Text(
                                      model['userList'] != null
                                          ? 'โดย ${model['userList'][0]['firstName']} ${model['userList'][0]['lastName']}'
                                          : 'โดย ${model['createBy']}',
                                      style: TextStyle(
                                        // color: Color(0xFFFFFFFF),
                                        fontSize: 13,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                     Text(
                                      'วันที่ ' +
                                          dateStringToDate(model['createDate']),
                                      style: TextStyle(
                                        // color: Color(0xFFFFFFFF),
                                        fontFamily: 'Kanit',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            
                      // Container(
                      //   color: Colors.white,
                      //   padding: EdgeInsets.all(10),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //           '${model['title']}',
                      //           maxLines: 2,
                      //           overflow: TextOverflow.ellipsis,
                      //           style: TextStyle(
                      //             fontFamily: 'Kanit',
                      //             fontSize: 15.0,
                      //             fontWeight: FontWeight.normal,
                      //           ),
                      //         ),
                      //       Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Container(
                      //               margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //               child: Text(
                      //                 model['userList'] != null
                      //                     ? '${model['userList'][0]['firstName']} ${model['userList'][0]['lastName']}'
                      //                     : '${model['createBy']}',
                      //                 style: TextStyle(
                      //                   // color: Color(0xFFFFFFFF),
                      //                   fontSize: 15,
                      //                   fontFamily: 'Kanit',
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //             ),
                      //             Container(
                      //               margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      //               child: Text(
                      //                 'วันที่ ' +
                      //                     dateStringToDate(model['createDate']),
                      //                 style: TextStyle(
                      //                   // color: Color(0xFFFFFFFF),
                      //                   fontFamily: 'Kanit',
                      //                   fontSize: 10,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                            
                      //     ],
                      //   ),
                      // ),
                    
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
