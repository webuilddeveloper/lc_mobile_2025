import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/button_close_back.dart';
import 'package:lc/models/user.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:lc/v3/poll_v3/poll_dialog.dart';

import '../../pages/blank_page/toast_fail.dart';
import '../widget/header_v3.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class PollFormV3 extends StatefulWidget {
  PollFormV3({
    Key? key,
    required this.code,
    this.model,
    required this.url,
    required this.titleMenu,
    required this.titleHome,
  }) : super(key: key);
  final String code;
  final String url;
  final dynamic model;
  final String titleMenu;
  final String titleHome;

  @override
  _PollDetailV3PageState createState() => _PollDetailV3PageState(code: '');
}

class _PollDetailV3PageState extends State<PollFormV3> {
  _PollDetailV3PageState({required this.code});

  final _textEditingController = TextEditingController();

  late User userData;
  late FlutterSecureStorage storage;
  late Future<dynamic> _futureModel;
  late String code;
  late List urlImage = [];
  late List<ImageProvider> urlImageProvider = [];
  late int _selectedIndex;
  // String _urlShared = '';
  int page = 0;
  bool valueChange = false;
  dynamic questions = [];
  dynamic replyTemp = [];
  bool isReply = false;
  dynamic modelTemp = [];
  dynamic obj = [];

  @override
  void initState() {
    storage = FlutterSecureStorage();
    // sharedApi();
    callRead();
    super.initState();
  }

  callRead() async {
    await getUserData();
    _futureModel = postDio('${pollApi}all/read', {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
      'username': userData.username
    });
    _futureModel.then((value) => {
          value['questions'].forEach((e) => {
                e['valueChange'] = false,
              }),
        });
  }

  // Future<dynamic> sharedApi() async {
  //   final result = await postObjectData('configulation/shared/read',
  //       {'skip': 0, 'limit': 1, 'code': widget.code});
  //
  //   if (result['status'] == 's') {
  //     setState(() {
  //       _urlShared = result['objectData']['description'].toString();
  //     });
  //   }
  // }

  getUserData() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var data = json.decode(value!);

