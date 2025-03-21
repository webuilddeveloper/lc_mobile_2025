import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lc/component/header.dart';
import 'package:lc/pages/poi/poi_list_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PoiList extends StatefulWidget {
  const PoiList({super.key, required this.title});
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _PoiList createState() => _PoiList();
}

class _PoiList extends State<PoiList> {
  final Completer<GoogleMapController> _mapController = Completer();

  late PoiListVertical gridView;
  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String keySearch = '';
  String category = '';
  int _limit = 10;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<dynamic> _futurePoi;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _futurePoi = postDio('${poiApi}read', {'skip': 0, 'limit': 10});
    gridView = PoiListVertical(
      site: 'LC',
      model: _futurePoi,
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      _futurePoi = postDio('${poiApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': category,
        "keySearch": keySearch
      });
      gridView = PoiListVertical(
        site: 'LC',
        model: _futurePoi,
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: header(context, goBack, title: 'ร้านค้าสมาชิก'),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            footer: const ClassicFooter(
              loadingText: ' ',
              canLoadingText: ' ',
              idleText: ' ',
              idleIcon: Icon(
                Icons.arrow_upward,
                color: Colors.transparent,
              ),
            ),
            controller: _refreshController,
            onLoading: _onLoading,
            child: ListView(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  height: 300,
                  margin: const EdgeInsets.only(bottom: 10.0),
                  width: double.infinity,
                  child: googleMap(_futurePoi),
                ),
                Container(
                  child: gridView,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  googleMap(modelData) {
    // ignore: no_leading_underscores_for_local_identifiers
    List<Marker> _markers = <Marker>[];

    return FutureBuilder<dynamic>(
      future: modelData, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            snapshot.data
                .map(
                  (item) => _markers.add(
                    Marker(
                      markerId: MarkerId(item['code']),
                      position: LatLng(
                        double.parse(item['latitude']),
                        double.parse(item['longitude']),
                      ),
                      infoWindow: InfoWindow(
                        title: item['title'].toString(),
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  ),
                )
                .toList();
          }

          return GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.881074, 100.598547),
              zoom: 12,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            markers: snapshot.data.length > 0
                ? _markers.toSet()
                : <Marker>{
                    Marker(
                      markerId: const MarkerId('1'),
                      position: const LatLng(0.00, 0.00),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
