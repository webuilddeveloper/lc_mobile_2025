import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/scroll_behavior.dart';
import 'package:lc/v4/widget/header_v4.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final Completer<GoogleMapController> _mapController = Completer();
  late Future<dynamic> _futureModel;

  @override
  void initState() {
    _futureModel = postDio('${aboutUsApi}read', {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        appBar: headerV4(
          context,
          goBack,
          title: 'เกี่ยวกับเรา',
        ),
        body: FutureBuilder<dynamic>(
          future: _futureModel,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              var lat = double.parse(snapshot.data['latitude'] != ''
                  ? snapshot.data['latitude']
                  : 0.0);
              var lng = double.parse(snapshot.data['longitude'] != ''
                  ? snapshot.data['longitude']
                  : 0.0);
              return ScrollConfiguration(
                behavior: CsBehavior(),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                  children: [
                    Image.asset(
                      'assets/logo_login.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${snapshot.data['title'] ?? 'สภาทนายความ ในพระราชูปถัมภ์'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '${snapshot.data['address']}',
                              style: const TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ข้อมูลติดต่อ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 15),
                          rowContactInformation(
                            title: 'เบอร์ติดต่อ',
                            description: snapshot.data['telephone'] ?? '',
                            image: 'assets/images/phone_about.png',
                            url: 'tel://${snapshot.data['telephone'] ?? ''}',
                          ),
                          const SizedBox(height: 15),
                          rowContactInformation(
                            title: 'Facebook Page',
                            description: 'สภาทนายความ ในพระบรมราชูปถัมภ์',
                            image: 'assets/images/facebook_about.png',
                            url: '${snapshot.data['facebook']}',
                          ),
                          const SizedBox(height: 15),
                          rowContactInformation(
                            title: 'อีเมล',
                            description: '${snapshot.data['email']}',
                            image: 'assets/images/mail_about.png',
                            url: 'mailto: ${snapshot.data['email']}',
                          ),
                          const SizedBox(height: 15),
                          rowContactInformation(
                            title: 'เว็บไซต์',
                            description: 'สภาทนายความ ในพระบรมราชูปถัมภ์',
                            image: 'assets/images/network_about.png',
                            url: '${snapshot.data['site']}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 195,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: 
                      // Text(lat.toString())
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: googleMap(lat, lng),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.transparent,
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                              color: const Color(0xFF011895),
                            ),
                          ),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              // launchURLMap(lat.toString(), lng.toString());
                            },
                            child: const Text(
                              'ตำแหน่ง Google Map',
                              style: TextStyle(
                                color: Color(0xFF011895),
                                fontFamily: 'Kanit',
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Container();
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
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
      // onTap: _handleTap,
      markers: <Marker>{
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      },
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  Widget rowContactInformation(
      {required String title,
      required String description,
      required String image,
      required String url}) {
    return GestureDetector(
      onTap: () async {
        if (url.isNotEmpty &&
            url.trim() != '-' &&
            url != null &&
            url != 'mailto: -' &&
            url != 'tel://') {
          await launchInWebViewWithJavaScript(url);
        }
      },
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF2FAFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                image,
                height: 45,
                width: 45,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 45,
              width: 45,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.5),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 15,
                      spreadRadius: 1,
                      color: Color(0x26707070),
                      offset: Offset(0, 0),
                    )
                  ]),
              child: Image.asset(
                'assets/images/comment_about.png',
                height: 45,
                width: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchURLMap(String lat, String lng) async {
    String homeLat = lat;
    String homeLng = lng;

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=" +
            homeLat +
            ',' +
            homeLng;
    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);
    launchUrl(Uri.parse(encodedURl), mode: LaunchMode.externalApplication);
  }
}
