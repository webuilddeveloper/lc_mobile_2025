import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/button_close_back.dart';
import 'package:lc/component/comment.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';

// ignore: must_be_immutable
class NotificationExpireForm extends StatefulWidget {
  const NotificationExpireForm({
    super.key,
    required this.url,
    required this.code,
    this.model,
    required this.urlComment,
    required this.urlGallery,
  });

  final String url;
  final String code;
  final dynamic model;
  final String urlComment;
  final String urlGallery;

  @override
  // ignore: library_private_types_in_public_api
  _NotificationExpireForm createState() => _NotificationExpireForm();
}

class _NotificationExpireForm extends State<NotificationExpireForm> {
  late Comment comment;
  late int _limit;
  late Future<dynamic> _futureProfile;
  int totalExpireDate = 0;
  late String expireDate;

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    _loading();
    super.initState();
  }

  _loading() async {
    var profileCode = await storage.read(key: 'profileCode18');
    // if (profileCode != '' && profileCode != null) {
    setState(() {
      _limit = 10;

      _futureProfile = postDio(profileReadApi, {"code": profileCode});
      // comment = Comment(
      //   code: widget.code,
      //   url: widget.urlComment,
      //   model: post('${newsCommentApi}read',
      //       {'skip': 0, 'limit': _limit, 'code': widget.code}),
      //   limit: _limit,
      // );
    });

    var profile = await _futureProfile;
    setState(() {
      totalExpireDate = profile['totalExpireDate'].round();
      expireDate = profile['expiredate'];
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            // Expanded(
            //   child:
            Stack(
              // fit: StackFit.expand,
              // alignment: AlignmentDirectional.bottomCenter,
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              children: [
                _listView(widget.model),
                Positioned(
                  left: 0,
                  top: (height * 0.5 / 100),
                  child: Container(
                    child: buttonCloseBack(context),
                  ),
                ),
              ],
              // overflow: Overflow.clip,
            ),
            const SizedBox(
              height: 50,
            )
            // ),
            // widget.urlComment != '' ? comment : Container(),
          ],
        ),
      ),
    );
  }

  _listView(dynamic model) {
    return ListView(
      shrinkWrap: true, // 1st add
      physics: const ClampingScrollPhysics(), // 2nd
      children: [
        const SizedBox(
          height: 5.0,
        ),
        Container(
          // color: Colors.green,
          padding: const EdgeInsets.only(
            right: 10.0,
            left: 10.0,
          ),
          margin: const EdgeInsets.only(left: 10.0, top: 60.0),
          child: Text(
            '${model['title']}',
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B6CA8),
            ),
          ),
        ),
        model["category"] == "expireDate"
            ? Container(
                // color: Colors.green,
                padding: const EdgeInsets.only(
                  right: 10.0,
                  left: 10.0,
                ),
                margin: const EdgeInsets.only(left: 10.0, top: 15.0),
                child: Text(
                  totalExpireDate >= 0
                      ? 'หมดอายุวันที่ $expireDate เหลือเวลา $totalExpireDate วัน'
                      : 'หมดอายุวันที่ $expireDate เป็นเวลา ${totalExpireDate.abs()} วัน',
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            : Container(),
        model["category"] == "examPage"
            ? Container(
                // color: Colors.green,
                padding: const EdgeInsets.only(
                  right: 10.0,
                  left: 10.0,
                ),
                margin: const EdgeInsets.only(left: 10.0, top: 15.0),
                child: Text(
                  model["description"],
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            : Container(),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          color: const Color(0xFF707070).withOpacity(0.5),
          height: 1,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(model['imageUrlCreateBy']),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['createBy']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              model['createSendDate'] != null
                                  ? dateStringToDate(model['createSendDate'])
                                  : '',
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
      ],
    );
  }
}
