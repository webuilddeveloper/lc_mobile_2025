import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/header.dart';

import 'package:lc/component/teacher/image_circle.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/blank_page/toast_fail.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AnswerForm extends StatefulWidget {
  AnswerForm({Key? key, this.menuModel, this.question}) : super(key: key);

  final dynamic menuModel;
  final dynamic question;

  @override
  AnswerFormState createState() => AnswerFormState();
}

class AnswerFormState extends State<AnswerForm> {
  List<dynamic> items = [];
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureModelGallery;
  bool isShowReplyQuestion = false;
  List<bool> listShowReply = [false];
  int _limit = 0;
  String profileCode = '';
  String profileImageUrl = '';
  String profileFirstName = '';
  String profileLastName = '';
  List<ImageProvider> galleryItems = [];
  List<dynamic> gallerys = [];

  PageController pageController = PageController();

  final _scrollController = ScrollController();
  final titleEditingController = TextEditingController();
  final questionEditingController = TextEditingController();
  final List<TextEditingController> _controllers = [];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    initFunc();
    super.initState();
  }

  initFunc() async {
    await getStorage();
    readGallery();
    _onLoading();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color(0xFFFAFAF9),
        appBar: header(context, () => {Navigator.pop(context)},
            title: widget.menuModel['title']),
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: screen(),
        ),
      ),
    );
  }

  SizedBox screen() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: _refreshController,
        onLoading: _onLoading,
        footer: const ClassicFooter(
          loadingText: ' ',
          canLoadingText: ' ',
          idleText: ' ',
          idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
        ),
        child: ListView(
          controller: _scrollController,
          children: [
            cardQuestion(widget.question, 0, isShowReplyQuestion),
            futureList()
          ],
        ),
      ),
    );
  }

  FutureBuilder futureList() {
    return FutureBuilder<dynamic>(
      future: _futureModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return listData(snapshot.data);
          } else {
            return Container(
              height: 100,
              alignment: Alignment.center,
              child: const Text(
                'ยังไม่มีคำตอบ',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 90,
            child: const Center(
              child: Text(
                  'ไม่พบสัญญาณอินเตอร์เน็ต กรุณาตรวจสอบสัญญาณอินเตอร์เน็ต'),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                height: 150,
                child: const BlankLoading(),
              );
            },
          );
        }
      },
    );
  }

  ListView listData(dynamic model) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: model.length,
      itemBuilder: (context, index) {
        _controllers.add(TextEditingController());
        listShowReply.add(false);
        return cardAnswer(model[index], index, listShowReply[index]);
      },
    );
  }

  Container listViewImage() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7f7f7),
      height: 200,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: gallerys.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return ImageViewer(
                    initialIndex: index,
                    imageProviders: galleryItems,
                  );
                },
              );
            },
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Image.network(
                gallerys[index]['imageUrl'],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container cardQuestion(dynamic model, int index, bool isShowReply) {
    var imageUrlCreateBy = model['imageUrlCreateBy'];
    var title = model['title'];
    var createBy = model['createBy'];
    var createDate = model['createDate'];
    var description = model['description'];
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 5.0),
      padding:
          const EdgeInsets.only(left: 20.0, top: 10, bottom: 13, right: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Q:',
                style: TextStyle(fontFamily: 'Kanit', fontSize: 40.0),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontFamily: 'Kanit', fontSize: 15.0),
                    maxLines: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          description != ''
              ? Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
          gallerys.isNotEmpty ? listViewImage() : Container(),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 26.0),
              imageCircle(
                context,
                image: imageUrlCreateBy,
                width: 30.0,
                height: 30.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.4),
                child: Text(
                  createBy,
                  style: const TextStyle(fontFamily: 'Kanit', fontSize: 10.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 15.0),
              Container(
                padding: const EdgeInsets.all(5.0),
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  color: widget.question['isHighlight']
                      ? const Color(0xFF408C40)
                      : const Color(0xFF707070),
                  borderRadius: BorderRadius.circular(12.5),
                ),
                child: Image.asset(
                  'assets/logo/icons/check.png',
                ),
              ),
              const SizedBox(width: 7),
              Text(
                differenceCurrentDate(createDate),
                style: const TextStyle(fontFamily: 'Kanit', fontSize: 8.0),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 26.0),
              button(
                  title: 'ตอบกลับ',
                  color: Theme.of(context).primaryColor,
                  callback: () => {
                        setState(() {
                          isShowReplyQuestion = !isShowReplyQuestion;
                        })
                      }),
              const SizedBox(width: 10.0),
              profileCode == widget.question['profileCode']
                  ? button(
                      title: 'ลบคำถาม',
                      color: const Color(0xFF707070),
                      callback: () => {deleteDialog()},
                    )
                  : Container(),
            ],
          ),
          isShowReply
              ? rowReply(questionEditingController, model, index)
              : Container(),
        ],
      ),
    );
  }

  Container cardAnswer(dynamic model, int index, bool isShowReply) {
    var image = model['imageUrlCreateBy'] ?? '';
    var title = model['title'];
    var createBy = model['createBy'];
    return Container(
      color: model['isHighlight'] ? const Color(0xFFE9F2E9) : Colors.white,
      margin: const EdgeInsets.only(bottom: 5.0),
      padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 13),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model['category'],
                style: const TextStyle(fontFamily: 'Kanit', fontSize: 40.0),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontFamily: 'Kanit', fontSize: 15.0),
                    maxLines: 500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 46.0),
              imageCircle(
                context,
                image: image,
                width: 30.0,
                height: 30.0,
                margin: null,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                createBy,
                style: const TextStyle(fontFamily: 'Kanit', fontSize: 10.0),
              ),
              const SizedBox(width: 20.0),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const SizedBox(width: 26.0),
              button(
                  title: 'ตอบกลับ',
                  color: Theme.of(context).primaryColor,
                  callback: () => {
                        setState(() {
                          listShowReply[index] = !listShowReply[index];
                        })
                      }),
              const SizedBox(width: 10.0),
              button(
                title: 'คำตอบนี้ดีที่สุด',
                color: model['isHighlight']
                    ? const Color(0xFF408C40)
                    : const Color(0xFFEEBA33),
                callback: () => {update(model, index)},
              )
            ],
          ),
          isShowReply
              ? Row(
                  children: [
                    Expanded(
                      child: rowReply(_controllers[index], model, index),
                    )
                  ],
                )
              : Container()
        ],
      ),
    );
  }

  InkWell button({
    String title = '',
    Color color = Colors.white,
    VoidCallback? callback,
  }) {
    return InkWell(
      onTap: callback,
      child: Container(
        alignment: Alignment.center,
        height: 20,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Kanit',
            fontSize: 8.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  deleteDialog() {
    return showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CupertinoAlertDialog(
            title: const Text(
              'คุณต้องการลบคำถามนี้หรือไม่',
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
                child: Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  delete();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "ยกเลิก",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Container rowReply(
    TextEditingController textEditingController,
    dynamic model,
    int index,
  ) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              // maxLines: 2,
              style: const TextStyle(
                // color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                fontSize: 12.0,
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blueGrey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.only(
                  left: 10.0,
                  // right: 10.0,
                  top: 15.0,
                ),
                hintText: '',
                errorStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 12.0,
                ),
              ),
              validator: (model) {
                return '';
              },
              controller: textEditingController,
              // enabled: true,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              if (textEditingController.text != '') {
                FocusScope.of(context).unfocus();
                sendAnswer(textEditingController, model, index);
                // toastFail(context, text: 'ส่ง');
              } else {
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.blueAccent,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  getStorage() async {
    final storage = FlutterSecureStorage();
    var code = await storage.read(key: 'profileCode18');
    var imageUrl = await storage.read(key: 'profileImageUrl');
    var firstName = await storage.read(key: 'profileFirstName');
    var lastName = await storage.read(key: 'profileLastName');
    setState(() {
      profileCode = code!;
      profileImageUrl = imageUrl!;
      profileFirstName = firstName!;
      profileLastName = lastName!;
    });
    print(profileCode);
    print(profileImageUrl);
    print(profileFirstName);
    print(profileLastName);
  }

  _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      _futureModel = post(answerApi + 'read', {
        'limit': _limit,
        'skip': 0,
        'reference': widget.question['code'],
        'profileCode': profileCode
      });
    });

    await Future.delayed(const Duration(milliseconds: 2000));

    _refreshController.loadComplete();
  }

  readGallery() {
    _futureModelGallery = post(questionApi + 'gallery/read',
        {'limit': 10, 'skip': 0, 'reference': widget.question['code']}).then(
      (value) => {
        setState(
          () {
            if (value != null && value.length > 0) {
              gallerys = value;
              value.forEach((e) {
                galleryItems.add(NetworkImage(e['imageUrl']));
              });
            }
          },
        ),
      },
    );
  }

  update(dynamic model, int index) {
    if (profileCode == widget.question['profileCode']) {
      bool highlight = model['isHighlight'];
      highlight = !highlight;
      post(answerApi + 'update', {
        'code': model['code'],
        'isHighlight': highlight,
        'profileCode': profileCode,
        'reference': widget.question['code']
      }).then(
        (value) => {
          setState(
            () {
              _futureModel = post(
                answerApi + 'read',
                {
                  'limit': _limit,
                  'skip': 0,
                  'reference': widget.question['code'],
                  'profileCode': profileCode
                },
              );
            },
          )
        },
      );
    } else {
      // to do..
    }
  }

  sendAnswer(
    TextEditingController textEditingController,
    dynamic model,
    int index,
  ) {
    post(answerApi + 'create', {
      'isHighlight': model['isHighlight'],
      'profileCode': profileCode,
      'createBy': profileFirstName + ' ' + profileLastName,
      'status': model['status'],
      'createDate': model['createDate'],
      'reference': widget.question['code'],
      'title': textEditingController.text
    }).then((value) => {
          listShowReply[index] = false,
          listShowReply.add(false),
          isShowReplyQuestion = false,
          textEditingController.text = '',
          _onLoading()
        });

    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: Duration(seconds: 2),
    //   curve: Curves.fastOutSlowIn,
    // );

    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  delete() {
    try {
      post(questionApi + 'delete', widget.question).then((value) => {
            print(value),
            Navigator.of(context).pop(),
            Navigator.of(context).pop(),
          });
    } catch (ex) {
      return toastFail(context);
    }
  }
// .end
}
