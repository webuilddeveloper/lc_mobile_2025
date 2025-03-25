import 'dart:ui';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:lc/shared/extension.dart';

import '../../component/loadingImageNetwork.dart';

class PrivilegeFormV3 extends StatefulWidget {
  PrivilegeFormV3(
      {Key? key, required this.code, this.model, required this.urlRotation})
      : super(key: key);
  final String code;
  final dynamic model;
  final String urlRotation;

  @override
  _PrivilegeDetailPageStateV3 createState() =>
      _PrivilegeDetailPageStateV3(code: code);
}

class _PrivilegeDetailPageStateV3 extends State<PrivilegeFormV3> {
  _PrivilegeDetailPageStateV3({required this.code});

  final storage = new FlutterSecureStorage();
  String profileCode = '';
  late Future<dynamic> _futureModel = Future.value();
  late Future<dynamic> _futureRotation;
  // String _urlShared = '';
  String code;
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];
  int _currentImage = 0;

  @override
  void initState() {
    readGallery();
    _read();
    super.initState();
  }

  _read() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    _futureModel = postDio(
        '${privilegeApi}read', {'skip': 0, 'limit': 1, 'code': widget.code});
    _futureRotation = postDio(widget.urlRotation, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(privilegeGalleryApi, {'code': widget.code});

    // if (result['status'] == 'S') {
    List data = [];
    List<ImageProvider> dataPro = [];

    for (var item in result) {
      data.add(item['imageUrl']);

      dataPro.add((item['imageUrl'] != null
          ? NetworkImage(item['imageUrl'])
          : null) as ImageProvider<Object>);
    }
    setState(() {
      urlImage = data;
      urlImageProvider = dataPro;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder<dynamic>(
          future: _futureModel, // function where you call your api
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            // AsyncSnapshot<Your object type>

            if (snapshot.hasData) {
              return myContent(snapshot.data[0]);
            } else {
              if (widget.model != null) {
                return myContent(widget.model);
              } else {
                return BlankLoading();
              }
            }
          },
        ),
      ),
    );
  }

  myContent(dynamic model) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : const AssetImage('assets/images/placeholder.png')
    ];

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          shrinkWrap: true, // 1st add
          physics: ClampingScrollPhysics(), // 2nd
          children: [
            // Container(
            //   // width: 500.0,
            //   color: Color(0xFFFFFFF),
            //   child: GalleryView(
            //     imageUrl: [...image, ...urlImage],
            //     imageProvider: [...imagePro, ...urlImageProvider],
            //   ),
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
                                  imageProviders:
                                      [model['imageUrl'], ...urlImage]
                                          .map(
                                            (e) => NetworkImage(e),
                                          )
                                          .toList(),
                                );
                              },
                            );
                          },
                          child: Container(
                            color: Color(0x268AD2FF),
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
                Positioned(
                  left: 15,
                  top: 10 + MediaQuery.of(context).padding.top,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        boxShadow: [
                          new BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.15),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: Offset(0, 5),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Color(0xFF2D9CED),
                      ),
                    ),
                  ),
                )
              ],
            ),

            Container(
              // color: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.only(right: 50.0, top: 10.0),
              child: Text(
                '${model['title']}',
                style: TextStyle(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      // CircleAvatar(
                      //   backgroundImage:
                      //       model['imageUrlCreateBy'] != null
                      //           ? NetworkImage(
                      //               model['imageUrlCreateBy'],
                      //             )
                      //           : null,
                      // ),
                      Container(
                        // padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'วันที่ ${dateStringToDate(model['createDate'])}' +
                                      ' | เข้าชม ' +
                                      '${model['view']}' +
                                      ' ครั้ง',
                                  // + ' | ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                // Text(
                                //   'เข้าชม ' +
                                //       '${model['view']}' +
                                //       ' ครั้ง',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     fontFamily: 'Kanit',
                                //     fontWeight: FontWeight.w400,
                                //   ),
                                // ),
                              ],
                            ),
                            Text(
                              model['userList'] != null
                                  ? 'โดย ${model['userList'][0]['firstName']} ${model['userList'][0]['lastName']}'
                                  : 'โดย ${model['createBy']}',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Container(
            //   height: 10,
            // ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Html(
                data: model['description'],
                onLinkTap:
                    (String? url, Map<String, String> attributes, element) {
                  launchInWebViewWithJavaScript(url!);
                  //open URL in webview, or launch URL in browser, or any other logic here
                },
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            model['linkUrl'] != '' ? linkButton(model) : Container(),
            SizedBox(
              height: 20.0,
            ),
            // if (widget.urlRotation != '') _buildRotation(),
          ],
        )

        // ListView(
        //   shrinkWrap: true,
        //   children: [
        //     Stack(
        //       children: [
        //         Container(
        //             child:

        //         // Positioned(
        //         //   right: 0,
        //         //   top: statusBarHeight + 5,
        //         //   child: Container(
        //         //     child: buttonCloseBack(context),
        //         //   ),
        //         // ),
        //       ],
        //       // overflow: Overflow.clip,
        //     ),
        //   ],
        // )
        );
  }

  _buildRotation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CarouselRotation(
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
      ),
    );
  }

  linkButton(dynamic model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
          color: Color(0xFFED6B2D),
          // minWidth: MediaQuery.of(context).size.width,
          height: 40,
          // minWidth: 50,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(73)),
          onPressed: () {
            if (model['isPostHeader'] ?? false) {
              var path = model['linkUrl'];
              if (profileCode != '') {
                var splitCheck = path.split('').reversed.join();
                if (splitCheck[0] != "/") {
                  path = path + "/";
                }
                var codeReplae = "P" +
                    profileCode.replaceAll('-', '') +
                    model['code'].replaceAll('-', '');
                launchInWebViewWithJavaScript('$path$codeReplae');
                // launchURL(path);
              }
            } else {
              launchInWebViewWithJavaScript(model['linkUrl']);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              '${model['textButton']}' != ''
                  ? '${model['textButton']}'
                  : 'กดเพื่อดูลิงค์',
              style: TextStyle(
                  color: Colors.white, fontFamily: 'Kanit', fontSize: 17),
            ),
          ),
        ),
      ],
    );
  }
}
