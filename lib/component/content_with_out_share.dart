// ignore_for_file: unused_field, library_private_types_in_public_api, deprecated_member_use

import 'package:flutter_html/flutter_html.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:flutter/material.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/shared/extension.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ContentWithOutShare extends StatefulWidget {
  const ContentWithOutShare({
    super.key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
    required this.urlRotation,
  });

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;
  final String urlRotation;

  @override
  _ContentWithOutShare createState() => _ContentWithOutShare();
}

class _ContentWithOutShare extends State<ContentWithOutShare> {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureRotation;
  final storage = const FlutterSecureStorage();

  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    initFunc();

    readGallery();
  }

  initFunc() async {
    _futureModel =
        postDio(widget.url, {'skip': 0, 'limit': 1, 'code': widget.code});
    _futureRotation = postDio(widget.urlRotation, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(widget.urlGallery, {'code': widget.code});

    // if (result['status'] == 'S') {
    List data = [];
    List<ImageProvider> dataPro = [];

    for (var item in result) {
      data.add(item['imageUrl']);

      dataPro.add(
        (item['imageUrl'] != null ? NetworkImage(item['imageUrl']) : null)
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
    return myContentWithOutShare(
      widget.model,
    );
  }

  myContentWithOutShare(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : const AssetImage('assets/images/placeholder.png')
    ];
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true, // 1st add
      physics: const ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          // width: 500.0,
          // color: Color(0xFFFFFFF),
          color: Colors.white,
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
                              model['createDate'] != null
                                  ? dateStringToDate(model['createDate'])
                                  // + ' | '
                                  : '',
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            // Text(
                            //   'เข้าชม ' + '${model['view']}' + ' ครั้ง',
                            //   style: TextStyle(
                            //     fontSize: 10,
                            //     fontFamily: 'Kanit',
                            //     fontWeight: FontWeight.w300,
                            //   ),
                            // ),
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
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Html(
            data: model['description'],
            onLinkTap: (String? url, Map<String, String> attributes, element) {
              launch(url!);
              //open URL in webview, or launch URL in browser, or any other logic here
            },
          ),
        ),
        Container(
          height: 10,
        ),
        model['linkUrl'] != '' ? linkButton(model) : Container(),
        Container(
          height: 10,
        ),
        model['fileUrl'] != '' ? fileUrl(model) : Container(),
        const SizedBox(height: 10),
        if (widget.urlRotation != '') _buildRotation()
      ],
    );
  }

  linkButton(dynamic model) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.0,
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: const Color(0xFFE7CF72),
            ),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              launchInWebViewWithJavaScript('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: const TextStyle(
                color: Color(0xFF1B6CA8),
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
            color: Colors.blue,
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
}
