import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/carousel_rotation.dart';
import 'package:lc/component/gallery_view.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ContentReporter extends StatefulWidget {
  const ContentReporter({
    super.key,
    this.code,
    this.url,
    this.model,
    this.urlGallery,
    this.urlRotation,
  });

  final String? code;
  final String? url;
  final dynamic model;
  final String? urlGallery;
  final String? urlRotation;

  @override
  // ignore: library_private_types_in_public_api
  _ContentReporter createState() => _ContentReporter();
}

class _ContentReporter extends State<ContentReporter> {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureRotation;

  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _futureModel =
        post(widget.url!, {'skip': 0, 'limit': 1, 'code': widget.code});
    _futureRotation = postDio(widget.urlRotation!, {'limit': 10});

    readGallery();
    sharedApi();
  }

  Future<dynamic> readGallery() async {
    final result =
        await postObjectData('m/Reporter/gallery/read', {'code': widget.code});

    if (result['status'] == 'S') {
      List data = [];
      List<ImageProvider> dataPro = [];

      for (var item in result['objectData']) {
        data.add(item['imageUrl']);

        dataPro.add((item['imageUrl'] != null
            ? NetworkImage(item['imageUrl'])
            : null) as ImageProvider<Object>);
      }
      setState(() {
        urlImage = data;
        urlImageProvider = dataPro;
      });
    }
  }

  Future<dynamic> sharedApi() async {
    final result = await postObjectData('configulation/shared/read',
        {'skip': 0, 'limit': 1, 'code': widget.code});

    if (result['status'] == 's') {
      setState(() {});
    }
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
          return myContentReporter(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // return Container();
          return myContentReporter(
            widget.model,
          );
          // return myContentReporter(widget.model);
        }
      },
    );
  }

  myContentReporter(dynamic model) {
    List image = [];
    List<ImageProvider> imagePro = [];
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
                    backgroundImage: '${model['imageUrlCreateBy']}' != null
                        ? NetworkImage('${model['imageUrlCreateBy']}')
                        : null,
                    // child: Image.network(
                    //     '${snapshot.data[0]['imageUrlCreateBy']}'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['firstName']} ${model['lastName']}',
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
            },
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
        if (widget.urlRotation != '') _buildRotation(),
      ],
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
      // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
      //   new Factory<OneSequenceGestureRecognizer>(
      //     () => new EagerGestureRecognizer(),
      //   ),
      // ].toSet(),
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      // onTap: _handleTap,
      markers: <gmaps.Marker>{
        gmaps.Marker(
          markerId: const gmaps.MarkerId('1'),
          position: gmaps.LatLng(lat, lng),
          icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
              gmaps.BitmapDescriptor.hueRed),
        ),
      },
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
