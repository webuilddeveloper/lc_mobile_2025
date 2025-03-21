import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/models/user.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/poll/poll_dialog.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:lc/shared/extension.dart';
import 'package:lc/v3/poll_v3/poll_form_v3.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../component/loadingImageNetwork.dart';
import '../widget/header_v3.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class PollDetailsV3 extends StatefulWidget {
  PollDetailsV3({
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
  _PollDetailV3PageState createState() => _PollDetailV3PageState(code: code);
}

class _PollDetailV3PageState extends State<PollDetailsV3> {
  _PollDetailV3PageState({Key? key, required this.code});

  final _textEditingController = TextEditingController();

  late User userData;
  late FlutterSecureStorage storage;
  late Future<dynamic> _futureModel;
  late String code;
  late List urlImage = [];
  late List<ImageProvider> urlImageProvider = [];
  late int _selectedIndex;
  // String _urlShared = '';
  int _currentImage = 0;

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
                return Container(
                  child: Stack(
                    children: [
                      BlankLoading(),
                      // Positioned(
                      //   right: 0,
                      //   top: statusBarHeight + 5,
                      //   child: Container(
                      //     child: buttonCloseBack(context),
                      //   ),
                      // ),
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
    // Navigator.pop(context);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PollListV3(
    //       title: widget.titleHome,
    //       userData: userData,
    //     ),
    //   ),
    // );
    Navigator.pop(context);
  }

  myCard({dynamic model, dynamic questions, dynamic answer}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : const AssetImage('assets/images/placeholder.png')
    ];
    return Container(
      // alignment: Alignment.bottomCenter,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                            color: Color(0xFFFFFFF),
                            child:
                                // GalleryView(
                                //   imageUrl: [...image, ...urlImage],
                                //   imageProvider: [...imagePro, ...urlImageProvider],
                                // ),
                                Stack(
                              children: [
                                CarouselSlider(
                                  items: [model['imageUrl'], ...urlImage]
                                      .map<Widget>(
                                        (e) => GestureDetector(
                                          onTap: () {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return ImageViewer(
                                                  initialIndex: _currentImage,
                                                  imageProviders: [
                                                    model['imageUrl'],
                                                    ...urlImage
                                                  ]
                                                      .map(
                                                        (e) => NetworkImage(e),
                                                      )
                                                      .toList(),
                                                );
                                              },
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: loadingImageNetwork(
                                              e,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // Container(
                                          //   // decoration: BoxDecoration(
                                          //   //   // borderRadius: BorderRadius.circular(20)
                                          //   // ),
                                          //   color: Color(0x268AD2FF),
                                          //   // child: loadingImageNetwork(
                                          //   //   e,
                                          //   //   height: MediaQuery.of(context)
                                          //   //       .size
                                          //   //       .width,
                                          //   //   width: double.infinity,
                                          //   //   fit: BoxFit.cover,
                                          //   // ),
                                          //   child:
                                          // ),
                                        ),
                                      )
                                      .toList(),
                                  options: CarouselOptions(
                                      viewportFraction: 1,
                                      enableInfiniteScroll: false,
                                      height: MediaQuery.of(context).size.width,
                                      onPageChanged: (i, _) {
                                        setState(() {
                                          _currentImage = i;
                                        });
                                      }),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 15,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      '${_currentImage + 1}/${[
                                        model['imageUrl'],
                                        ...urlImage
                                      ].length}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      Container(
                        // color: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        margin: EdgeInsets.only(right: 50.0, top: 10.0),
                        child: Text(
                          '${model['title']}',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'วันที่ ${dateStringToDate(model['createDate'])}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    model['userList'] != null
                                        ? 'โดย ${model['userList'][0]['firstName']} ${model['userList'][0]['lastName']}'
                                        : 'โดย ${model['createBy']}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 25,
                                width: 25,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFFF2FAFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Image.asset(
                                  'assets/images/share_2.png',
                                  width: 17,
                                  height: 17,
                                  color: Color(0xFF2D9CED),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Html(
                          data: model['description'],
                          onLinkTap: (String? url,
                              Map<String, String> attributes, element) {
                            launch(url!);
                            //open URL in webview, or launch URL in browser, or any other logic here
                          },
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: width * 25 / 100),
                        child: MaterialButton(
                          elevation: 0,
                          color: Color(0xFFED6B2D),
                          // minWidth: MediaQuery.of(context).size.width,
                          height: 40,
                          // minWidth: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(73)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PollFormV3(
                                  model: model,
                                  code: widget.code,
                                  url: '',
                                  titleMenu: '',
                                  titleHome: '',
                                ),
                              ),
                            );
                            // pollReply(model);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'เริ่มทำ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontSize: 17),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  textBox(TextEditingController _textEditingController, dynamic item, int i) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: TextField(
        controller: _textEditingController,
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
        style: TextStyle(
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
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFF58A33),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: Colors.white,
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          answers[i]['title'],
          style: TextStyle(
            fontSize: 13.0,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w300,
          ),
        ),
        value: answers[i]['value'],
        onChanged: (bool? newValue) {
          setState(() {
            _selectedIndex = i;
            for (int j = 0; j < answers.length; j++) {
              answers[j]['value'] =
                  (j == _selectedIndex) ? (newValue ?? false) : false;
            }
          });
        },
        activeColor: Color(0xFFF58A33),
        checkColor: Colors.white,
      ),
    );
  }

  checkBoxMultiple(dynamic answers, int i) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 15.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFF58A33),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: Colors.white,
      ),
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          answers[i]['title'],
          style: TextStyle(
            fontSize: 13.0,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w300,
          ),
        ),
        value: answers[i]['value'], // Ensure 'value' is of type bool?
        onChanged: (bool? newValue) {
          setState(() {
            answers[i]['value'] = newValue ?? false;
          });
        },
        activeColor: Color(0xFFF58A33),
        checkColor: Colors.white,
      ),
    );
  }
}
