import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/flutter_html.dart' hide Marker;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ContentPoi extends StatefulWidget {
  const ContentPoi({
    super.key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
    required this.pathShare,
    required this.urlRotation,
  });

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;
  final String pathShare;
  final String urlRotation;

  @override
  // ignore: library_private_types_in_public_api
  _ContentPoi createState() => _ContentPoi();
}

class _ContentPoi extends State<ContentPoi> {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureRotation;

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _futureModel =
        postDio(widget.url, {'skip': 0, 'limit': 1, 'code': widget.code});
    _futureRotation = postDio(widget.urlRotation, {'limit': 10});
    // readGallery();
    sharedApi();
  }

  // Future<dynamic> readGallery() async {
  //   final result = await postDio(widget.urlGallery, {'code': widget.code});

  //   if (result['status'] == 'S') {
  //     List data = [];
  //     List<ImageProvider> dataPro = [];

  //     for (var item in result['objectData']) {
  //       data.add(item['imageUrl']);

  //       dataPro.add(
  //           item['imageUrl'] != null ? NetworkImage(item['imageUrl']) : null);
  //     }
  //     setState(() {
  //       urlImage = data;
  //       urlImageProvider = dataPro;
  //     });
  //   }
  // }

  Future<dynamic> sharedApi() async {
    await postConfigShare().then((result) => {
          if (result['status'] == 'S')
            {
              setState(() {
                _urlShared = result['objectData']['description'];
              }),
            }
        });
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
          return myContentPoi(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return myContentPoi(
            widget.model,
          );
          // return myContentPoi(widget.model);
        }
      },
    );
  }

  myContentPoi(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : const AssetImage('assets/images/placeholder.png')
              as ImageProvider<Object>
    ];
    return ListView(
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
                    backgroundImage: model['imageUrlCreateBy'] != null
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
                              dateStringToDate(model['createDate']) + ' | ',
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
            Container(
                width: 74.0,
                height: 31.0,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage('assets/images/share.png'),
                //     )),
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0.0),
                  ),
                  onPressed: () {
                    final RenderBox? box = context.findRenderObject()
                        as RenderBox?; // Casting to RenderBox
                    if (box != null) {
                      Share.share(
                        _urlShared +
                            widget.pathShare +
                            '${model['code']}' +
                            ' ${model['title']}',
                        subject: '${model['title']}',
                        sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size,
                      );
                    }
                  },
                  child: Image.asset('assets/images/share.png'),
                ))
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
        model['linkUrl'] != '' && model['textButton'] != ''
            ? linkButton(model)
            : Container(),
        const Padding(
          padding: EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Text(
            'ที่ตั้ง',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Text(
            model['address'] != '' ? model['address'] : '-',
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        SizedBox(
          height: 250,
          width: double.infinity,
          child: googleMap(
              model['latitude'] != ''
                  ? double.parse(model['latitude'])
                  : 13.8462512,
              model['longitude'] != ''
                  ? double.parse(model['longitude'])
                  : 100.5234803),
        ),
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

  googleMap(double lat, double lng) {
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 16,
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      markers: <Marker>{
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      },
    );
  }

  _buildRotation() {
    return Container(
      // padding: EdgeInsets.only(left: 15, right: 15, top: 5),
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
}
