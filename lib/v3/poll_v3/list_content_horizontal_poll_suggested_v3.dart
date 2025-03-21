import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lc/component/sso/list_content_horizontal_loading.dart';
import 'package:lc/shared/extension.dart';
import 'package:lc/v3/poll_v3/poll_details_v3.dart';

import '../../component/loadingImageNetwork.dart';
import '../../pages/blank_page/toast_fail.dart';

// ignore: must_be_immutable
class ListContentHorizontalPollSuggestedV3 extends StatefulWidget {
  const ListContentHorizontalPollSuggestedV3(
      {super.key,
      required this.title,
      required this.url,
      required this.model,
      required this.urlComment,
      required this.callBack,
      required this.navigationList,
      required this.navigationForm});

  final String title;
  final String url;
  final Future<dynamic> model;
  final String urlComment;
  final Function callBack;
  final Function() navigationList;
  final Function(String, dynamic) navigationForm;

  @override
  _ListContentHorizontalPollSuggestedV3 createState() =>
      _ListContentHorizontalPollSuggestedV3();
}

class _ListContentHorizontalPollSuggestedV3
    extends State<ListContentHorizontalPollSuggestedV3> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350,
          color: Colors.transparent,
          child: renderCard(widget.title, widget.url, widget.model,
              widget.urlComment, widget.navigationForm),
        ),
      ],
    );
  }

  heightCalculate(double height) {
    return (((MediaQuery.of(context).size.width *
                    MediaQuery.of(context).size.height) /
                MediaQuery.of(context).size.height) -
            MediaQuery.of(context).size.width) +
        height;
  }

  renderCard(String title, String url, Future<dynamic> model, String urlComment,
      Function navigationForm) {
    return FutureBuilder<dynamic>(
      future: model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return snapshot.data[index]['isHighlight']
                  ? myCard(index, snapshot.data.length, snapshot.data[index],
                      context, navigationForm)
                  : SizedBox();
            },
          );
          // } else if (snapshot.hasError) {
          //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListContentHorizontalLoading();
            },
          );
        }
      },
    );
  }

  myCard(int index, int lastIndex, dynamic model, BuildContext context,
      Function navigationForm) {
    return InkWell(
      onTap: () {
        navigationForm(model['code'], model);
      },
      child: Column(
        children: [
          Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: Color(0xFF000000)
                  ),
                  margin: index == 0
                      ? EdgeInsets.only(left: 10.0, right: 5.0)
                      : index == lastIndex - 1
                          ? EdgeInsets.only(left: 5.0, right: 15.0)
                          : EdgeInsets.symmetric(horizontal: 5.0),
                  // height: 334,
                  height: heightCalculate(340),
                  width: heightCalculate(340),
                  child: GestureDetector(
                    onTap: () {
                      model['status2']
                          ? toastFail(context, text: 'คุณตอบแบบสอบถามนี้แล้ว')
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PollDetailsV3(
                                    code: model['code'],
                                    model: model,
                                    titleMenu: widget.title,
                                    titleHome: widget.title,
                                    url: widget.url),
                              ),
                            ).then((value) => widget.navigationList());
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0x268AD2FF),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: loadingImageNetwork(
                              model['imageUrl'],
                              height: MediaQuery.of(context).size.width - 30,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 15,
                          right: 15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              // height: 98,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF).withOpacity(0.6),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 5,
                                  sigmaY: 5,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${model['title']}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${model['createDate']}' != null
                                          ? dateStringToDate(
                                              '${model['createDate']}')
                                          : '',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
