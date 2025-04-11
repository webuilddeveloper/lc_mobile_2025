// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lc/splash.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pages/blank_page/dialog_fail.dart';
import 'shared/api_provider.dart';
import 'widget/dialog.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  late Future<dynamic> futureModel;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['isActive']) {
                // if (versionNumber < snapshot.data['version']) {
                if (versionNumber < 415) {
                  // print('update');

                  return Center(
                    child: Container(
                      color: Colors.white,
                      child: dialogVersion(
                        context,
                        title: snapshot.data['title'],
                        description: snapshot.data['description'],
                        isYesNo: !snapshot.data['isForce'],
                        callBack: (param) {
                          if (param) {
                            launch(snapshot.data['url']);
                          } else {
                            _callGoSplash();
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  _callGoSplash();
                }
              } else {
                _callGoSplash();
              }
              return Container();
            } else if (snapshot.hasError) {
              postLineNoti();
              return Center(
                child: Container(
                  color: Colors.white,
                  child: dialogFail(context, reloadApp: false),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  _callRead() {
    if (Platform.isAndroid) {
      futureModel = postDio(versionReadApi, {'platform': 'Android'});
    } else if (Platform.isIOS) {
      futureModel = postDio(versionReadApi, {'platform': 'Ios'});
    }
  }

  _callGoSplash() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SplashPage()));
    });
  }
}
