import 'dart:async';

import 'package:lc/component/sso/list_content_horizontal_loading.dart';
import 'package:lc/pages/blank_page/dialog_fail.dart';
import 'package:flutter/material.dart';
import 'package:lc/shared/extension.dart';

import '../loadingImageNetwork.dart';

// ignore: must_be_immutable รูปฝั่งซ้าย หัวข้อกับคำอธิบายฝั่งขวา (vertical, ความยาวยืดสุดยืดสุด)
class ListContent4 extends StatefulWidget {
  const ListContent4({
    super.key,
    this.title = '',
    required this.model,
    this.height = 160,
    required this.navigationForm,
  });

  final String title;
  final double height;
  final Future<dynamic> model;
  final Function(dynamic) navigationForm;

  @override
  // ignore: library_private_types_in_public_api
  _ListContent4 createState() => _ListContent4();
}

class _ListContent4 extends State<ListContent4> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      height: widget.height,
      child: FutureBuilder<dynamic>(
        future: widget.model, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // AsyncSnapshot<Your object type>
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              // padding: EdgeInsets.only(bottom: 15),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _card(
                  model: snapshot.data[index],
                  index: index,
                  lastIndex: snapshot.data.length,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
      ),
    );
  }

  _card({dynamic model, int index = 0, int lastIndex = 0}) {
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 5);

    return InkWell(
      onTap: () {
        widget.navigationForm(model);
      },
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
        ),
        width: 120,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                ),
                // image: DecorationImage(
                //   fit: BoxFit.fill,
                //   image:  NetworkImage(model['imageUrl']),
                // ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: loadingImageNetwork(
                        model['imageUrl'],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable รูปฝั่งซ้าย หัวข้อกับคำอธิบายฝั่งขวา (vertical, ความยาวยืดสุดยืดสุด)
class ListContent2 extends StatefulWidget {
  const ListContent2({
    Key? key,
    this.title = '',
    required this.model,
    required this.navigationForm,
  }) : super(key: key);

  final String title;
  final Future<dynamic> model;
  final Function(dynamic) navigationForm;

  @override
  // ignore: library_private_types_in_public_api
  _ListContent2 createState() => _ListContent2();
}

class _ListContent2 extends State<ListContent2> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state = $state');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(bottom: 15),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _card(
                  model: snapshot.data[index],
                  index: index,
                  lastIndex: snapshot.data.length,
                );
              },
            );
          } else {
            return Container(
              width: double.infinity,
              height: 300,
              alignment: Alignment.center,
              child: const Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 15,
                ),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              color: Colors.white,
              child: dialogFail(context, reloadApp: false),
            ),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListContentHorizontalLoading();
            },
          );
        }
      },
    );
  }

  _card({dynamic model, int index = 0, int lastIndex = 0}) {
    String textHtml = model['description'] != null && model['description'] != ''
        ? model['description']
        : '';
    EdgeInsets margin = const EdgeInsets.symmetric(horizontal: 10, vertical: 5);

    return InkWell(
      onTap: () {
        widget.navigationForm(model);
      },
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
        ),
        width: double.infinity,
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: loadingImageNetwork(
                model['imageUrl'],
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                children: [
                  Container(
                    child: Text(
                      model['title'],
                      style: const TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: Text(
                      parseHtmlString(textHtml),
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
