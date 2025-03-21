import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/button_close_back.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/models/user.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/poll/poll_dialog.dart';
import 'package:lc/pages/poll/poll_list.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:lc/shared/extension.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class PollForm extends StatefulWidget {
  const PollForm({
    super.key,
    @required this.code,
    this.model,
    this.url,
    this.titleMenu,
    this.titleHome,
  });
  final String? code;
  final String? url;
  final dynamic model;
  final String? titleMenu;
  final String? titleHome;

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _PollDetailPageState createState() => _PollDetailPageState(code: code);
}

class _PollDetailPageState extends State<PollForm> {
  _PollDetailPageState({this.code});

  final _textEditingController = TextEditingController();

  late User userData;
  late FlutterSecureStorage storage;
  late Future<dynamic> _futureModel;
  String? code;
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];
  late int _selectedIndex;
  // String _urlShared = '';

  @override
  void initState() {
    storage = const FlutterSecureStorage();
    // sharedApi();
    getUserData();
    _futureModel = postDio(
        '${pollApi}all/read', {'skip': 0, 'limit': 1, 'code': widget.code});
    super.initState();
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
      userData = User(
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
                    title: const Text(
                      'กรุณาตอบคำถาม',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    content: const Text(" "),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: const Text(
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
                question['answers']
                    .map((answer) => {
                          if (answer['value'])
                            {
                              postObjectData('m/poll/reply/create', {
                                'reference': reference.toString(),
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
          builder: (context) => PollDialog(
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

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: FutureBuilder<dynamic>(
            future: _futureModel, // function where you call your api
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              // AsyncSnapshot<Your object type>
              dynamic questions = [];
              dynamic answers = [];

              if (snapshot.hasData) {
                questions = snapshot.data['questions'];
                answers = snapshot.data['answers'];
                return myCard(
                  model: snapshot.data,
                  questions: questions,
                  answer: answers,
                );
              } else {
                return Stack(
                  children: [
                    const BlankLoading(),
                    Positioned(
                      right: 0,
                      top: statusBarHeight + 5,
                      child: Container(
                        child: buttonCloseBack(context),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void goBack() async {
    // Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PollList(
          title: widget.titleHome!,
          userData: userData,
        ),
      ),
    );
  }

  myCard({dynamic model, dynamic questions, dynamic answer}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      if (model['imageUrl'] != null) NetworkImage(model['imageUrl'])
    ];
    return Container(
      alignment: Alignment.bottomCenter,
      color: Colors.white,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: false,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      Container(
                        // color: Colors.green,
                        padding: const EdgeInsets.only(
                          right: 10.0,
                          left: 10.0,
                        ),
                        margin: const EdgeInsets.only(right: 50.0, top: 10.0),
                        child: Text(
                          '${model['title']}',
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      model['imageUrlCreateBy'] != null
                                          ? NetworkImage(
                                              model['imageUrlCreateBy'],
                                            )
                                          : null,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model['userList'] != null
                                            ? '${model['userList'][0]['firstName']} ${model['userList'][0]['lastName']}'
                                            : '${model['createBy']}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            dateStringToDate(
                                                    model['createDate']) +
                                                ' | ',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Text(
                                            'เข้าชม ${model['view']} ครั้ง',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: const Color(0x0fffffff),
                        child: GalleryView(
                          imageUrl: [...image, ...urlImage],
                          imageProvider: [...imagePro, ...urlImageProvider],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: 10.0,
                          left: 10.0,
                        ),
                        margin: const EdgeInsets.only(right: 50.0, top: 10.0),
                        child: Text(
                          '${model['title']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          right: 10,
                          left: 10,
                        ),
                        child: Html(
                          data: model['description'],
                          onLinkTap: (String? url,
                              Map<String, String> attributes, element) {
                            launch(url!);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: questions
                            .map<Widget>(
                              (item) => Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    child: Text(
                                      item['isRequired']
                                          ? '* ' + item['title']
                                          : item['title'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Kanit',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    child: Text(
                                      item['isRequired']
                                          ? '(กรุณาเลือกคำตอบ)'
                                          : '(ไม่จำเป็นต้องระบุ)',
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: 'Kanit',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  for (int i = 0;
                                      i < item['answers'].length;
                                      i++)
                                    item['category'] == 'text'
                                        ? textBox(_textEditingController,
                                            item['answers'], i)
                                        : item['category'] == 'multiple'
                                            ? checkBoxMultiple(
                                                item['answers'], i)
                                            : checkBoxSingle(
                                                item['answers'], i),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: width * 25 / 100),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: const Color(0xFFF58A33),
                            ),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: () {
                                pollReply(model);
                              },
                              child: const Text(
                                'ส่ง',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: statusBarHeight + 5,
                    child: Container(
                      child: buttonCloseBack(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // btnPoll(model),
        ],
      ),
    );
  }

  textBox(TextEditingController textEditingController, dynamic item, int i) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        maxLength: 300,
        onChanged: (value) => setState(() {
          if (value != '') {
            item[i]['value'] = true;
          } else {
            item[i]['value'] = false;
          }
          item[i]['title'] = value;
        }),
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'Kanit',
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black.withAlpha(50), width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), gapPadding: 1),
          hintText: 'แสดงความคิดเห็น',
          contentPadding: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }

  checkBoxSingle(dynamic answers, int i) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFF58A33),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: Colors.white,
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          answers[i]['title'],
          style: const TextStyle(
            fontSize: 13.0,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w300,
          ),
        ),
        value: answers[i]['value'],
        onChanged: (bool? value) {
          setState(() {
            _selectedIndex = i;
            for (int j = 0; j < answers.length; j++) {
              if (j == _selectedIndex) {
                answers[j]['value'] = !(answers[j]['value'] ?? false);
              } else {
                answers[j]['value'] = false;
              }
            }
          });
        },
        activeColor: const Color(0xFFF58A33),
        checkColor: Colors.white,
      ),
    );
  }

  checkBoxMultiple(dynamic answers, int i) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFF58A33),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: Colors.white,
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          answers[i]['title'],
          style: const TextStyle(
            fontSize: 13.0,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w300,
          ),
        ),
        value: answers[i]['value'],
        onChanged: (bool? value) {
          setState(() {
            answers[i]['value'] = !(value ?? false);
          });
        },
        activeColor: const Color(0xFFF58A33),
        checkColor: Colors.white,
      ),
    );
  }
}
