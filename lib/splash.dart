import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:lc/menu_v2.dart';
import 'package:lc/pages/auth/login_new.dart';
import 'package:lc/v4/menu_v4.dart';
// import 'package:lc/menu.dart';
import 'pages/blank_page/dialog_fail.dart';
import 'shared/api_provider.dart';
import 'v3/menu_v3.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Future<dynamic> futureModel;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplash();
  }

  _buildSplash() {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              //if no splash from service is return array length 0
              _callTimer((snapshot.data.length > 0
                      ? int.parse(snapshot.data[0]['timeOut']) / 1000
                      : 0)
                  .round());

              return snapshot.data.length > 0
                  ? Center(
                      child: Image.network(
                        snapshot.data[0]['imageUrl'],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    )
                  : Container();
            } else if (snapshot.hasError) {
              postLineNoti();
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
      ),
    );
  }

  _callRead() {
    futureModel = postDio('${server}m/splash/read', {});
  }

  _callTimer(time) async {
    var duration = Duration(seconds: time);
    return Timer(duration, _callNavigatorPage);
  }

  _callNavigatorPage() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'profileCode18');

    if (value != null && value != '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MenuV4(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}
