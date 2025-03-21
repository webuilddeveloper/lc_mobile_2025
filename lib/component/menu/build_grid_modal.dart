import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/component/menu_grid_item.dart';
import 'package:lc/models/user.dart';
import 'package:lc/pages/fund/fund_list.dart';
import 'package:lc/pages/knowledge/knowledge_list.dart';
import 'package:lc/pages/poll/poll_list.dart';
import 'package:lc/pages/question_and_answer/question_list.dart';
import 'package:lc/pages/reporter/reporter_list_category.dart';
import 'package:lc/pages/teacher/teacher_index.dart';
import 'package:lc/shared/api_provider.dart';

import '../../pages/policy_v2.dart';
import '../../pages/privilege/privilege_main.dart';

class BuildGridModal extends StatefulWidget {
  BuildGridModal(
      {Key? key,
      required this.menuModel,
      required this.model,
      required this.userData})
      : super(key: key);

  final Future<dynamic> model;
  final Future<dynamic> menuModel;
  final User userData;

  @override
  BuildGridModalState createState() => BuildGridModalState();
}

class BuildGridModalState extends State<BuildGridModal> {
  late Future<dynamic> _futureCheck;
  String profileCode = '';
  var loadingModel = {
    'title': '',
    'imageUrl': '',
  };
  dynamic _tempModel = {'imageUrl': '', 'firstName': '', 'lastName': ''};

  @override
  void initState() {
    initFunc();
    super.initState();
  }

  initFunc() async {
    await getStorage();

    _futureCheck = post(questionApi + 'check', {
      'profileCode': profileCode,
    });
  }

  getStorage() async {
    final storage = new FlutterSecureStorage();
    var sto = await storage.read(key: 'dataUserLoginLC');
    var data = json.decode(sto!);
    setState(() {
      profileCode = data['code'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: widget.menuModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return screen(snapshot.data, false);
          } else if (snapshot.hasError) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              height: 90,
              child: Center(
                child: Text('Network ขัดข้อง'),
              ),
            );
          } else {
            return screen(_tempModel, true);
          }
        });
  }

  Column screen(dynamic model, bool isLoading) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    MenuGridItem(
                      title: isLoading
                          ? loadingModel['title']
                          : model[10]['title'],
                      imageUrl: isLoading
                          ? loadingModel['imageUrl']
                          : model[10]['imageUrl'],
                      subTitle: '',
                      isCenter: false,
                      isPrimaryColor: false,
                      nav: () {
                        // Call function
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuildTeacherIndex(menuModel: null, model: null,),
                          ),
                        );
                      },
                    ),
                    MenuGridItem(
                      title:
                          isLoading ? loadingModel['title'] : model[3]['title'],
                      imageUrl: isLoading
                          ? loadingModel['imageUrl']
                          : model[3]['imageUrl'],
                      subTitle: '',
                      isCenter: false,
                      isPrimaryColor: false,
                      nav: () {
                        // Call function
                        _callReadPolicy(model[3]['title']);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => PolicyPrivilege(
                        //       title: model[3]['title'],
                        //       username: widget.userData.username,
                        //       fromPolicy: true,
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                    MenuGridItem(
                      title:
                          isLoading ? loadingModel['title'] : model[4]['title'],
                      imageUrl: isLoading
                          ? loadingModel['imageUrl']
                          : model[4]['imageUrl'],
                      subTitle: '',
                      isCenter: false,
                      isPrimaryColor: false,
                      nav: () {
                        // Call function
                        launchInWebViewWithJavaScript(model[4]['direction']);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    // MenuGridItem(
                    //   title:
                    //       isLoading ? loadingModel['title'] : model[5]['title'],
                    //   imageUrl: isLoading
                    //       ? loadingModel['imageUrl']
                    //       : model[5]['imageUrl'],
                    //   subTitle: '',
                    //   isCenter: false,
                    //   isPrimaryColor: false,
                    //   nav: () {
                    //     // Call function
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return dialogFail(
                    //           context,
                    //           title: 'เมนูนี้ยังไม่เปิดให้ใช้งาน',
                    //           background: Colors.transparent,
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    MenuGridItem(
                      title:
                          isLoading ? loadingModel['title'] : model[2]['title'],
                      imageUrl: isLoading
                          ? loadingModel['imageUrl']
                          : model[2]['imageUrl'],
                      subTitle: '',
                      isCenter: false,
                      isPrimaryColor: false,
                      nav: () {
                        // Call function
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => KnowledgeList(
                              title: model[2]['title'],
                            ),
                          ),
                        );
                      },
                    ),
                    MenuGridItem(
                      title:
                          isLoading ? loadingModel['title'] : model[5]['title'],
                      imageUrl: isLoading
                          ? loadingModel['imageUrl']
                          : model[5]['imageUrl'],
                      subTitle: '',
                      isCenter: false,
                      isPrimaryColor: false,
                      nav: () {
                        // Call function
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FundList(
                              title: model[5]['title'],
                            ),
                          ),
                        );
                      },
                    ),
                    MenuGridItem(
                      title:
                          isLoading ? loadingModel['title'] : model[6]['title'],
                      imageUrl: isLoading
                          ? loadingModel['imageUrl']
                          : model[6]['imageUrl'],
                      subTitle: '',
                      isCenter: false,
                      isPrimaryColor: false,
                      nav: () {
                        // Call function
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PollList(
                              title: model[6]['title'],
                              userData: widget.userData,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    MenuGridItem(
                      title:
                          isLoading ? loadingModel['title'] : model[7]['title'],
                      imageUrl: isLoading
                          ? loadingModel['imageUrl']
                          : model[7]['imageUrl'],
                      subTitle: '',
                      isCenter: false,
                      isPrimaryColor: false,
                      nav: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReporterListCategory(
                              title: model[7]['title'],
                            ),
                          ),
                        );
                      },
                    ),
                    _buildQA(model, isLoading),
                    Flexible(
                      flex: 3,
                      child: Container(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _buildQA(dynamic model, bool isLoading) {
    return FutureBuilder<dynamic>(
      future: _futureCheck,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['isShowButton']) {
            return MenuGridItem(
              title: isLoading ? loadingModel['title'] : model[12]['title'],
              imageUrl:
                  isLoading ? loadingModel['imageUrl'] : model[12]['imageUrl'],
              subTitle: '',
              isCenter: false,
              isPrimaryColor: false,
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuildQuestionList(
                      isSchool: snapshot.data['isSchool'],
                      menuModel: model[12],
                    ),
                  ),
                );
              },
            );
          } else {
            return Flexible(
              flex: 3,
              child: Container(),
            );
          }
        } else {
          return Flexible(
            flex: 3,
            child: Container(),
          );
        }
      },
    );
  }

  Future<Null> _callReadPolicy(String title) async {
    var policy = await postDio(server + "m/policy/read", {
      "category": "marketing",
    });

    if (policy.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder: (context) => PolicyV2Page(
            category: 'marketing',
            navTo: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivilegeMain(
                    title: title, fromPolicy: null,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // if (!isPolicyFasle) {
      //   logout(context);
      //   _onRefresh();
      // }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivilegeMain(
            title: title,
          ),
        ),
      );
    }
  }

  // .end
}
