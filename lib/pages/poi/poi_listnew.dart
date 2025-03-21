import 'dart:async';
import 'package:lc/component/header.dart';
import 'package:lc/component/key_search.dart';
import 'package:lc/component/tab_category.dart';
import 'package:lc/pages/blank_page/blank_data.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:lc/pages/poi/poi_form.dart';
import 'package:lc/shared/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lc/pages/poi/poi_list_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PoiList extends StatefulWidget {
  PoiList({Key? key, required this.title, required this.latLng})
      : super(key: key);
  final String title;
  final LatLng latLng;

  @override
  _PoiList createState() => _PoiList();
}

class _PoiList extends State<PoiList> {
  Completer<GoogleMapController> _mapController = Completer();

  late PoiListVertical gridView;
  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String keySearch = '';
  String category = '';
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<dynamic> _futureModel;
  late LatLngBounds initLatLngBounds;

  late double positionScroll;
  bool showMap = true;

  // Future<dynamic> _futureModel;
  late Future<dynamic> futureCategory;
  List<dynamic> listTemp = [
    {
      'code': '',
      'title': '',
      'imageUrl': '',
      'createDate': '',
      'userList': [
        {'imageUrl': '', 'firstName': '', 'lastName': ''}
      ]
    }
  ];
  bool showLoadingItem = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _futureModel = postDio('${poiApi}read', {
      'skip': 0,
      'limit': 10,
      'latitude': widget.latLng.latitude,
      'longitude': widget.latLng.longitude
    });

    setState(() {
      double southwest = widget.latLng.latitude;
      double northeast = widget.latLng.longitude;

      initLatLngBounds = LatLngBounds(
          southwest: LatLng(southwest - 0.2, northeast - 0.15),
          northeast: LatLng(southwest + 0.1, northeast + 0.1));
    });

    futureCategory = postDioCategory(
      '${poiCategoryApi}read',
      {'skip': 0, 'limit': 100},
    );

    gridView = new PoiListVertical(
      model: _futureModel,
      site: '',
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      _futureModel = postDio('${poiApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': category,
        "keySearch": keySearch,
        'latitude': widget.latLng.latitude,
        'longitude': widget.latLng.longitude
      });
      gridView = new PoiListVertical(
        model: _futureModel,
        site: '',
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void changeTab() async {
    // Navigator.pop(context, false);
    setState(() {
      showMap = !showMap;
    });
  }

  void goBack() async {
    Navigator.pop(context, false);
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
        appBar: header(
          context,
          () => {Navigator.pop(context)},
          title: widget.title,
          isCenter: true,
          isShowLogo: false,
          isShowButtonPoi: true, // เพื่อให้โชว์ปุ่มขวาบน
          isButtonPoi: showMap, //ปุ่มที่เริ่มโชว์คือปุ่ม List
          callBackClickButtonCalendar: () => setState(
            () {
              showMap = !showMap;
              _limit = 10;

              futureCategory = postDioCategory(
                '${poiCategoryApi}read',
                {'skip': 0, 'limit': 100},
              );
            },
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: showMap ? _buildMap() : _buildList(),
        ),
      ),
    );
  }

// show map
  SlidingUpPanel _buildMap() {
    final double _initFabHeight = 50.0;
    double _fabHeight;
    double _panelHeightOpen = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 50);
    double _panelHeightClosed = 90;
    return SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      body: Container(
        padding: EdgeInsets.only(
            bottom:
                _panelHeightClosed + MediaQuery.of(context).padding.top + 50),
        child: googleMap(_futureModel),
      ),
      panelBuilder: (sc) => _panel(sc),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5.0), topRight: Radius.circular(5.0)),
      onPanelSlide: (double pos) => {
        setState(
          () {
            positionScroll = pos;
            _fabHeight =
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
          },
        ),
      },
    );
  }

  FutureBuilder googleMap(modelData) {
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PoiForm(
                                code: item['code'],
                                model: item,
                                url: poiApi,
                                urlComment: poiCommentApi,
                                urlGallery: poiGalleryApi,
                              ),
                            ),
                          );
                        },
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
            myLocationButtonEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: widget.latLng,
              zoom: 15,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            onMapCreated: (GoogleMapController controller) {
              controller.moveCamera(
                CameraUpdate.newLatLngBounds(
                  initLatLngBounds,
                  5.0,
                ),
              );
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: widget.latLng, zoom: 15)));
              _mapController.complete(controller);
            },
            // cameraTargetBounds: CameraTargetBounds(_createBounds()),
            markers: snapshot.data.length > 0
                ? _markers.toSet()
                : <Marker>[
                    Marker(
                      markerId: const MarkerId('1'),
                      position: const LatLng(0.00, 0.00),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  ].toSet(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              child: dialogFail(context),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  LatLngBounds _createBounds() {
    List<LatLng> positions = []; // Initialize positions as an empty list
    positions.add(widget.latLng); // Add the widget.latLng to the positions list

    final southwestLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value < element ? value : element); // smallest
    final southwestLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value < element ? value : element);
    final northeastLat = positions.map((p) => p.latitude).reduce(
        (value, element) => value > element ? value : element); // biggest
    final northeastLon = positions
        .map((p) => p.longitude)
        .reduce((value, element) => value > element ? value : element);

    return LatLngBounds(
        southwest: LatLng(southwestLat, southwestLon),
        northeast: LatLng(northeastLat, northeastLon));
  }

  Widget _panel(ScrollController sc) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
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
          controller: sc,
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey,
                ),
                height: 4,
              ),
              // child: AnimatedOpacity(
              //   opacity: positionScroll < 0.9 ? 1.0 : 0.0,
              //   duration: Duration(milliseconds: 300),
              //   child: Container(
              //     margin: EdgeInsets.only(top: 10),
              //     width: 40,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(5),
              //       color: Colors.grey,
              //     ),
              //     height: 4,
              //   ),
              // ),
            ),
            Container(
              height: 35,
              width: double.infinity,
              alignment: Alignment.center,
              child: const Text(
                'จุดบริการ',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // child: Icon(
              //   Icons.arrow_circle_up,
              //   color: Theme.of(context).primaryColor,
              // ),
            ),
            // : Container(),
            const SizedBox(
              height: 5,
            ),
            Container(
              child: gridView,
            ),
          ],
        ),
      ),
    );
  }
