import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lc/pages/about_us/about_us_form.dart';
import 'package:lc/pages/contact/contact_list_category.dart';
import 'package:lc/pages/event_calendar/event_calendar_main.dart';
import 'package:lc/pages/knowledge/knowledge_list.dart';
import 'package:lc/pages/poi/poi_listnew.dart';
import 'package:lc/component/menu_grid_item.dart';
import 'package:lc/models/user.dart';
import 'package:lc/pages/policy_v2.dart';
import 'package:lc/pages/poll/poll_list.dart';
import 'package:lc/pages/privilege/privilege_main.dart';
import 'package:lc/pages/reporter/reporter_list_category.dart';
import 'package:lc/shared/api_provider.dart';

class BuildGrid extends StatefulWidget {
  BuildGrid(
      {Key? key,
      required this.menuModel,
      required this.model,
      required this.userData})
      : super(key: key);

  final Future<dynamic> model;
  final Future<dynamic> menuModel;
  final User userData;

  @override
  BuildGridState createState() => BuildGridState();
}

class BuildGridState extends State<BuildGrid> {
  LatLng latLng = LatLng(0, 0);
  String currentLocation = '-';
  var loadingModel = {
    'title': '',
    'imageUrl': '',
  };
  dynamic _tempModel = {'imageUrl': '', 'firstName': '', 'lastName': ''};
  int _current = 0;
  late Future<dynamic> _futureAboutUs;
  String profileCode = '';
  final mockModel = [{}, {}];

  @override
  void initState() {
    _read();
    super.initState();
  }

  _read() async {
    await getStorage();
    _futureAboutUs = post('${aboutUsApi}read', {});
    _getLocation();
  }

