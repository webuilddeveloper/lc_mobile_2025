import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lc/component/material/custom_alert_dialog.dart';
import 'package:lc/menu_v2.dart';
import 'package:lc/shared/api_provider.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final storage = new FlutterSecureStorage();
  String currentLocation = '';
  late LatLng latLng;

  late Future<dynamic> _futureModel;
  String profileCode = '';
  String reference = '';
  bool hasCheckOut = false;

  @override
  void initState() {
    _getStorage();
    _getGeoLocationPosition();
    super.initState();
  }

  _getTime() {
    bool result = false;
    var now = DateTime.now();
    int startTimeInt = (now.hour * 60 + now.minute) * 60;
    int EndTimeInt = (16 * 60 + 30) * 60;
    int dif = EndTimeInt - startTimeInt;

    if (EndTimeInt <= startTimeInt) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  _getStorage() async {
    profileCode = (await storage.read(key: 'profileCode18'))!;
    var now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var dateString = DateFormat('yyyyMMdd').format(date).toString();
    reference = profileCode + '-' + dateString + '070000';
    _futureModel = postDio(server + 'm/v2/volunteeLawyer/read', {
      'profileCode': profileCode,
      'reference': reference,
      // 'reference': '20210216111726-103-860-20220818070000',
    });
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
    } else {}

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      if (currentLocation == '') _getLocation();
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
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
                  'เช็คเอาท์',
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
      body: FutureBuilder<dynamic>(
        future: _futureModel, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.hasData) {
            return futureBuilder(snapshot.data);
          } else {
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  content(model) {
    return GestureDetector(
      onTap: () async {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => {},
        //   ),
        // );
      },
      child: Container(
        height: 67,
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/box_necktie.png',
              width: 35,
              height: 35,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF707070).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model['title'],
                      style: TextStyle(
                        color: Color(0xFF2D9CED),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      model['description'],
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
  }

  futureBuilder(model) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          model.length > 0
              ? columnContant(model)
              : Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('ไม่มีบันทึกงานทนายอาสา'),
                  ),
                ),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              // if (_getTime()) {
              // await _checkOut();
              _dialogStatus();
              // }
            },
            child: Container(
              height: 40,
              width: 250,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFFED6B2D),
                // color: _getTime() ? Color(0xFFED6B2D) : Color(0xFF707070),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'เช็คเอาท์',
                // _getTime() ? 'เช็คเอาท์' : 'เช็คเอาท์ได้หลัง 16:30 น.',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  columnContant(model) {
    return Expanded(
      child: Container(
        // color: Colors.red,
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                child: Text(
                  'งานทั้งหมด',
                  style: TextStyle(
                    color: Color(0xFF2D9CED),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ชื่อสถานที่ : ${model[0]['titlePlace']}',
                      style: TextStyle(
                        color: Color(0xFF2D9CED),
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '${model[0]['descriptionPlace']}',
                      style: TextStyle(
                        color: Color(0xFF707070),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(top: 25),
              itemCount: model.length,
              separatorBuilder: (_, __) => const SizedBox(height: 5),
              itemBuilder: (context, index) {
                return content(model[index]);
              },
            ),
          ),
        ]),
      ),
    );
  }

  Future<dynamic> _dialogStatus() async {
    String title = 'คุณต้องการเช็คเอาท์ใช่หรือไม่';
    String subTitle1 = 'ขอบคุณที่ท่านมาปฏิบัติงานอาสาวันนี้';
    String subTitle2 = 'เราจะตั้งตารอท่านมาปฏิบัติครั้งต่อไป';
    // if (!locationCanUse) {
    //   subTitle1 = 'ไม่สามารถเช็คอินจาก' + widget.mainText + 'ได้';
    // }
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
              width: MediaQuery.of(context).size.height / 100 * 30,
              height: 150,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: 35,
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.5),
                              color: Color(0xFFED6B2D),
                            ),
                            child: Text(
                              'ยกเลิก',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Kanit',
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await _checkOut();
                            Navigator.pop(context);
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => MenuV2(),
                            //   ),
                            // );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            height: 35,
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(top: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.5),
                              color: Color(0xFFED6B2D),
                            ),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // child: //Contents here
            ),
          ),
        );
      },
    );
  }

  _checkOut() async {
    await postDio(server + 'm/v2/volunteeLawyer/checkin', {
      'category': 'checkOut',
      'profileCode': profileCode,
      'userLatitude': latLng.latitude.toString(),
      'userLongitude': latLng.longitude.toString(),
    });
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    // Remove 'locale' parameter and rely on default behavior
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      currentLocation = placemarks.first.administrativeArea!;
    });
  }
}