// end show map

// -------------------------------

// show content
  Container _buildList() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 5),
          CategorySelector(
            model: futureCategory,
            onChange: (String val) {
              setData(val, keySearch);
            },
          ),
          const SizedBox(height: 5),
          KeySearch(
            show: hideSearch,
            onKeySearchChange: (String val) {
              setData(category, val);
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: buildList(),
          )
        ],
      ),
    );
  }

  FutureBuilder buildList() {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (showLoadingItem) {
            return blankListData(context, height: 300);
          } else {
            return refreshList(listTemp);
          }
        } else if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: const Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                  color: Colors.grey,
                ),
              ),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                showLoadingItem = false;
                listTemp = snapshot.data;
              });
            });
            return refreshList(snapshot.data);
          }
        } else if (snapshot.hasError) {
          // return dialogFail(context);
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              setState(() {
                _futureModel = postDio('${poiApi}read', {
                  'skip': 0,
                  'limit': _limit,
                  'category': category,
                  "keySearch": keySearch,
                  'latitude': widget.latLng.latitude,
                  'longitude': widget.latLng.longitude
                });
                futureCategory = postDioCategory(
                  '${poiCategoryApi}read',
                  {'skip': 0, 'limit': 100},
                );
              });
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 50.0, color: Colors.blue),
                Text('ลองใหม่อีกครั้ง')
              ],
            ),
          );
        } else {
          return refreshList(listTemp);
        }
      },
    );
  }

  SmartRefresher refreshList(List<dynamic> model) {
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      footer: const ClassicFooter(
        loadingText: ' ',
        canLoadingText: ' ',
        idleText: ' ',
        idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
      ),
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return card(context, model[index]);
        },
      ),
    );
  }

  Container card(BuildContext context, dynamic model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoiForm(
                code: model['code'],
                model: model,
                url: poiApi,
                urlComment: poiCommentApi,
                urlGallery: poiGalleryApi,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(bottom: 5.0),
                  // height: 334,
                  width: 600,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(5.0),
                            topRight: const Radius.circular(5.0),
                          ),
                          color: Colors.grey,
                        ),
                        constraints: const BoxConstraints(
                          minHeight: 200,
                          maxHeight: 200,
                          minWidth: double.infinity,
                        ),
                        child: model['imageUrl'] != null
                            ? ClipRRect(
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(5.0),
                                  topRight: const Radius.circular(5.0),
                                ),
                                child: Image.network(
                                  '${model['imageUrl']}',
                                  fit: BoxFit.cover,
                                ))
                            : const BlankLoading(
                                height: 200,
                              ),
                      ),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(5.0),
                            bottomRight: const Radius.circular(5.0),
                          ),
                          color: const Color(0xFFFFFFFF),
                        ),
                        padding: const EdgeInsets.all(5.0),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // color: Colors.red,
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  Text(
                                    '${model['title']}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Sarabun',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF4D4D4D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              // color: Colors.red,
                              padding: const EdgeInsets.only(left: 8),
                              child: Column(
                                children: [
                                  Text(
                                    'วันที่ ' +
                                        dateStringToDate(model['createDate']),
                                    style: const TextStyle(
                                      color: const Color(0xFF8F8F8F),
                                      fontFamily: 'Sarabun',
                                      fontSize: 15.0,
                                      // fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  setData(String category, String keySearkch) {
    setState(
      () {
        if (keySearch != "") {
          showLoadingItem = true;
        }
        keySearch = keySearkch;
        _limit = 10;
        _futureModel = postDio('${poiApi}read', {
          'skip': 0,
          'limit': _limit,
          'category': category,
          "keySearch": keySearch,
          'latitude': widget.latLng.latitude,
          'longitude': widget.latLng.longitude
        });
      },
    );
  }
// end show content
}
