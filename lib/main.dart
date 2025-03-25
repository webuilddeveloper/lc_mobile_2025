import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:flutter/services.dart';

import 'version.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  LineSDK.instance.setup('1655669127').then((_) {
    // ignore: avoid_print
    print('LineSDK Prepared');
  });

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xffe9ebee),
          primaryColor: const Color(0xFF011895),
          primaryColorDark: const Color(0xFFEEBA33),
          hintColor: const Color(0xFFEEBA33),
          // highlightColor: Colors.transparent,
          primaryColorLight: const Color(0xFFdec6c6),
          unselectedWidgetColor: const Color(0xFF6f0100),
          fontFamily: 'Kanit'),
      title: 'สภาทนายความ',
      home: VersionPage(),
      builder: (context, child) {
        return MediaQuery(
          // ignore: sort_child_properties_last
          child: child!,
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
        );
      },
    );
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
