import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/comment.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/component/loadingImageNetwork.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:lc/shared/scroll_behavior.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class EventCalendarFormPage extends StatefulWidget {
  const EventCalendarFormPage({super.key, this.model, @required this.code});

  final String? code;
  final dynamic model;

  @override
  State<EventCalendarFormPage> createState() => _EventCalendarFormPageState();
}

class _EventCalendarFormPageState extends State<EventCalendarFormPage> {
  dynamic model;
  int _currentImage = 0;
  List<dynamic> _galleries = [];
  late Future<dynamic> _futureRotation;
  String _urlShared = '';
  late Comment comment;
  int _limit = 10;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: ScrollConfiguration(
          behavior: CsBehavior(),
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            footer: const ClassicFooter(
              loadingText: ' ',
              canLoadingText: ' ',
              idleText: ' ',
              idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
            ),
            controller: _refreshController,
            onLoading: _onLoading,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    CarouselSlider(
                      items: [model['imageUrl'], ..._galleries]
                          .map<Widget>(
                            (e) => GestureDetector(
                              onTap: () {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return ImageViewer(
                                      initialIndex: _currentImage,
                                      imageProviders:
                                          [model['imageUrl'], ..._galleries]
                                              .map(
                                                (e) => NetworkImage(e),
                                              )
                                              .toList(),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                color: const Color(0x268AD2FF),
                                child: loadingImageNetwork(
                                  e,
                                  height: MediaQuery.of(context).size.width,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                        padding: const EdgeInsets.symmetric(
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
                            ..._galleries
                          ].length}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: 10 + MediaQuery.of(context).padding.top,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF2D9CED),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model['title']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // ignore: unnecessary_null_comparison
                                  '${model['createDate']}' != null
                                      // ignore: prefer_interpolation_to_compose_strings
                                      ? '${'วันที่ ' + dateStringToDate('${model['createDate']}')} | เข้าชม ${model['view']} ครั้ง'
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  // ignore: unnecessary_null_comparison
                                  '${model['createBy']}' != null
                                      ? 'โดย ${model['createBy']}'
                                      : '',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final RenderBox? box =
                                  context.findRenderObject() as RenderBox?;
                              Share.share(
                                '${_urlShared}content/eventCaledar/${model['code']} ${model['title']}',
                                subject: '${model['title']}',
                                sharePositionOrigin:
                                    box!.localToGlobal(Offset.zero) & box.size,
                              );
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2FAFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/images/share_2.png',
                                width: 17,
                                height: 17,
                                color: const Color(0xFF2D9CED),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 11),
                      Html(
                        data: model['description'],
                        style: {
                          'body': Style(
                            color: const Color(0xFF000000),
                          ),
                        },
                        onLinkTap: (String? url, Map<String, String> attributes,
                            element) {
                          launch(url!);
                          //open URL in webview, or launch URL in browser, or any other logic here
                        },
                      ),
                      const SizedBox(height: 5),
                      const SizedBox(height: 35),
                      model['linkUrl'] != '' ? linkButton(model) : Container(),
                      Container(
                        height: 10,
                      ),
                      model['fileUrl'] != '' ? fileUrl(model) : Container(),
                      const SizedBox(height: 10),
                      _buildRotation(),
                      comment,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fileUrl(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launchInWebViewWithJavaScript('${model['fileUrl']}');
        },
        child: const Text(
          'เปิดเอกสารแนบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14.0,
            color: Color(0xFFFF7514),
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  _buildRotation() {
    return CarouselRotation(
      model: _futureRotation,
      nav: (String path, String action, dynamic model, String code) {
        if (action == 'out') {
          launchInWebViewWithJavaScript(path);
          // launchURL(path);
        } else if (action == 'in') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarouselForm(
                code: code,
                model: model,
                url: mainBannerApi,
                urlGallery: bannerGalleryApi,
              ),
            ),
          );
        }
      },
    );
  }

  linkButton(dynamic model) {
    return Container(
      alignment: Alignment.center,
      height: 45.0,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: const Color(0xFFFF7514),
            ),
          ),
          child: MaterialButton(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            onPressed: () {
              launchInWebViewWithJavaScript('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: const TextStyle(
                color: Color(0xFFFF7514),
                fontFamily: 'Kanit',
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  initState() {
    model = widget.model;
    _futureRotation = postDio(rotationEvantCalendarApi, {'limit': 10});
    comment = Comment(
      code: widget.code!,
      url: eventCalendarCommentApi,
      model: postDio('${eventCalendarCommentApi}read',
          {'skip': 0, 'limit': _limit, 'code': widget.code}),
      limit: _limit,
    );
    sharedApi();
    _callRead();
    _readGallery();
    _sendReportCategory();
    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      comment = Comment(
        code: widget.code!,
        url: eventCalendarCommentApi,
        model: postDio('${eventCalendarCommentApi}read',
            {'skip': 0, 'limit': _limit, 'code': widget.code}),
        limit: _limit,
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  Future<dynamic> sharedApi() async {
    await postConfigShare().then(
      (result) => {
        if (result['status'] == 'S')
          {
            setState(() {
              _urlShared = result['objectData']['description'];
            }),
          }
      },
    );
  }

  _callRead() async {
    var response = await postDio('${newsApi}read', {'code': widget.code});
    setState(() {
      model = response[0];
    });
  }

  _sendReportCategory() {
    postCategory(
      '${newsCategoryApi}read',
      {'skip': 0, 'limit': 1, 'code': widget.model['category']},
    );
  }

  Future<dynamic> _readGallery() async {
    var result = await postDio(newsGalleryApi, {'code': widget.code});

    if (result != null) {
      List data = [];
      for (var item in result) {
        data.add(item['imageUrl']);
      }
      setState(() {
        _galleries = data;
      });
    }
  }
}
