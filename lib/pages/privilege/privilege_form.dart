import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/button_close_back.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:lc/shared/extension.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivilegeForm extends StatefulWidget {
  const PrivilegeForm(
      {super.key, @required this.code, this.model, this.urlRotation});
  final String? code;
  final dynamic model;
  final String? urlRotation;

  @override
  // ignore: library_private_types_in_public_api
  _PrivilegeDetailPageState createState() =>
      // ignore: no_logic_in_create_state
      _PrivilegeDetailPageState(code: code!);
}

class _PrivilegeDetailPageState extends State<PrivilegeForm> {
  _PrivilegeDetailPageState({required this.code});

  final storage = const FlutterSecureStorage();
  String profileCode = '';
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureRotation;
  // String _urlShared = '';
  String code;
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

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
    _futureRotation = postDio(widget.urlRotation!, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(privilegeGalleryApi, {'code': widget.code});

    // if (result['status'] == 'S') {
    List data = [];
    List<ImageProvider> dataPro = [];

    for (var item in result) {
      data.add(item['imageUrl']);

      dataPro.add(
        item['imageUrl'] != null
            ? NetworkImage(item['imageUrl'])
            : const AssetImage('assets/images/placeholder.png')
                as ImageProvider<Object>,
      );
    }
    setState(() {
      urlImage = data;
      urlImageProvider = dataPro;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
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
                return const BlankLoading();
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
              as ImageProvider<Object>
    ];
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          shrinkWrap: true,
          children: [
            Stack(
              children: [
                Container(
                    child: ListView(
                  shrinkWrap: true, // 1st add
                  physics: const ClampingScrollPhysics(), // 2nd
                  children: [
                    Container(
                      // width: 500.0,
                      color: const Color(0x0fffffff),
                      child: GalleryView(
                        imageUrl: [...image, ...urlImage],
                        imageProvider: [...imagePro, ...urlImageProvider],
                      ),
                    ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          'เข้าชม ' '${model['view']}' ' ครั้ง',
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
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      child: Html(
                        data: model['description'],
                        onLinkTap: (String? url, Map<String, String> attributes,
                            element) {
                          launch(url!);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    model['linkUrl'] != '' ? linkButton(model) : Container(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if (widget.urlRotation != '') _buildRotation(),
                  ],
                )),
                Positioned(
                  right: 0,
                  top: statusBarHeight + 5,
                  child: Container(
                    child: buttonCloseBack(context),
                  ),
                ),
              ],
              // overflow: Overflow.clip,
            ),
          ],
        ));
  }

  _buildRotation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: const Color(0xFFA9151D))),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
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
            child: Text(
              '${model['textButton']}' != ''
                  ? '${model['textButton']}'
                  : 'กดเพื่อดูลิงค์',
              style: const TextStyle(
                color: Color(0xFFA9151D),
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