  getStorage() async {
    final storage = new FlutterSecureStorage();
    var sto = await storage.read(key: 'dataUserLoginLC');
    var data = json.decode(sto!);
    setState(() {
      profileCode = data['code'];
    });
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

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 520,
      width: double.infinity,
      child: FutureBuilder<dynamic>(
          future: widget.menuModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return _screen(snapshot.data, false);
            } else if (snapshot.hasError) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                height: 90,
                child: Center(
                  child: Text('Network ขัดข้อง'),
                ),
              );
            } else {
              return _screen(_tempModel, true);
            }
          }),
    );
  }

  // Container screen(dynamic model, bool isLoading) {
  //   return Container(
  //     padding: EdgeInsets.only(top: 30),
  //     width: double.infinity,
  //     // margin: EdgeInsets.all(10.0),
  //     decoration: BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.5),
  //           spreadRadius: 0,
  //           blurRadius: 7,
  //           offset: Offset(0, 3), // changes position of shadow
  //         ),
  //       ],
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             MenuGridItem(
  //               title: isLoading ? loadingModel['title'] : model[10]['title'],
  //               imageUrl: isLoading
  //                   ? loadingModel['imageUrl']
  //                   : model[10]['imageUrl'],
  //               subTitle: '',
  //               isCenter: false,
  //               isPrimaryColor: false,
  //               nav: () {
  //                 // Call function
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => BuildTeacherIndex(),
  //                   ),
  //                 );
  //               },
  //             ),
  //             MenuGridItem(
  //               title: isLoading ? loadingModel['title'] : model[3]['title'],
  //               imageUrl:
  //                   isLoading ? loadingModel['imageUrl'] : model[3]['imageUrl'],
  //               subTitle: '',
  //               isCenter: false,
  //               isPrimaryColor: false,
  //               nav: () {
  //                 // Call function
  //                 _callReadPolicy(model[3]['title']);
  //                 // Navigator.push(
  //                 //   context,
  //                 //   MaterialPageRoute(
  //                 //     builder: (context) => PolicyPrivilege(
  //                 //       title: model[3]['title'],
  //                 //       username: widget.userData.username,
  //                 //       fromPolicy: true,
  //                 //     ),
  //                 //   ),
  //                 // );
  //               },
  //             ),
  //             MenuGridItem(
  //               title: isLoading ? loadingModel['title'] : model[4]['title'],
  //               imageUrl:
  //                   isLoading ? loadingModel['imageUrl'] : model[4]['imageUrl'],
  //               subTitle: '',
  //               isCenter: false,
  //               isPrimaryColor: false,
  //               nav: () {
  //                 // Call function
  //                 launchInWebViewWithJavaScript(model[4]['direction']);
  //               },
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             MenuGridItem(
  //               title: isLoading ? loadingModel['title'] : model[2]['title'],
  //               imageUrl:
  //                   isLoading ? loadingModel['imageUrl'] : model[2]['imageUrl'],
  //               subTitle: '',
  //               isCenter: false,
  //               isPrimaryColor: false,
  //               nav: () {
  //                 // Call function
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => KnowledgeList(
  //                       title: model[2]['title'],
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             MenuGridItem(
  //               title: isLoading ? loadingModel['title'] : model[5]['title'],
  //               imageUrl:
  //                   isLoading ? loadingModel['imageUrl'] : model[5]['imageUrl'],
  //               subTitle: '',
  //               isCenter: false,
  //               isPrimaryColor: false,
  //               nav: () {
  //                 // Call function
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => FundList(
  //                       title: model[5]['title'],
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //             MenuGridItem(
  //               title: 'เพิ่มเติม',
  //               imageUrl: isLoading
  //                   ? loadingModel['imageUrl']
  //                   : model[11]['imageUrl'],
  //               subTitle: '',
  //               isCenter: false,
  //               isPrimaryColor: false,
  //               nav: () {
  //                 // Call function
  //                 showMaterialModalBottomSheet(
  //                   duration: const Duration(milliseconds: 300),
  //                   backgroundColor: Colors.transparent,
  //                   context: context,
  //                   builder: (context, scrollController) => Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: new BorderRadius.only(
  //                         topLeft: const Radius.circular(20.0),
  //                         topRight: const Radius.circular(20.0),
  //                       ),
  //                       color: Colors.white,
  //                     ),
  //                     height: MediaQuery.of(context).size.height * 70 / 100,
  //                     child: BuildGridModal(
  //                       model: widget.model,
  //                       menuModel: widget.menuModel,
  //                       userData: widget.userData,
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  _screen(dynamic model, bool isLoading) {
    final modelColumn = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // MenuGridItem(
              //   title: isLoading ? loadingModel['title'] : model[0]['title'],
              //   imageUrl:
              //       isLoading ? loadingModel['imageUrl'] : model[0]['imageUrl'],
              //   subTitle: '',
              //   isCenter: false,
              //   isPrimaryColor: false,
              //   nav: () {
              //     // Call function
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => ComingSoon(code: 'N1'),
              //       ),
              //     );
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute(
              //     //     builder: (context) => ProfessionalLicenseLCPage(),
              //     //   ),
              //     // );
              //   },
              // ),
              MenuGridItem(
                title: isLoading ? loadingModel['title'] : model[9]['title'],
                imageUrl:
                    isLoading ? loadingModel['imageUrl'] : model[9]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: false,
                nav: () {
                  // Call function
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventCalendarMain(
                        title: model[9]['title'],
                        // userData: widget.userData,
                      ),
                    ),
                  );
                },
              ),
              MenuGridItem(
                title: isLoading ? loadingModel['title'] : model[1]['title'],
                imageUrl:
                    isLoading ? loadingModel['imageUrl'] : model[1]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: false,
                nav: () {
                  // Call function
                  _callReadPolicy(model[1]['title']);
                },
              ),
              MenuGridItem(
                title: isLoading ? loadingModel['title'] : model[2]['title'],
                imageUrl:
                    isLoading ? loadingModel['imageUrl'] : model[2]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: false,
                nav: () {
                  // Call function
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PollList(
                        title: model[2]['title'],
                        userData: widget.userData,
                      ),
                    ),
                  );
                },
              ),
              MenuGridItem(
                title: isLoading ? loadingModel['title'] : model[3]['title'],
                imageUrl:
                    isLoading ? loadingModel['imageUrl'] : model[3]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: false,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReporterListCategory(
                        title: model[3]['title'],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              MenuGridItem(
                title: isLoading ? loadingModel['title'] : model[4]['title'],
                imageUrl:
                    isLoading ? loadingModel['imageUrl'] : model[4]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: false,
                nav: () {
                  // Call function
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PoiList(
                        title: model[4]['title'],
                        latLng: latLng,
                      ),
                    ),
                  );
                },
              ),
              MenuGridItem(
                title: isLoading ? loadingModel['title'] : model[5]['title'],
                imageUrl:
                    isLoading ? loadingModel['imageUrl'] : model[5]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: false,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactListCategory(
                        title: model[5]['title'],
                      ),
                    ),
                  );
                },
              ),
              MenuGridItem(
                title: isLoading ? loadingModel['title'] : model[6]['title'],
                imageUrl:
                    isLoading ? loadingModel['imageUrl'] : model[6]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: false,
                nav: () {
                  // Call function
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KnowledgeList(
                        title: model[6]['title'],
                      ),
                    ),
                  );
                },
              ),
              MenuGridItem(
                title: isLoading ? loadingModel['title'] : model[7]['title'],
                imageUrl:
                    isLoading ? loadingModel['imageUrl'] : model[7]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: false,
                nav: () {
                  // Call function
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsForm(
                        model: _futureAboutUs,
                        title: model[7]['title'],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      //ก้อน2
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Row(
      //       children: [
      //         MenuGridItem(
      //           title: isLoading ? loadingModel['title'] : model[14]['title'],
      //           imageUrl: isLoading
      //               ? loadingModel['imageUrl']
      //               : model[14]['imageUrl'],
      //           subTitle: '',
      //           isCenter: false,
      //           isPrimaryColor: false,
      //           nav: () {
      //             // Call function
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => FundList(
      //                   title: model[5]['title'],
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //         MenuGridItem(
      //           title: isLoading ? loadingModel['title'] : model[15]['title'],
      //           imageUrl: isLoading
      //               ? loadingModel['imageUrl']
      //               : model[15]['imageUrl'],
      //           subTitle: '',
      //           isCenter: false,
      //           isPrimaryColor: false,
      //           nav: () {
      //             // Call function
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => FundAccumulation(
      //                   title: model[15]['title'],
      //                   userData: widget.userData,
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //         MenuGridItem(
      //           title: isLoading ? loadingModel['title'] : model[16]['title'],
      //           imageUrl: isLoading
      //               ? loadingModel['imageUrl']
      //               : model[16]['imageUrl'],
      //           subTitle: '',
      //           isCenter: false,
      //           isPrimaryColor: false,
      //           nav: () {
      //             // Call function
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => FundRemittanceAmount(
      //                   title: model[16]['title'],
      //                   userData: widget.userData,
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //         MenuGridItem(
      //           title: isLoading ? loadingModel['title'] : model[17]['title'],
      //           imageUrl: isLoading
      //               ? loadingModel['imageUrl']
      //               : model[17]['imageUrl'],
      //           subTitle: '',
      //           isCenter: false,
      //           isPrimaryColor: false,
      //           nav: () {
      //             // Call function
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => LoanInformation(
      //                   title: model[17]['title'],
      //                   userData: widget.userData,
      //                   imageUrl: model[17]['imageUrl'],
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //       ],
      //     ),
      //     Row(
      //       children: [
      //         MenuGridItem(
      //           title: isLoading ? loadingModel['title'] : model[18]['title'],
      //           imageUrl: isLoading
      //               ? loadingModel['imageUrl']
      //               : model[18]['imageUrl'],
      //           subTitle: '',
      //           isCenter: false,
      //           isPrimaryColor: false,
      //           nav: () {
      //             // Call function
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => MedicalTreatment(
      //                   title: model[18]['title'],
      //                   userData: widget.userData,
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //         MenuGridItem(
      //           title: isLoading ? loadingModel['title'] : model[13]['title'],
      //           imageUrl: isLoading
      //               ? loadingModel['imageUrl']
      //               : model[13]['imageUrl'],
      //           subTitle: '',
      //           isCenter: false,
      //           isPrimaryColor: false,
      //           nav: () {
      //             // Call function
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => OtherBenefits(
      //                   title: model[13]['title'],
      //                   userData: widget.userData,
      //                 ),
      //               ),
      //             );
      //           },
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    ];
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: CarouselSlider(
              options: CarouselOptions(
                height: 250,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: modelColumn.map<Widget>((document) {
                return document;
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: modelColumn.map<Widget>((res) {
              int index = modelColumn.indexOf(res);
              return Container(
                  width: _current == index ? 20.0 : 5.0,
                  height: 5.0,
                  margin: _current == index
                      ? EdgeInsets.symmetric(vertical: 5.0, horizontal: 1.0)
                      : EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // shape: BoxShape.circle,
                    color: _current == index
                        ? Color(0xFFEB6B37)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ));
            }).toList(),
          ),
        ],
      ),
    );
  }

  // __screen(dynamic model, bool isLoading) {
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.height;
  //   return Padding(
  //     padding: EdgeInsets.only(top: 30),
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[10]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[10]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => BuildTeacherIndex(),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[3]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[3]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     _callReadPolicy(model[3]['title']);
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[4]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[4]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     launchInWebViewWithJavaScript(model[4]['direction']);
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[12]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[12]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PollList(
  //                           title: model[12]['title'],
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[14]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[14]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PollList(
  //                           title: model[14]['title'],
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[15]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[15]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PollList(
  //                           title: model[15]['title'],
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[16]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[16]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PollList(
  //                           title: model[16]['title'],
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[17]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[17]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PollList(
  //                           title: model[17]['title'],
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[5]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[5]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => FundList(
  //                           title: model[5]['title'],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[2]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[2]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => KnowledgeList(
  //                           title: model[2]['title'],
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[7]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[7]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     showMaterialModalBottomSheet(
  //                       duration: const Duration(milliseconds: 300),
  //                       backgroundColor: Colors.transparent,
  //                       context: context,
  //                       builder: (context, scrollController) => Container(
  //                         decoration: BoxDecoration(
  //                           borderRadius: new BorderRadius.only(
  //                             topLeft: const Radius.circular(20.0),
  //                             topRight: const Radius.circular(20.0),
  //                           ),
  //                           color: Colors.white,
  //                         ),
  //                         height: MediaQuery.of(context).size.height * 70 / 100,
  //                         child: BuildGridModal(
  //                           model: widget.model,
  //                           menuModel: widget.menuModel,
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[6]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[6]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PollList(
  //                           title: model[6]['title'],
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[18]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[18]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PollList(
  //                           title: model[18]['title'],
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //                 MenuGridItem(
  //                   title:
  //                       isLoading ? loadingModel['title'] : model[13]['title'],
  //                   imageUrl: isLoading
  //                       ? loadingModel['imageUrl']
  //                       : model[13]['imageUrl'],
  //                   subTitle: '',
  //                   isCenter: false,
  //                   isPrimaryColor: false,
  //                   nav: () {
  //                     // Call function
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => PollList(
  //                           title: model[13]['title'],
  //                           userData: widget.userData,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<Null> _callReadPolicy(String title) async {
    var policy = await postDio(server + "m/policy/read", {
      "category": "marketing",
    });

    if (policy.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder: (context) => PolicyV2Page(
            category: 'marketing',
            navTo: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivilegeMain(
                    title: title,
                  ),
                ),
              );
            },
          ),
        ),
      );

      // if (!isPolicyFasle) {
      //   logout(context);
      //   _onRefresh();
      // }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivilegeMain(
            title: title,
          ),
        ),
      );
    }
  }
}
