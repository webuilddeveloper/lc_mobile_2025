import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lc/component/header.dart';
import 'package:lc/models/user.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/blank_page/toast_fail.dart';
import 'package:lc/pages/event_calendar/event_calendar_form.dart';
import 'package:lc/pages/knowledge/knowledge_form.dart';
import 'package:lc/pages/news/news_form.dart';
import 'package:lc/pages/notification/notification_expireform.dart';
import 'package:lc/pages/poi/poi_form.dart';
import 'package:lc/pages/poll/poll_form.dart';
import 'package:lc/pages/privilege/privilege_form.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:lc/pages/notification/main_page_form.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key, this.title, this.userData});

  final User? userData;
  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> {
  late Future<dynamic> _futureModel;

  @override
  void initState() {
    _loading();
    super.initState();
  }

  _loading() async {
    // var profileCode = await storage.read(key: 'profileCode18');
    // if (profileCode != '' && profileCode != null) {
    setState(() {
      // _futureProfile = postDio(profileReadApi, {"code": profileCode});

      _futureModel = postDio(
        '${notificationApi}read',
        {
          'skip': 0,
          'limit': 999,
          // 'profileCode': profileCode,
        },
      );
    });
    // }
  }

  checkNavigationPage(String page, dynamic model) {
    switch (page) {
      case 'newsPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => _loading());
        }
        break;

      case 'eventPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCalendarFormPage(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => _loading());
        }
        break;

      case 'privilegePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivilegeForm(
                code: model['reference'],
                model: model,
                urlRotation: rotationPrivilegeApi,
              ),
            ),
          ).then((value) => _loading());
        }
        break;

      case 'knowledgePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnowledgeForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => _loading());
        }
        break;

      case 'poiPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoiForm(
                url: poiApi + 'read',
                code: model['reference'],
                model: model,
                urlComment: poiCommentApi,
                urlGallery: poiGalleryApi,
              ),
            ),
          ).then((value) => _loading());
        }
        break;

      case 'pollPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PollForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => _loading());
        }
        break;

      case 'mainPage':
        {
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainPageForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => _loading());
        }

      case 'expireDate':
        {
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationExpireForm(
                code: model['reference'],
                model: model, url: '', urlComment: '', urlGallery: '',
              ),
            ),
          ).then((value) => {_loading()});
        }
      case 'examPage':
        {
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationExpireForm(
                code: model['reference'],
                model: model, url: '', urlComment: '', urlGallery: '',
              ),
            ),
          ).then((value) => {_loading()});
        }
      default:
        {
          return toastFail(context, text: 'เกิดข้อผิดพลาด');
        }
    }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: header(
          context,
          () => goBack(),
          title: widget.title!,
          isButtonRight: true,
          rightButton: () => _handleClickMe(),
          menu: 'notification',
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: _futureModel, // function where you call your api
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.separated(
                  shrinkWrap: true, // 1st add
                  physics: const ClampingScrollPhysics(), // 2nd
                  // scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return card(context, snapshot.data[index]);
                  },
                );
              } else {
                return Container(
                  width: width,
                  margin: EdgeInsets.only(top: height * 30 / 100),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        width: width,
                        child: Image.asset(
                          'assets/logo/logo.png',
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 1 / 100),
                        alignment: Alignment.center,
                        width: width,
                        child: const Text(
                          'ไม่พบข้อมูล',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return SizedBox(
                width: width,
                height: height,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _futureModel = post(
                        '${notificationApi}read',
                        {
                          'skip': 0,
                          'limit': 999,
                          'username': widget.userData?.username
                        },
                      );
                    });
                  },
                  child: const Icon(Icons.refresh, size: 50.0, color: Colors.blue),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true, // 1st add
                physics: const ClampingScrollPhysics(), // 2nd
                // scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return BlankLoading(
                    width: width,
                    height: height * 15 / 100,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  card(BuildContext context, dynamic model) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () async {
        await postDio(
          '${notificationApi}update',
          {'category': '${model['category']}', "code": '${model['code']}'},
        );
        checkNavigationPage(model['category'], model);
        // .then((response) {
        //   if (response == 'S') {
        //     // checkNavigationPage(model['category'], model);
        //   }
        // })
      },
      child: Slidable(
        endActionPane: ActionPane(
          // ✅ ใช้ ActionPane แทน
          motion:
              const DrawerMotion(), // ✅ ใช้ DrawerMotion() แทน SlidableDrawerActionPane()
          children: [
            SlidableAction(
              onPressed: (context) {
                // เพิ่มฟังก์ชันเมื่อกดปุ่ม เช่น ลบหรืออ่านแจ้งเตือน
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'ลบ',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: model['status'] == 'A' ? Colors.white : const Color(0xFFE7E7EE),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (model['status'] != 'A')
                      Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red,
                        ),
                      ),
                    if (model['status'] != 'A') const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${model['title']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF9D040C),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                parseHtmlString(model['description']),
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                '${dateStringToDate(model['createSendDate'])}',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleClickMe() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(
                'อ่านทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                ),
              ),
              onPressed: () {
                setState(() {
                  postAny('${notificationApi}update', {
                    'username': widget.userData!.username,
                  }).then((response) {
                    if (response == 'S') {
                      setState(() {
                        _futureModel = post(
                          '${notificationApi}read',
                          {
                            'skip': 0,
                            'limit': 999,
                            'username': widget.userData!.username
                          },
                        );
                      });
                    }
                  });
                });
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                'ลบทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                setState(() async {
                  await postDio('${notificationApi}delete', {});
                  setState(() {
                    _loading();
                  });
                });
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('ยกเลิก',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                )),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
