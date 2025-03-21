import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/shared/api_provider.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Profile(
      {super.key,
      required this.model,
      required this.organizationImage,
      this.nav,
      this.nav1,
      this.imageLv0});

  Future<dynamic> model;
  final Future<dynamic> organizationImage;
  final Function? nav;
  final Function? nav1;
  final List? imageLv0;
  final storage = const FlutterSecureStorage();

  @override
  // ignore: library_private_types_in_public_api
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  final storage = const FlutterSecureStorage();
  List<dynamic> dataLv0 = [];
  final seen = <String>{};
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
        builder: (context) => const LoginPage(),
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
          return const BlankLoading();
        } else {
          return const BlankLoading();
        }
      },
    );
  }

  Widget card({dynamic model}) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: GestureDetector(
        onTap: () => widget.nav1!(),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          height: model["lcCategory"] == '1' ? 140 : 160,
          decoration: BoxDecoration(
            // color: Colors.amber,
            image: model["lcCategory"] == '1'
                ? const DecorationImage(
                    image: AssetImage("assets/Group6877.png"),
                    fit: BoxFit.cover,
                  )
                : const DecorationImage(
                    image: AssetImage("assets/Group6876.png"),
                    fit: BoxFit.cover,
                  ),
            borderRadius: model["lcCategory"] == '1'
                ? const BorderRadius.all(
                    Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        '${model['imageUrl']}' != '' ? 0.0 : 5.0),
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black12),
                    height: 60,
                    width: 60,
                    child: model['imageUrl'] != '' && model['imageUrl'] != null
                        // ? CircleAvatar(
                        //     backgroundColor: Colors.black,
                        //     backgroundImage: model['imageUrl'] != null
                        //         ? NetworkImage(model['imageUrl'])
                        //         : null,
                        //   )
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: model['imageUrl'] != null
                                ? Image.network(
                                    model['imageUrl'],
                                    fit: BoxFit.fill,
                                  )
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            left: 375 * 3 / 100,
                            right: 375 * 1 / 100,
                          ),
                          child: Text(
                            model["lcCategory"] == "1"
                                ? 'บุคคลทั่วไป'
                                : "ทนายความ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 375 * 3 / 100,
                            right: 375 * 1 / 100,
                          ),
                          margin: const EdgeInsets.only(bottom: 40),
                          child: Text(
                            '${model['firstName']} ${model['lastName']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Container(
                        //   padding: EdgeInsets.only(
                        //     left: 10.0,
                        //   ),
                        //   child: _buildOrganizationImage(),
                        // ),
                        // Container(
                        //   padding: EdgeInsets.only(
                        //     left: width * 3 / 100,
                        //   ),
                        //   child: widget.imageLv0.length > 0
                        //       ? Row(
                        //           children: [
                        //             Container(
                        //               margin: EdgeInsets.only(right: 10),
                        //               child: Text('สมาชิก',
                        //                   style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: 10,
                        //                     fontWeight: FontWeight.normal,
                        //                     fontFamily: 'Kanit',
                        //                   )),
                        //             ),
                        //             Row(
                        //               children: widget.imageLv0
                        //                   .map<Widget>((e) => Container(
                        //                         margin:
                        //                             EdgeInsets.only(right: 5.0),
                        //                         decoration: BoxDecoration(
                        //                           color: Colors.transparent,
                        //                         ),
                        //                         height: 20,
                        //                         width: 20,
                        //                         child: e != null
                        //                             ? Image.network(e)
                        //                             : Container(),
                        //                       ))
                        //                   .toList(),
                        //             )
                        //           ],
                        //         )
                        //       : Text(
                        //           model['status'] == 'A'
                        //               ? 'สมาชิก : ${model['officerCode']}'
                        //               : model['status'] == 'N'
                        //                   ? 'สมาชิก : ท่านยังไม่ได้ยืนยันตน กรุณายืนยันตัวตน'
                        //                   : 'สมาชิก : ยืนยันตัวตนแล้ว รอเจ้าหน้าที่ตรวจสอบข้อมูล',
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 10,
                        //             fontWeight: FontWeight.normal,
                        //             fontFamily: 'Kanit',
                        //           ),
                        //           maxLines: 2,
                        //           overflow: TextOverflow.ellipsis,
                        //         ),
                        // ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          onTap: () => widget.nav!(),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              // color: model['vetCategory'] != '' &&
                              //         model['vetCategory'] != null
                              //     ? model['vetCategory'] == 'ทนายความ'
                              //         ? Color(0xFF011895)
                              //         : Color(0xFFB5B5B5)
                              //     : Color(0xFFB5B5B5),
                              color: model["lcCategory"] != '' &&
                                      model["lcCategory"] != null
                                  ? model["lcCategory"] == '1'
                                      ? const Color(0xFFB5B5B5)
                                      : const Color(0xFF011895)
                                  : const Color(0xFF011895),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(right: 10.0, bottom: 50),
                            width: 30,
                            height: 30,
                            child: Image.asset(
                              "assets/logo/icons/right.png",
                              color: Colors.white,
                              height: 10,
                              width: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              model["lcCategory"] == '1'
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            'วันหมดอายุ',
                            style: TextStyle(
                              color: model['isExpiredate'] == '1'
                                  ? Colors.red
                                  : Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: Text(
                            '${model['expiredate']}',
                            style: TextStyle(
                              color: model['isExpiredate'] == '1'
                                  ? Colors.red
                                  : Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
