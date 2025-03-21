import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/profile/identity_verification.dart';
import 'package:lc/shared/api_provider.dart';

// ignore: must_be_immutable
class ProfileV3 extends StatefulWidget {
  ProfileV3(
      {Key? key,
      this.model,
      this.organizationImage,
      this.nav,
      this.nav1,
      this.imageLv0})
      : super(key: key);

  Future<dynamic>? model;
  final Future<dynamic>? organizationImage;
  final Function? nav;
  final Function? nav1;
  final List? imageLv0;
  final storage = new FlutterSecureStorage();

  @override
  _ProfileV3 createState() => _ProfileV3();
}

class _ProfileV3 extends State<ProfileV3> {
  final storage = new FlutterSecureStorage();
  List<dynamic> dataLv0 = [];
  final seen = Set<String>();
  List unique = [];

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getDataLv0() async {
    final result =
        await postObjectData('organization/category/read', {'category': 'lv0'});

    if (result['status'] == 'S') {
      setState(() {
        dataLv0 = result['objectData'];
      });
    }
  }

  void goLogin() async {
    await storage.delete(key: 'dataUserLoginLC');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
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
            goLogin();
            return Container();
          }
        } else if (snapshot.hasError) {
          goLogin();
          return BlankLoading();
        } else {
          return BlankLoading();
        }
      },
    );
  }

  Widget card({dynamic model}) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        widget.nav!();
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(155, 171, 255, 0.258).withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 25,
                  offset: Offset(5, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                    height: 100,
                    // width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(20.0),
                        topRight: const Radius.circular(20.0),
                      ),
                      image: model["lcCategory"] == '1'
                          ? DecorationImage(
                              image: AssetImage(
                                  "assets/images/profile_no_bg_v3.png"),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image:
                                  AssetImage("assets/images/profile_bg_v3.png"),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: SizedBox()),
                Container(
                    height: 100,
                    // width: 20,
                    padding: EdgeInsets.only(top: 25),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(20.0),
                        bottomRight: const Radius.circular(20.0),
                      ),
                      color: Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            '${model['firstName']} ${model['lastName']}',
                            style: TextStyle(
                              color: Color(0xFF2D9CED),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                              height: 1.1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // SizedBox(height: 5,),
                        Container(
                          child: Text(
                            model["lcCategory"] == "1"
                                ? 'บุคคลทั่วไป'
                                : "ทนายความ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          Positioned(
            // right: 5,
            top: 35,
            // bottom: 5,
            child: Container(
              padding: EdgeInsets.all(3.0),
              height: 85,
              width: 85,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFFFFF),
              ),
              child: Container(
                  // padding: EdgeInsets.all(10.0),
                  // height: 90,
                  // width: 90,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: model['imageUrl'] != null
                        ? DecorationImage(
                            image: NetworkImage(model['imageUrl']),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage(
                              'assets/images/user_not_found.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                    // color: Color(0XFF0B24FB),
                  ),
                  child: SizedBox()
                  // model['imageUrl'] != null
                  //     ? Image.network(
                  //         model['imageUrl'],
                  //         fit: BoxFit.cover,
                  //         height: 100,
                  //         width: 100,
                  //       )
                  //     : Image.asset(
                  //         'assets/images/user_not_found.png',
                  //         color: Theme.of(context).primaryColorLight,
                  //       ),
                  ),
            ),
          ),
          Positioned(
            right: 58,
            top: 98,
            // bottom: 5,
            child: model["lcCategory"] == "1"
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(3.0),
                    // height: 25,
                    // width: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0XFF8AD2FF),
                    ),
                    child: Image.asset(
                      'assets/logo/icons/icon_bottom_profile.png',
                      fit: BoxFit.scaleDown,
                      width: 18,
                      height: 19,
                      // color: Theme.of(context).primaryColorLight,
                    ),
                  ),
          ),
        ],
      ),
    );

    // Container(
    //   child: GestureDetector(
    //     onTap: () => widget.nav1(),
    //     child: Container(
    //       padding: EdgeInsets.all(10.0),
    //       alignment: Alignment.center,
    //       height: model["lcCategory"] == '1' ? 140 : 160,
    //       decoration: BoxDecoration(
    //         // color: Colors.amber,
    //         image: model["lcCategory"] == '1'
    //             ? DecorationImage(
    //                 image: AssetImage("assets/Group6877.png"),
    //                 fit: BoxFit.cover,
    //               )
    //             : DecorationImage(
    //                 image: AssetImage("assets/Group6876.png"),
    //                 fit: BoxFit.cover,
    //               ),
    //         borderRadius: model["lcCategory"] == '1'
    //             ? BorderRadius.all(
    //                 Radius.circular(15),
    //               )
    //             : BorderRadius.only(
    //                 topLeft: Radius.circular(15),
    //                 topRight: Radius.circular(15),
    //               ),
    //       ),
    //       child: Column(
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Container(
    //                 padding: EdgeInsets.all(
    //                     '${model['imageUrl']}' != '' ? 0.0 : 5.0),
    //                 margin: EdgeInsets.only(bottom: 40),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(40),
    //                     color: Colors.black12),
    //                 height: 60,
    //                 width: 60,
    //                 child: model['imageUrl'] != '' && model['imageUrl'] != null
    //                     // ? CircleAvatar(
    //                     //     backgroundColor: Colors.black,
    //                     //     backgroundImage: model['imageUrl'] != null
    //                     //         ? NetworkImage(model['imageUrl'])
    //                     //         : null,
    //                     //   )
    //                     ? ClipRRect(
    //                         borderRadius: BorderRadius.circular(15.0),
    //                         child: model['imageUrl'] != null
    //                             ? Image.network(
    //                                 model['imageUrl'],
    //                                 fit: BoxFit.fill,
    //                               )
    //                             : null,
    //                       )
    //                     : Container(
    //                         padding: EdgeInsets.all(10.0),
    //                         child: Image.asset(
    //                           'assets/images/user_not_found.png',
    //                           color: Theme.of(context).primaryColorLight,
    //                         ),
    //                       ),
    //               ),
    //               Expanded(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   mainAxisSize: MainAxisSize.max,
    //                   children: [
    //                     Container(
    //                       padding: EdgeInsets.only(
    //                         left: 375 * 3 / 100,
    //                         right: 375 * 1 / 100,
    //                       ),
    //                       child: Text(
    //                         model["lcCategory"] == "1"
    //                             ? 'บุคคลทั่วไป'
    //                             : "ทนายความ",
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 15.0,
    //                           fontWeight: FontWeight.w500,
    //                           fontFamily: 'Kanit',
    //                         ),
    //                         maxLines: 1,
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ),
    //                     Container(
    //                       padding: EdgeInsets.only(
    //                         left: 375 * 3 / 100,
    //                         right: 375 * 1 / 100,
    //                       ),
    //                       margin: EdgeInsets.only(bottom: 40),
    //                       child: Text(
    //                         '${model['firstName']} ${model['lastName']}',
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontSize: 20.0,
    //                           fontWeight: FontWeight.bold,
    //                           fontFamily: 'Kanit',
    //                         ),
    //                         maxLines: 1,
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ),
    //                     // Container(
    //                     //   padding: EdgeInsets.only(
    //                     //     left: 10.0,
    //                     //   ),
    //                     //   child: _buildOrganizationImage(),
    //                     // ),
    //                     // Container(
    //                     //   padding: EdgeInsets.only(
    //                     //     left: width * 3 / 100,
    //                     //   ),
    //                     //   child: widget.imageLv0.length > 0
    //                     //       ? Row(
    //                     //           children: [
    //                     //             Container(
    //                     //               margin: EdgeInsets.only(right: 10),
    //                     //               child: Text('สมาชิก',
    //                     //                   style: TextStyle(
    //                     //                     color: Colors.white,
    //                     //                     fontSize: 10,
    //                     //                     fontWeight: FontWeight.normal,
    //                     //                     fontFamily: 'Kanit',
    //                     //                   )),
    //                     //             ),
    //                     //             Row(
    //                     //               children: widget.imageLv0
    //                     //                   .map<Widget>((e) => Container(
    //                     //                         margin:
    //                     //                             EdgeInsets.only(right: 5.0),
    //                     //                         decoration: BoxDecoration(
    //                     //                           color: Colors.transparent,
    //                     //                         ),
    //                     //                         height: 20,
    //                     //                         width: 20,
    //                     //                         child: e != null
    //                     //                             ? Image.network(e)
    //                     //                             : Container(),
    //                     //                       ))
    //                     //                   .toList(),
    //                     //             )
    //                     //           ],
    //                     //         )
    //                     //       : Text(
    //                     //           model['status'] == 'A'
    //                     //               ? 'สมาชิก : ${model['officerCode']}'
    //                     //               : model['status'] == 'N'
    //                     //                   ? 'สมาชิก : ท่านยังไม่ได้ยืนยันตน กรุณายืนยันตัวตน'
    //                     //                   : 'สมาชิก : ยืนยันตัวตนแล้ว รอเจ้าหน้าที่ตรวจสอบข้อมูล',
    //                     //           style: TextStyle(
    //                     //             color: Colors.white,
    //                     //             fontSize: 10,
    //                     //             fontWeight: FontWeight.normal,
    //                     //             fontFamily: 'Kanit',
    //                     //           ),
    //                     //           maxLines: 2,
    //                     //           overflow: TextOverflow.ellipsis,
    //                     //         ),
    //                     // ),
    //                   ],
    //                 ),
    //               ),
    //               Container(
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.end,
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   mainAxisSize: MainAxisSize.max,
    //                   children: [
    //                     InkWell(
    //                       onTap: () => widget.nav(),
    //                       child: Container(
    //                         decoration: BoxDecoration(
    //                           borderRadius: new BorderRadius.circular(8),
    //                           // color: model['vetCategory'] != '' &&
    //                           //         model['vetCategory'] != null
    //                           //     ? model['vetCategory'] == 'ทนายความ'
    //                           //         ? Color(0xFF011895)
    //                           //         : Color(0xFFB5B5B5)
    //                           //     : Color(0xFFB5B5B5),
    //                           color: model["lcCategory"] != '' &&
    //                                   model["lcCategory"] != null
    //                               ? model["lcCategory"] == '1'
    //                                   ? Color(0xFFB5B5B5)
    //                                   : Color(0xFF011895)
    //                               : Color(0xFF011895),
    //                         ),
    //                         padding: EdgeInsets.all(8.0),
    //                         margin: EdgeInsets.only(right: 10.0, bottom: 50),
    //                         width: 30,
    //                         height: 30,
    //                         child: Image.asset(
    //                           "assets/logo/icons/right.png",
    //                           color: Colors.white,
    //                           height: 10,
    //                           width: 10,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],
    //           ),
    //           model["lcCategory"] == '1'
    //               ? Container()
    //               : Column(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: [
    //                     Container(
    //                       alignment: Alignment.topRight,
    //                       child: Text(
    //                         'วันหมดอายุ',
    //                         style: TextStyle(
    //                           color: model['isExpiredate'] == '1'
    //                               ? Colors.red
    //                               : Colors.white,
    //                           fontSize: 12.0,
    //                           fontWeight: FontWeight.bold,
    //                           fontFamily: 'Kanit',
    //                         ),
    //                         maxLines: 1,
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ),
    //                     Container(
    //                       alignment: Alignment.topRight,
    //                       child: Text(
    //                         '${model['expiredate']}',
    //                         style: TextStyle(
    //                           color: model['isExpiredate'] == '1'
    //                               ? Colors.red
    //                               : Colors.white,
    //                           fontSize: 12.0,
    //                           fontWeight: FontWeight.bold,
    //                           fontFamily: 'Kanit',
    //                         ),
    //                         maxLines: 1,
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  _buildOrganizationImage() {
    return FutureBuilder<dynamic>(
      future: widget.organizationImage, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // data from refresh api
        if (snapshot.hasData) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text(
              //   'สมาชิก : ',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 10,
              //     fontWeight: FontWeight.normal,
              //     fontFamily: 'Kanit',
              //   ),
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
              Container(
                height: 30,
                // padding: EdgeInsets.only(top: 5),
                child: ListView.builder(
                  shrinkWrap: true, // 1st add
                  physics: ClampingScrollPhysics(), // 2nd
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return snapshot.data[0]['imageUrl'] != ''
                        ? CircleAvatar(
                            child: ClipOval(
                              child: Image.network(
                                snapshot.data[index]['imageUrl'],
                              ),
                            ),
                          )
                        : snapshot.data[0]['title'] == 'รอการยืนยันตัวตน'
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          IdentityVerificationPage(
                                        title: '',
                                      ),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      'กรุณาลงทะเบียน',
                                      style: TextStyle(
                                        color: Color(0xFF707070),
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Kanit',
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  'สมาชิก : ' + snapshot.data[0]['title'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Kanit',
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                  },
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          // goLogin();
          return BlankLoading();
        } else {
          return BlankLoading();
        }
      },
    );
  }
}
