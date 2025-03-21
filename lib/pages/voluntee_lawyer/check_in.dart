import 'dart:async';
import 'dart:typed_data';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:lc/component/material/custom_alert_dialog.dart';
import 'package:lc/shared/api_provider.dart';

class CheckInPage extends StatefulWidget {
  const CheckInPage({
    super.key,
    this.page,
  });

  final String? page;

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  final places = GoogleMapsPlaces(
    apiKey: Platform.isAndroid
        ? 'AIzaSyAmy8Tn3HwC3kmmLu2NAvOyylA-cPJwGV4'
        : 'AIzaSyBp7XxcUIb8qHLbSi-f2Vwr3CsQ9gbzoa4',
  );
  List<Prediction> predictions = [];
  String currentLocation = '';
  LatLng? latLng;

  @override
  void initState() {
    super.initState();
    _getGeoLocationPosition();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: 60,
          flexibleSpace: Container(
            height: MediaQuery.of(context).padding.top + 60,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              right: 10,
              bottom: 10,
              left: 10,
            ),
            color: Colors.white,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'เช็คอินทนายอาสา',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  left: 5,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/images/box_arrow_left.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: Color(0xFFF2FAFF),
                    borderRadius: BorderRadius.circular(17.5),
                  ),
                  child: TextField(
                    style: const TextStyle(
                      color: Color(0xFF2D9CED),
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 15.0,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        padding: EdgeInsets.all(6),
                        child: Image.asset(
                          'assets/images/search.png',
                          color: Color(0x802D9CED),
                        ),
                      ),
                      labelText: "ค้นหาสถานที่",
                      labelStyle: TextStyle(
                        color: Color(0xFF2D9CED),
                      ),
                      contentPadding:
                          const EdgeInsets.fromLTRB(6.0, 1.0, 1.0, 1.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      errorStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10.0,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autoCompleteSearch(value);
                      } else {
                        if (predictions.isNotEmpty && mounted) {
                          setState(() {
                            predictions = [];
                          });
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'คำแนะนำ',
                      style: TextStyle(
                        color: Color(0xFF2D9CED),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentLocation,
                      style: TextStyle(
                        color: Color(0xFF2D9CED),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 25),
                    itemCount: predictions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          var result = await places.getDetailsByPlaceId(
                            predictions[index].placeId!,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                placeId: predictions[index].placeId!,
                                places: places,
                                mainText: predictions[index]
                                        .structuredFormatting
                                        ?.mainText ??
                                    '',
                                secondaryText: predictions[index]
                                        .structuredFormatting
                                        ?.secondaryText ??
                                    '',
                                currentLatLng: latLng!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 67,
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/location_autocomplete.png',
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            Color(0xFF707070).withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        predictions[index]
                                                .structuredFormatting
                                                ?.mainText ??
                                            '',
                                        style: TextStyle(
                                          color: Color(0xFF2D9CED),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        predictions[index]
                                                .structuredFormatting
                                                ?.secondaryText ??
                                            '',
                                        style: TextStyle(
                                          color: Color(0xFF707070),
                                          fontSize: 13,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Image.asset(
                    "assets/images/powered_by_google.png",
                    width: double.infinity,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    try {
      final response = await places.autocomplete(
        value,
        language: 'th',
      );

      if (response.isOkay && response.predictions != null && mounted) {
        setState(() {
          predictions = response.predictions;
        });
      }
    } catch (e) {
      print('Autocomplete error: $e');
    }
  }

  _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
        currentLocation = placemarks.first.administrativeArea ?? '';
      });
    } catch (e) {
      print('Get location error: $e');
    }
  }

  _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      if (currentLocation == '') _getLocation();
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }
}

class DetailsPage extends StatefulWidget {
  final String placeId;
  final GoogleMapsPlaces places;
  final String mainText;
  final String secondaryText;
  final LatLng currentLatLng;

  DetailsPage({
    super.key,
    required this.placeId,
    required this.places,
    required this.mainText,
    required this.secondaryText,
    required this.currentLatLng,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final storage = FlutterSecureStorage();

  PlaceDetails? detailsResult;
  Completer<GoogleMapController> _mapController = Completer();
  bool canCheckIn = false;
  bool locationCanUse = true;
  bool _loading = true;
  String profileCode = '';

  @override
  void initState() {
    super.initState();
    getDetails(widget.placeId);
    _getStorage();
  }

  _getStorage() async {
    profileCode = await storage.read(key: 'profileCode18') ?? '';
  }

  _checkDistance() async {
    try {
      if (detailsResult == null ||
          detailsResult!.geometry == null ||
          detailsResult!.geometry!.location == null) {
        setState(() {
          _loading = false;
        });
        return;
      }

      var result = await postDio(
        server + 'm/v2/volunteeLawyer/check/distance',
        {
          "latitude": detailsResult!.geometry!.location!.lat,
          "longitude": detailsResult!.geometry!.location!.lng,
          "userLatitude": widget.currentLatLng.latitude,
          "userLongitude": widget.currentLatLng.longitude,
        },
      );

      if (result['distance'] < 1) {
        setState(() {
          canCheckIn = true;
        });
      }
    } catch (e) {
      print('Check distance error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        flexibleSpace: Container(
          height: MediaQuery.of(context).padding.top + 60,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            right: 10,
            bottom: 10,
            left: 10,
          ),
          color: Colors.white,
          child: Stack(
            children: [
              Center(
                child: Text(
                  'เช็คอินทนายอาสา',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                left: 5,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Image.asset(
                    'assets/images/box_arrow_left.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          margin: EdgeInsets.only(right: 20, left: 20, top: 20),
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      detailsResult != null &&
                              detailsResult!.geometry != null &&
                              detailsResult!.geometry!.location != null
                          ? Stack(
                              children: [
                                Container(
                                  height: 290,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(bottom: 90),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    child: googleMap(
                                        detailsResult!.geometry!.location!.lat!,
                                        detailsResult!
                                            .geometry!.location!.lng!),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 90,
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFEEEEEE),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/box_location_white.png',
                                          width: 35,
                                          height: 35,
                                        ),
                                        SizedBox(width: 15),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.mainText,
                                                style: TextStyle(
                                                  color: Color(0xFF2D9CED),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                widget.secondaryText,
                                                style: TextStyle(
                                                  color: Color(0xFF707070),
                                                  fontSize: 13,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Container(
                              height: 290,
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                      InkWell(
                        onTap: () async {
                          if (canCheckIn) {
                            setState(() {
                              _loading = true;
                            });
                            await _save();
                            setState(() {
                              _loading = false;
                            });
                          }
                          _dialogStatus();
                        },
                        child: Container(
                          height: 40,
                          width: 250,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xFFED6B2D),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'เช็คอิน',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (_loading)
                Positioned.fill(
                    child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
                ))
            ],
          ),
        ),
      ),
    );
  }

  void getDetails(String placeId) async {
    try {
      final response = await widget.places.getDetailsByPlaceId(placeId);

      if (response.isOkay && response.result != null && mounted) {
        setState(() {
          detailsResult = response.result;
        });
      }

      await _checkDistance();
    } catch (e) {
      print('Get details error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  googleMap(double lat, double lng) {
    return GoogleMap(
      myLocationEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      compassEnabled: false,
      myLocationButtonEnabled: false,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 18,
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(
          () => EagerGestureRecognizer(),
        ),
      },
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      markers: {
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      },
    );
  }

  Future<void> _dialogStatus() async {
    String title = canCheckIn ? 'เช็คอินสำเร็จ' : 'เช็คอินไม่สำเร็จ';
    String subTitle1 = canCheckIn
        ? 'ท่านสามารถเช็คเอาท์หลังจากจบงานในวันนี้'
        : 'คุณอยู่ห่างจากจุดเช็คอินมากเกินไป';
    String subTitle2 =
        canCheckIn ? 'หลังจากเช็คเอาท์จะไม่สามารถบันทึกงานในวันนี้ได้อีก' : '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CustomAlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              width: 220,
              height: 155,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF2D9CED),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      subTitle1,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    Text(
                      subTitle2,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    SizedBox(height: 15),
                    canCheckIn
                        ? inkWellcanCheckInTrue()
                        : inkWellcanCheckInFalse(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget inkWellcanCheckInFalse() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Container(
        height: 35,
        width: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.5),
          color: Color(0xFFED6B2D),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Kanit',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inkWellcanCheckInTrue() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      child: Container(
        height: 35,
        width: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17.5),
          color: Color(0xFFED6B2D),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Kanit',
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    try {
      if (detailsResult == null ||
          detailsResult!.geometry == null ||
          detailsResult!.geometry!.location == null) return;

      await postDio(
        server + 'm/v2/volunteeLawyer/checkin',
        {
          "latitude": detailsResult!.geometry!.location!.lat.toString(),
          "longitude": detailsResult!.geometry!.location!.lng.toString(),
          "userLatitude": widget.currentLatLng.latitude.toString(),
          "userLongitude": widget.currentLatLng.longitude.toString(),
          "category": 'checkIn',
          "title": widget.mainText,
          "description": widget.secondaryText,
          "profileCode": profileCode,
        },
      );
    } catch (e) {
      print('Save error: $e');
    }
  }
}
