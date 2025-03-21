import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Content extends StatefulWidget {
  const Content({
    super.key,
    this.code,
    this.url,
    this.model,
    this.urlGallery,
    this.pathShare,
    this.urlRotation,
  });

  final String? code;
  final String? url;
  final dynamic model;
  final String? urlGallery;
  final String? pathShare;
  final String? urlRotation;

  @override
  // ignore: library_private_types_in_public_api
  _Content createState() => _Content();
}

class _Content extends State<Content> {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureRotation;

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    sharedApi();
    _futureModel =
        postDio(widget.url!, {'skip': 0, 'limit': 1, 'code': widget.code});
    _futureRotation = postDio(widget.urlRotation!, {'limit': 10});

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          // setState(() {
          //   urlImage = [snapshot.data[0].imageUrl];
          // });
          return myContent(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return myContent(
            widget.model,
          );
          // return myContent(widget.model);
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
                                    ? dateStringToDate(model['createDate']) +
                                        ' | '
                                    : '',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                'เข้าชม ${model['view']} ครั้ง',
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
            ),
            SizedBox(
              width: 90,
              child: Container(
                width: 100.0,
                height: 35.0,
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                  ),
                  onPressed: () {
                    final RenderBox box =
                        context.findRenderObject() as RenderBox;
                    Share.share(
                      '$_urlShared${widget.pathShare!}${model['code']} ${model['title']}',
                      subject: '${model['title']}',
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size,
                    );
                  },
                  child: Image.asset(
                    'assets/images/share.png',
                    // color: Color(0xFFF58A33),
                  ),
                ),
              ),
            )
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
        if (widget.urlRotation != '') _buildRotation(),
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
}