    setState(() {
      userData = new User(
        username: data['username'] != '' ? data['username'] : '',
        password: data['password'] != '' ? data['password'].toString() : '',
        firstName: data['firstName'] != '' ? data['firstName'] : '',
        lastName: data['lastName'] != '' ? data['lastName'] : '',
        imageUrl: data['imageUrl'] != '' ? data['imageUrl'] : '',
        category: data['category'] != '' ? data['category'] : '',
        countUnit: data['countUnit'] != '' ? data['countUnit'] : '',
        address: data['address'] != '' ? data['address'] : '',
        status: data['status'] != '' ? data['status'] : '',
      );
    });
  }

  pollReply(dynamic model) async {
    String reference = model['code'];
    String referenceQuestion = '';
    String title = '';

    bool checkSendReply = true;
    for (int i = 0; i < model['questions'].length; i++) {
      if (model['questions'][i]['isRequired']) {
        List<dynamic> data = model['questions'][i]['answers'];

        var checkValue = data.indexWhere(
          (item) => item['value'] == true && item['value'] != '',
        );

        if (checkValue == -1) {
          checkSendReply = false;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () {
                    return Future.value(false);
                  },
                  child: CupertinoAlertDialog(
                    title: new Text(
                      'กรุณาตอบคำถาม',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    content: Text(" "),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: new Text(
                          "ตกลง",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Kanit',
                            color: Color(0xFFA9151D),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              });
          break;
        } else {
          checkSendReply = true;
        }
      } else {
        checkSendReply = true;
      }
    }

    if (checkSendReply) {
      var value = await storage.read(key: 'dataUserLoginLC');
      var user = json.decode(value!);

      model['questions']
          .map((question) => {
                title = question['title'],
                reference = question['reference'],
                referenceQuestion = question['code'],
                question['answers']
                    .map((answer) => {
                          if (answer['value'])
                            {
                              postObjectData('m/poll/reply/create', {
                                'reference': reference.toString(),
                                'referenceQuestion':
                                    referenceQuestion.toString(),
                                'referenceAnswer': answer['code'].toString(),
                                'username': user['username'].toString(),
                                'firstName': user['firstName'].toString(),
                                'lastName': user['lastName'].toString(),
                                'title': title.toString(),
                                'answer': question['reference'] == 'text'
                                    ? answer['value'] == false
                                        ? ''
                                        : answer['value'].toString()
                                    : answer['title'].toString(),
                                'platform': Platform.operatingSystem.toString()
                              })
                            }
                        })
                    .toList(),
              })
          .toList();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PollDialogV3(
            userData: userData,
            titleHome: widget.titleHome,
          ),
        ),
      );
      // showDialog(
      //   barrierDismissible: false,
      //   context: context,
      //   builder: (BuildContext context) => new PollDialog(userData: userData,titleHome: widget.titleHome,),
      // );
    }
  }

  Future<dynamic> readGallery() async {
    final result =
        await postObjectData('m/news/gallery/read', {'code': widget.code});
    if (result['status'] == 'S') {
      List data = [];
      List<ImageProvider> dataPro = [];

      for (var item in result['objectData']) {
        data.add(item['imageUrl']);

        dataPro.add((item['imageUrl'] != null
            ? NetworkImage(item['imageUrl'])
            : null) as ImageProvider<Object>);
      }
      setState(() {
        urlImage = data;
        urlImageProvider = dataPro;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: headerV3(context, goBack, title: "แบบสอบถาม"),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: FutureBuilder<dynamic>(
            future: _futureModel, // function where you call your api
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              // AsyncSnapshot<Your object type>

              if (snapshot.hasData) {
                questions = snapshot.data['questions'];
                replyTemp = snapshot.data['replyTemp'];
                modelTemp = snapshot.data;
                if (!isReply) {
                  for (var q in snapshot.data['questions']) {
                    var isReplyChk = false;
                    if (replyTemp != null) {
                      for (var r in replyTemp
                          .where((x) => x['referenceQuestion'] == q['code'])) {
                        if (!isReplyChk) {
                          if ((page + 1) < snapshot.data['questions'].length)
                            page++;
                          isReplyChk = true;
                        }

                        q['valueChange'] = true;
                        q['answers']
                            .map((a) => {
                                  if (a['code'] == r['referenceAnswer'])
                                    {
                                      a['value'] = true,
                                      if (q['value'] == 'text')
                                        a['title'] = r['answer'],
                                    }
                                })
                            .toList();
                      }
                    }
                  }
                  isReply = true;
                }

                return myCard(snapshot.data, questions);
                // myCard(
                //   model: snapshot.data,
                //   questions: questions,
                //   answer: answers,
                // );
              } else {
                return Container(
                  child: Stack(
                    children: [
                      BlankLoading(),
                      Positioned(
                        right: 0,
                        top: statusBarHeight + 5,
                        child: Container(
                          child: buttonCloseBack(context),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void goBack() async {
    String reference = modelTemp['code'];
    String referenceQuestion = '';
    String title = '';

    // set up the buttons
    Widget cancelButton = TextButton(
      onPressed: () {},
      child: MaterialButton(
        elevation: 0,
        color: Color.fromRGBO(138, 210, 255, 0.15),
        height: 40,
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(73)),
        onPressed: () async {
          await postDio('${server}m/poll/reply/deleteTemp', {
            'reference': reference.toString(),
            // 'referenceQuestion': referenceQuestion.toString(),
            'username': userData.username.toString(),
          });
          modelTemp['questions']
              .map((question) => {
                    title = question['title'],
                    reference = question['reference'],
                    referenceQuestion = question['code'],
                    question['answers']
                        .map((answer) => {
                              if (answer['value'])
                                {
                                  postObjectData('m/poll/reply/createTemp', {
                                    'reference': reference.toString(),
                                    'referenceQuestion':
                                        referenceQuestion.toString(),
                                    'referenceAnswer':
                                        answer['code'].toString(),
                                    'username': userData.username.toString(),
                                    'firstName': userData.firstName.toString(),
                                    'lastName': userData.lastName.toString(),
                                    'title': title.toString(),
                                    'answer': question['reference'] == 'text'
                                        ? answer['value'] == false
                                            ? ''
                                            : answer['value'].toString()
                                        : answer['title'].toString(),
                                    'platform':
                                        Platform.operatingSystem.toString()
                                  })
                                }
                            })
                        .toList(),
                  })
              .toList();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'หยุดทำ',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFF2D9CED),
              fontFamily: 'Kanit',
            ),
          ),
        ),
      ),
    );
    Widget continueButton = TextButton(
      onPressed: () {},
      child: MaterialButton(
        elevation: 0,
        color: Color(0xFFED6B2D),
        height: 40,
        shape:
            RoundedRectangleBorder(borderRadius: new BorderRadius.circular(73)),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'ทำต่อ',
            style: TextStyle(
              fontSize: 17,
              color: Color(0xFFFFFFFF),
              fontFamily: 'Kanit',
            ),
          ),
        ),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      title: Text(
        'หยุดทำแบบสอบถาม ?',
        style: TextStyle(
          fontSize: 20,
          fontFamily: 'Kanit',
          color: Color(0XFFED6B2D),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "ระบบจะบันทึกคำตอบของท่าน เพื่อรอท่านกลับมาทำแบบสอบถามต่อ",
        style: TextStyle(
          fontSize: 15,
          fontFamily: 'Kanit',
          color: Color(0XFF000000),
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    // Navigator.pop(context);
  }

  myCard(model, questions) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // double statusBarHeight = MediaQuery.of(context).padding.top;
    // List image = ['${model['imageUrl']}'];
    // List<ImageProvider> imagePro = [
    //   model['imageUrl'] != null ? NetworkImage(model['imageUrl']) : null
    // ];

    questions[page]['valueChange'] == null
        ? false
        : questions[page]['valueChange'];

    return Container(
      alignment: Alignment.bottomCenter,
      color: Colors.white,
      height: height,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                // left: 15.0,
                // right: 15.0,
                bottom: 15),
            child: Text(
              '${(page + 1).toString()}/${(questions.length).toString()}',
              // questions[page]['isRequired']
              //     ? '(กรุณาเลือกคำตอบ)'
              //     : '(ไม่จำเป็นต้องระบุ)',
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w300,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Expanded(
            child:
                // MediaQuery.removePadding(
                //   context: context,
                //   removeTop: true,
                //   child:
                ListView(
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      child: Text(
                        'ข้อที่ ${(page + 1).toString()} ${questions[page]['title']}',
                        // questions[page]['isRequired']
                        //     ? '* ' + questions[page]['title']
                        //     : questions[page]['title'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    for (int i = 0; i < questions[page]['answers'].length; i++)
                      questions[page]['category'] == 'text'
                          ? textBox(_textEditingController,
                              questions[page]['answers'], i)
                          : questions[page]['category'] == 'multiple'
                              ? checkBoxMultiple(questions[page]['answers'], i)
                              : checkBoxSingle(questions[page]['answers'], i),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (page + 1) < questions.length
                    ? Expanded(
                        child: MaterialButton(
                          elevation: 0,
                          color: Color.fromRGBO(138, 210, 255, 0.15),
                          // minWidth: MediaQuery.of(context).size.width,
                          height: 40,
                          // minWidth: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(73)),
                          onPressed: () {
                            if (page == 0)
                              Navigator.pop(context);
                            else
                              setState(() {
                                page--;
                              });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'ก่อนหน้า',
                              style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF2D9CED),
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(width: 15),
                (page + 1) < questions.length
                    ? Expanded(
                        child: MaterialButton(
                          elevation: 0,
                          color: (questions[page]['isRequired'] &&
                                  (!questions[page]['valueChange']))
                              ? Colors.grey.shade600
                              : Color(0xFFED6B2D),
                          // minWidth: MediaQuery.of(context).size.width,
                          height: 40,
                          // minWidth: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(73)),
                          onPressed: () {
                            setState(() {
                              if (questions[page]['isRequired'] &&
                                  !questions[page]['valueChange']) {
                                toastFail(
                                  context,
                                  text: 'กรุณาเลือกคำตอบ',
                                  color: Color(0xFFED6B2D),
                                  fontColor: Colors.white,
                                );
                              } else {
                                if ((page + 1) >= questions.length) {
                                  pollReply(model);
                                } else {
                                  page++;
                                }
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'ถัดไป',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                        ),
                      )
                    : MaterialButton(
                        elevation: 0,
                        color: (questions[page]['isRequired'] &&
                                (!questions[page]['valueChange']))
                            ? Colors.grey.shade600
                            : Color(0xFFED6B2D),
                        height: 40,
                        minWidth: 170,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(73)),
                        onPressed: () {
                          setState(() {
                            if (questions[page]['isRequired'] &&
                                !questions[page]['valueChange']) {
                              toastFail(
                                context,
                                text: 'กรุณาเลือกคำตอบ',
                                color: Color(0xFFED6B2D),
                                fontColor: Colors.white,
                              );
                            } else {
                              if ((page + 1) >= questions.length) {
                                pollReply(model);
                              } else {
                                page++;
                              }
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'ส่งคำตอบ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  textBox(TextEditingController _textEditingController, dynamic item, int i) {
    return Container(
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                maxLength: 300,
                onChanged: (value) => setState(() {
                  if (value != '') {
                    item[i]['value'] = true;
                    questions[page]['valueChange'] = true;
                  } else {
                    item[i]['value'] = false;
                    questions[page]['valueChange'] = false;
                  }
                  item[i]['title'] = value;
                }),
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w300,
                ),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF2D9CED), width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFF2D9CED).withAlpha(80), width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                      gapPadding: 1),
                  // border: OutlineInputBorder(
                  //   borderSide:
                  //       BorderSide(color: Color(0xFF2D9CED).withAlpha(40), width: 1.0),
                  //     borderRadius: BorderRadius.circular(10), gapPadding: 1),
                  hintText: 'กรุณาใส่รายละเอียดคำตอบ',
                  contentPadding: const EdgeInsets.all(10.0),
                ),
              ),
            ),
            Positioned(
              left: 25,
              // top: -10,
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    'รายละเอียด',
                    style: TextStyle(
                        color: Color(0xFF2D9CED),
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  )),
            )
          ],
        ));
  }

  checkBoxSingle(dynamic answers, int i) {
    return Container(
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 15.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: answers[i]['value']
                ? Color(0xFF2D9CED)
                : Color(0xFF707070).withOpacity(.25),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedIndex = i;

              for (int j = 0; j < answers.length; j++) {
                if (j == _selectedIndex) {
                  answers[j]['value'] = !answers[j]['value'];
                } else {
                  answers[j]['value'] = false;
                }
              }
              var a = answers.where((x) => x['value'] == true);

              if (a.length > 0) {
                setState(() {
                  questions[page]['valueChange'] = true;
                });
              } else {
                setState(() {
                  questions[page]['valueChange'] = false;
                });
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  answers[i]['title'],
                  style: TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    color:
                        answers[i]['value'] ? Color(0xFF2D9CED) : Colors.white,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                )
                //   Checkbox(
                //   // controlAffinity: ListTileControlAffinity.leading,
                //   value: answers[i]['value'],
                //   onChanged: (bool value) {
                //     setState(() {
                //       _selectedIndex = i;
                //       for (int j = 0; j < answers.length; j++) {
                //         if (j == _selectedIndex) {
                //           answers[j]['value'] = !answers[j]['value'];
                //         } else {
                //           answers[j]['value'] = false;
                //         }
                //       }
                //     });
                //   },
                //   side: BorderSide(color: Colors.red, width: 0, style: BorderStyle.none),
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10)),
                //   activeColor: Color(0xFF2D9CED),
                //   checkColor: Colors.white,
                // ),
              ],
            ),
          ),
        ));
  }

  checkBoxMultiple(dynamic answers, int i) {
    return Container(
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 15.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: answers[i]['value']
                ? Color(0xFF2D9CED)
                : Color(0xFF707070).withOpacity(.25),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              answers[i]['value'] = !answers[i]['value'];
              var a = answers.where((x) => x['value'] == true);
              if (a.length > 0) {
                questions[page]['valueChange'] = true;
              } else {
                questions[page]['valueChange'] = false;
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  answers[i]['title'],
                  style: TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3.0),
                    ),
                    color:
                        answers[i]['value'] ? Color(0xFF2D9CED) : Colors.white,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
