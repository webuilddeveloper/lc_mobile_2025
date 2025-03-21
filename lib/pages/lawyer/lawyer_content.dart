// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class LawyerContent extends StatefulWidget {
  const LawyerContent({
    super.key,
    this.code,
    this.url,
    this.model,
    this.urlGallery,
  });

  final String? code;
  final String? url;
  final dynamic model;
  final String? urlGallery;

  @override
  // ignore: library_private_types_in_public_api
  _LawyerContent createState() => _LawyerContent();
}

class _LawyerContent extends State<LawyerContent> {
  late Future<dynamic> _futureModel;
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    _futureModel = postDio(widget.url!, {'code': widget.code});
    readGallery();
  }

  Future<dynamic> readGallery() async {
    var result = await postDio(widget.urlGallery!, {'code': widget.code});

    if (result != null) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          return myContent(
            snapshot.data[0],
          );
        } else {
          return myContent(
            widget.model,
          );
        }
      },
    );
  }

  myContent(dynamic model) {
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
          color: Colors.white,
          child: GalleryView(
            imageUrl: [...image, ...urlImage],
            imageProvider: [...imagePro, ...urlImageProvider],
          ),
        ),
        Container(
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    SizedBox(
                        width: 40,
                        child: CircleAvatar(
                          backgroundImage: model['imageUrlCreateBy'] != null
                              ? NetworkImage(
                                  model['imageUrlCreateBy'],
                                )
                              : null,
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model['userList'] != null &&
                                    model['userList'].length > 0
                                ? '${model['userList'][0]['firstName']} ${model['userList'][0]['lastName']}'
                                : '${model['createBy']}',
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
                                    ? 'วันที่ลง : ' +
                                        dateStringToDate(model['createDate'])
                                    : '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          )
                          // Row(
                          //   children: [
                          //     Text(
                          //       model['createDate'] != null
                          //           ? dateStringToDate(model['createDate']) +
                          //               ' | '
                          //           : '',
                          //       style: TextStyle(
                          //         fontSize: 10,
                          //         fontFamily: 'Kanit',
                          //         fontWeight: FontWeight.w300,
                          //       ),
                          //     ),
                          //     Text(
                          //       'เข้าชม ' + '${model['view']}' + ' ครั้ง',
                          //       style: TextStyle(
                          //         fontSize: 10,
                          //         fontFamily: 'Kanit',
                          //         fontWeight: FontWeight.w300,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
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
      ],
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
              launchInWebViewWithJavaScript(model['linkUrl']);
              // launchURL('${model['linkUrl']}');
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

  fileUrl(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launchInWebViewWithJavaScript(model['fileUrl']);
          // launchURL('${model['fileUrl']}');
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
}
