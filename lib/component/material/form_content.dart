import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/shared/api_provider.dart';

class FormContent extends StatefulWidget {
  FormContent({Key? key, required this.code, this.model}) : super(key: key);
  final String code;
  final dynamic model;

  @override
  _FormContentState createState() => _FormContentState(code: code);
}

class _FormContentState extends State<FormContent> {
  _FormContentState({required this.code});
  bool clickArrow = false;

  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureRotation;
  // String _urlShared = '';
  String code;
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  String selectedType = '0';

  @override
  void initState() {
    super.initState();
    readGallery();
    _futureModel = postDio(
        '${privilegeApi}read', {'skip': 0, 'limit': 1, 'code': widget.code});
    _futureRotation = postDio('', {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio('', {'code': widget.code});

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
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
    );
  }

  myContent(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : const AssetImage('assets/images/placeholder.png')
    ];
    // return Container();
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GalleryView(
              imageUrl: [...image, ...urlImage],
              imageProvider: [...imagePro, ...urlImageProvider],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: model['imageUrlCreateBy'] != null
                      ? NetworkImage(model['imageUrlCreateBy'])
                      : null,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        model['createBy'],
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        model['title'],
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 10,
          ),
          // Container(
          //   padding: const EdgeInsets.only(
          //     right: 10,
          //     left: 10,
          //   ),
          //   child: Html(
          //     data: model['description'],
          //     onLinkTap: (url) {
          //       launchURL(url);
          //       // open url in a webview
          //     },
          //   ),
          // ),
          SizedBox(
            height: 20.0,
          ),
          if (model['linkUrl'] != null && model['linkUrl'] != '')
            InkWell(
              onTap: () {
                launchInWebViewWithJavaScript('${model['linkUrl']}');
                // toastFail(context, text: 'ไปยังเว็บไซต์');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: 280,
                ),
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF2A9EB5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'ไปยังเว็บไซต์',
                    // model['textButton'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              // _buildDialogDarkMode();
              // toastFail(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              constraints: BoxConstraints(
                minWidth: 100,
                maxWidth: 280,
              ),
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFE84C10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'รับสิทธิ์',
                  // model['textButton'],
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildRotation(),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  _buildRotation() {
    return Container(
      // padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}
