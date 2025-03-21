import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lc/pages/blank_page/blank_data.dart';
import 'package:lc/pages/blank_page/toast_fail.dart';
import 'package:lc/shared/extension.dart';
import 'package:flutter/rendering.dart';
import 'package:lc/v3/poll_v3/poll_details_v3.dart';

import '../../component/loadingImageNetwork.dart';

class PollListVerticalV3 extends StatefulWidget {
  PollListVerticalV3(
      {Key? key,
      required this.site,
      required this.model,
      required this.title,
      required this.url,
      required this.urlComment,
      required this.urlGallery,
      required this.titleHome,
      this.callBack})
      : super(key: key);

  final String site;
  final Future<dynamic> model;
  final String title;
  final String url;
  final String urlComment;
  final String urlGallery;
  final String titleHome;
  final Function? callBack;

  @override
  _PollListVerticalV3 createState() => _PollListVerticalV3();
}

class _PollListVerticalV3 extends State<PollListVerticalV3> {
  int _carouselNewsIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(), // 2nd
              children: [
                // ListContentHorizontalPollSuggestedV3(
                //   model: widget.model,
                //   callBack: () => widget.callBack(), //,
                // ),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: MediaQuery.of(context).size.width - 30 + 37,
                      width: double.infinity,
                      child: CarouselSlider(
                        items: snapshot.data
                            .take(8)
                            .map<Widget>((e) => _buildHighlightItem(e))
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 1,
                          viewportFraction: 1,
                          onPageChanged: (i, value) {
                            setState(() {
                              _carouselNewsIndex = i;
                            });
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: snapshot.data.take(8).map<Widget>(
                          (e) {
                            int index = snapshot.data.indexOf(e);
                            bool thisCarousel = _carouselNewsIndex == index;
                            return Container(
                              width: thisCarousel ? 17.5 : 7,
                              height: 7,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: thisCarousel
                                    ? Color(0xFF8AD2FF)
                                    : Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xFF8AD2FF),
                                ),
                                borderRadius: BorderRadius.circular(3.5),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ListView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          snapshot.data[index]['status2']
                              ? toastFail(context,
                                  text: 'คุณตอบแบบสอบถามนี้แล้ว')
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PollDetailsV3(
                                        code: snapshot.data[index]['code'],
                                        model: snapshot.data[index],
                                        titleMenu: widget.title,
                                        titleHome: widget.titleHome,
                                        url: widget.url),
                                  ),
                                ).then((value) => widget.callBack!());
                        },
                        child: Container(
                          height: 100,
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: loadingImageNetwork(
                                    '${snapshot.data[index]['imageUrl']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    width: width * 60 / 100,
                                    margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Text(
                                      '${snapshot.data[index]['title']}',
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontFamily: 'Kanit',
                                        fontSize: 15,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Text(
                                      dateStringToDate(
                                          snapshot.data[index]['createDate']),
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontFamily: 'Kanit',
                                        fontSize: 10,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        } else {
          return blankListData(context);
        }
      },
    );
  }

  Widget _buildHighlightItem(dynamic model) {
    return GestureDetector(
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
                      titleHome: widget.titleHome,
                      url: widget.url),
                ),
              ).then((value) => widget.callBack!());
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
            bottom: 50,
            left: 15,
            right: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 98,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0x99FFFFFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            ? dateStringToDate('${model['createDate']}')
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
    );
  }
}
