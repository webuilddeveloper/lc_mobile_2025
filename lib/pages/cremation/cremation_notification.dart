import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../notification/main_page_form.dart';

class CremationNotificationForm extends StatefulWidget {
  const CremationNotificationForm({Key? key, @required this.title})
      : super(key: key);

  final title;

  @override
  State<CremationNotificationForm> createState() =>
      _CremationNotificationFormState();
}

class _CremationNotificationFormState extends State<CremationNotificationForm>
    with TickerProviderStateMixin {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureProfile;
  final storage = new FlutterSecureStorage();

  dynamic profileCode;
  dynamic _username = '';
  dynamic _category = '';

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color(0x408AD2FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF2D9CED),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                footer: ClassicFooter(
                  loadingText: ' ',
                  canLoadingText: ' ',
                  idleText: ' ',
                  idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
                ),
                controller: _refreshController,
                onLoading: _onLoading,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [_buildNotification()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotification() {
    return FutureBuilder<dynamic>(
      future: _futureModel,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('ไม่พบข้อมูล'),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              itemCount: snapshot.data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (_, __) =>
                  cardV2(context, snapshot.data.toList()[__]),
            );
          }
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget cardV2(BuildContext context, dynamic model) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onLongPress: () {
        _DialogDelete(model);
      },
      onTap: () async {
        await postDio(
          '${server}m/v2/notification/update',
          {'category': '${model['category']}', "code": '${model['code']}'},
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPageForm(
              code: model['reference'],
              model: model,
            ),
          ),
        ).then((value) => {_callRead()});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: (height * 13) / 100,
        // width:isCheckSelect ? (width*20)/100,
        decoration: BoxDecoration(
          color: model['status'] == 'A' ? Color(0xFFFFFFFF) : Color(0xFFF2FAFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // color: Colors.red,
                  width: (width * 70) / 100,
                  padding: EdgeInsets.fromLTRB(8, 8, 0, 0),
                  child: Text(
                    '${model['description']}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(8, 0, 0, 5),
                  child: Text(
                    '${dateStringToDateStringFormat(model['createDate'])}',
                    style: TextStyle(
                      color: Color(0xFFB7B7B7),
                      fontFamily: 'Arial',
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height * 1 / 100),
                image: DecorationImage(
                  image: AssetImage("assets/images/icon_right.png"),
                  fit: BoxFit.contain,
                ),
              ),
              height: height * 2 / 100,
              width: height * 2 / 100,
            ),
          ],
        ),
      ),
    );
  }

  _DialogDelete(dynamic model) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.all(0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF2D9CED),
                  size: 35,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'ต้องการลบรายการที่เลือก ออกจากแจ้งเตือนใช่หรือไม่',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF2D9CED),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width / 100) * 30,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(10)),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFFB7B7B7))))),
                  child: Text(
                    "ยกเลิก",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                        color: Color(0xFF000000)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 20),
              Container(
                width: (MediaQuery.of(context).size.width / 100) * 30,
                margin: EdgeInsets.symmetric(vertical: 20.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF2D9CED),
                  child: MaterialButton(
                    height: 30,
                    onPressed: () async {
                      setState(() {
                        // isLoading = true;
                        Navigator.pop(context);
                      });
                      await postDio(
                          '${server}cremation/notification/deleteSelect',
                          model);

                      setState(() {
                        _onLoading();
                        // isLoading = false;
                      });
                    },
                    child: new Text(
                      'ใช่',
                      style: new TextStyle(
                        fontSize: 17.0,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).then((value) => _onLoading());
  }

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() async {
    profileCode = await storage.read(key: 'profileCode18');
    if (profileCode != '' && profileCode != null)
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
    var _profile = await _futureProfile;
    if (_profile != null) {
      _username = _profile["username"];
      _category = _profile["category"];
    }

    setState(() {
      _futureModel = postDio(
        '${server}m/v2/notification/read',
        {
          "username": _username,
          "category": _category,
          'skip': 0,
          'limit': 999,
          "createBy": "cremationPage",
          // 'profileCode': profileCode,
        },
      );
    });
  }

  void _onLoading() async {
    setState(() {
      _futureModel = postDio(
        '${server}m/v2/notification/read',
        {
          "username": _username,
          "category": _category,
          'skip': 0,
          'limit': 999,
          "createBy": "cremationPage",
          // 'profileCode': profileCode,
        },
      );
    });
    await Future.delayed(Duration(milliseconds: 2000));

    _refreshController.loadComplete();
  }
}
