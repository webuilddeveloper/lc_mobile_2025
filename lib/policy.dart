import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lc/v3/widget/header_v3.dart';
import 'package:lc/v4/widget/header_v4.dart';

import 'package:url_launcher/url_launcher.dart';

import 'pages/blank_page/dialog_fail.dart';
import 'shared/api_provider.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  late Future<dynamic> futureModel;
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPolicy();
  }

  _callRead() {
    futureModel = postDio('${server}m/policy/readAccept', {
      "category": "application",
    });
  }

  _buildPolicy() {
    return Scaffold(
      appBar: headerV4(context, () {
        Navigator.pop(context);
      }, title: 'นโยบาย'),
      backgroundColor: Colors.white,
      body: FutureBuilder<dynamic>(
        future: futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                // padding: const EdgeInsets.all(10.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    card(snapshot.data),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                color: Colors.white,
                child: dialogFail(context, reloadApp: true),
              ),
            );
          } else {
            return Center(
              child: Container(),
            );
          }
        },
      ),
    );
  }

  card(dynamic model) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 20.0),
          child: formContentStep1(model)),
    );
  }

  formContentStep1(dynamic model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var item in model)
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      item['imageUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    item['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Kanit',
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Html(
                    data: item['description'],
                    onLinkTap:
                        (String? url, Map<String, String> attributes, element) {
                      launch(url!);
                      //open URL in webview, or launch URL in browser, or any other logic here
                    },
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
