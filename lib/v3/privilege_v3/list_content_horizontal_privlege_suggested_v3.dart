import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lc/component/sso/list_content_horizontal_loading.dart';
import 'package:lc/shared/extension.dart';
import 'package:lc/v3/privilege_v3/privilege_form_v3.dart';

import '../../component/loadingImageNetwork.dart';

// ignore: must_be_immutable
class ListContentHorizontalPrivilegeSuggestedV3 extends StatefulWidget {
  const ListContentHorizontalPrivilegeSuggestedV3(
      {super.key,
      required this.title,
      required this.url,
      required this.model,
      required this.urlComment,
      this.navigationList,
      this.navigationForm});

  final String title;
  final String url;
  final Future<dynamic> model;
  final String urlComment;
  final Function()? navigationList;
  final Function(String, dynamic)? navigationForm;

  @override
  // ignore: library_private_types_in_public_api
  _ListContentHorizontalPrivilegeSuggestedV3 createState() =>
      _ListContentHorizontalPrivilegeSuggestedV3();
}

class _ListContentHorizontalPrivilegeSuggestedV3
    extends State<ListContentHorizontalPrivilegeSuggestedV3> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Container(
        //       alignment: Alignment.centerLeft,
        //       padding: EdgeInsets.only(left: 10.0),
        //       margin: EdgeInsets.only(bottom: 5.0),
        //       child: Text(
        //         widget.title,
        //         style: TextStyle(
        //           // color: Color(0xFF9A1120),
        //           color: Colors.black,
        //           fontWeight: FontWeight.bold,
        //           fontSize: 18,
        //           fontFamily: 'Kanit',
        //         ),
        //       ),
        //     ),
        //     InkWell(
        //       onTap: () {
        //         widget.navigationList();
        //       },
        //       child: Container(
        //           padding: EdgeInsets.only(right: 10.0),
        //           margin: EdgeInsets.only(bottom: 5.0),
        //           child: Text(
        //             'ดูทั้งหมด',
        //             style: TextStyle(fontSize: 12.0, fontFamily: 'Kanit'),
        //           )
        //           // Image.asset(
        //           //   'assets/images/double_arrow_right.png',
        //           //   height: 15.0,
        //           // )
        //           ),
        //     ),
        //   ],
        // ),

        Container(
          height: 350,
          color: Colors.transparent,
          child: renderCard(widget.title, widget.url, widget.model,
              widget.urlComment, widget.navigationForm as Function),
        ),
      ],
    );
  }

  heightCalculate(double height) {
    return (((MediaQuery.of(context).size.width *
                    MediaQuery.of(context).size.height) /
                MediaQuery.of(context).size.height) -
            MediaQuery.of(context).size.width) +
        height;
  }

  renderCard(String title, String url, Future<dynamic> model, String urlComment,
      Function navigationForm) {
    return FutureBuilder<dynamic>(
      future: model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return myCard(index, snapshot.data.length, snapshot.data[index],
                  context, navigationForm);
            },
          );
          // } else if (snapshot.hasError) {
          //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListContentHorizontalLoading();
            },
          );
        }
      },
    );
  }

  myCard(int index, int lastIndex, dynamic model, BuildContext context,
      Function navigationForm) {
    return InkWell(
      onTap: () {
        navigationForm(model['code'], model);
      },
      child: Column(
        children: [
          Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: Color(0xFF000000)
                  ),
                  margin: index == 0
                      ? const EdgeInsets.only(left: 10.0, right: 5.0)
                      : index == lastIndex - 1
                          ? const EdgeInsets.only(left: 5.0, right: 15.0)
                          : const EdgeInsets.symmetric(horizontal: 5.0),
                  // height: 334,
                  height: heightCalculate(340),
                  width: heightCalculate(340),
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivilegeFormV3(
                                code: model['code'],
                                model: model,
                                urlRotation: '',
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0x268AD2FF),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: loadingImageNetwork(
                                  model['imageUrl'],
                                  height:
                                      MediaQuery.of(context).size.width - 30,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 15,
                              right: 15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  // height: 98,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF).withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5,
                                      sigmaY: 5,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${model['title']}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${model['createDate']}' != null
                                              ? dateStringToDate(
                                                  '${model['createDate']}')
                                              : '',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
