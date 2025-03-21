import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lc/component/header.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/component/link_url_out.dart';
import 'package:lc/component/loadingImageNetwork.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../../menu.dart';

// ignore: must_be_immutable
class AboutUsForm extends StatefulWidget {
  const AboutUsForm({super.key, this.model, required this.title});
  final String title;
  final Future<dynamic>? model;

  @override
  // ignore: library_private_types_in_public_api
  _AboutUsForm createState() => _AboutUsForm();
}

class _AboutUsForm extends State<AboutUsForm> {
  // final Set<Marker> _markers = {};
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  void launchURLMap(String lat, String lng) async {
    String homeLat = lat;
    String homeLng = lng;

    final String googleMapslocationUrl =
        // ignore: prefer_interpolation_to_compose_strings
        "https://www.google.com/maps/search/?api=1&query=" +
            homeLat +
            ',' +
            homeLng;

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    launchUrl(Uri.parse(encodedURl), mode: LaunchMode.externalApplication);

    // if (await canLaunch(encodedURl)) {
    //   await launch(encodedURl);
    // } else {
    //   throw 'Could not launch $encodedURl';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: header(context, goBack, title: 'เกี่ยวกับเรา'),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: FutureBuilder<dynamic>(
            future: widget.model, // function where you call your api
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              // AsyncSnapshot<Your object type>
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else {
                if (snapshot.hasError) {
                  return dialogFail(context);
                } else if (snapshot.hasData) {
                  var lat = double.parse(snapshot.data['latitude'] != ''
                      ? snapshot.data['latitude']
                      : 0.0);
                  var lng = double.parse(snapshot.data['longitude'] != ''
                      ? snapshot.data['longitude']
                      : 0.0);
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      // controller: _controller,
                      children: [
                        Stack(
                          children: [
                            ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                  sigmaY: 5,
                                  sigmaX:
                                      5), //SigmaX and Y are just for X and Y directions
                              child: loadingImageNetwork(
                                snapshot.data['imageBgUrl'],
                                height: MediaQuery.of(context).size.width,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ), //here you can use any widget you'd like to blur .
                            ),
                            Container(
                              color: Colors.transparent,
                              child: loadingImageNetwork(
                                snapshot.data['imageBgUrl'],
                                height: MediaQuery.of(context).size.width,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),
                            // SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width - 45,
                                left: 15.0,
                                right: 15.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 120.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // color: Colors.orange,
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.network(
                                      snapshot.data['imageLogoUrl'],
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      child: Text(
                                        snapshot.data['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Kanit',
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Group56.png",
                          ),
                          title: snapshot.data['address'] ?? '',
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Path34.png",
                          ),
                          title: snapshot.data['telephone'] ?? '',
                          value: '${snapshot.data['telephone']}',
                          typeBtn: 'phone',
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Group62.png",
                          ),
                          title: snapshot.data['email'] ?? '',
                          value: '${snapshot.data['email']}',
                          typeBtn: 'email',
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Group369.png",
                          ),
                          title: snapshot.data['title'] ?? '',
                          value: '${snapshot.data['site']}',
                          typeBtn: 'link',
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Group356.png",
                          ),
                          title: snapshot.data['title'] ?? '',
                          value: '${snapshot.data['facebook']}',
                          typeBtn: 'link',
                        ),
                        // rowData(
                        //   image: Image.asset(
                        //     "assets/logo/icons/youtube.png",
                        //   ),
                        //   title: snapshot.data['youtube'] ?? '',
                        //   value: '${snapshot.data['youtube']}',
                        //   typeBtn: 'link',
                        // ),
                        // rowData(
                        //   image: Image.asset(
                        //     "assets/logo/socials/Group331.png",
                        //   ),
                        //   title: snapshot.data['lineOfficial'] ?? '',
                        //   value: '${snapshot.data['lineOfficial']}',
                        //   typeBtn: 'link',
                        // ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // googleMap(lat, lng),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: double.infinity,
                          child: googleMap(lat, lng),
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
                                  launchURLMap(lat.toString(), lng.toString());
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
                        )
                      ],
                    ),
                  );
                } else {
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      // controller: _controller,
                      children: [
                        Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 50),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              // color: Colors.orange,
                              child: Image.network('',
                                  height: 350,
                                  width: double.infinity,
                                  fit: BoxFit.cover),
                            ),
                            // SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(
                                  top: 350.0, left: 15.0, right: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              height: 120.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // color: Colors.orange,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 17.0),
                                    child: Image.asset(
                                      "assets/logo/logo.png",
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 5.0),
                                      child: const Text(
                                        'สหกรณ์ออมทรัพท์ตำรวจทางหลวง จำกัด',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Kanit',
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Group56.png",
                          ),
                          title: '-',
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Path34.png",
                          ),
                          title: '-',
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Group62.png",
                          ),
                          title: '-',
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Group369.png",
                          ),
                          title: '-',
                        ),
                        rowData(
                          image: Image.asset(
                            "assets/logo/icons/Group356.png",
                          ),
                          title: '-',
                        ),
                        // rowData(
                        //   image: Image.asset(
                        //     "assets/logo/icons/youtube.png",
                        //   ),
                        //   title: '-',
                        // ),
                        // rowData(
                        //   image: Image.asset(
                        //     "assets/logo/socials/Group331.png",
                        //   ),
                        //   title: '-',
                        // ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: googleMap(13.8462512, 100.5234803),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
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

  Widget rowData({
    required Image image,
    String title = '',
    String value = '',
    String typeBtn = '',
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
                color: const Color(0xFF011895),
                borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: const EdgeInsets.all(5.0),
              child: image,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => typeBtn != ''
                  ? typeBtn == 'email'
                      ? launchURL('mailto:$value')
                      : typeBtn == 'phone'
                          ? launch('tel://$value')
                          : typeBtn == 'link'
                              ? launchInWebViewWithJavaScript(value)
                              : null
                  : null,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 12,
                    color: Color(0xFF2D9CED),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
