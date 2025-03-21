import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/carousel_banner.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/header.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/pages/reporter/reporter_history_list.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/pages/reporter/reporter_list_category_vertical.dart';

class ReporterListCategory extends StatefulWidget {
  const ReporterListCategory({super.key, required this.title});
  final String title;
  @override
  // ignore: library_private_types_in_public_api
  _ReporterListCategory createState() => _ReporterListCategory();
}

class _ReporterListCategory extends State<ReporterListCategory> {
  final storage = const FlutterSecureStorage();

  late ReporterListCategoryVertical reporter;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;

  late Future<dynamic> _futureBanner;
  late Future<dynamic> _futureCategoryReporter;
  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _futureCategoryReporter =
        postDio('${reporterCategoryApi}read', {'skip': 0, 'limit': 50});
    _futureBanner =
        postDio('${reporterBannerApi}read', {'skip': 0, 'limit': 50});

    // _controller.addListener(_scrollListener);
    super.initState();
    // reporter = new ReporterListCategoryVertical(
    //   site: "LC",
    //   model: service
    //       .post('${service.reporterCategoryApi}read', {'skip': 0, 'limit': 100}),
    //   title: "",
    //   url: '${service.reporterCategoryApi}read',
    // );
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => MenuV2()),
    // );
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
  }

  Future<void> _handleClickMe() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    if (!mounted) return; // ✅ ป้องกันข้อผิดพลาดจากการเปลี่ยน context หลัง async

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporterHistoryList(
          title: 'ประวัติ',
          username: user['username'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: header(
          context,
          goBack,
          title: widget.title,
          isButtonRight: true,
          rightButton: () async =>
              await _handleClickMe(), // ✅ ใช้ async function
          menu: 'reporter',
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: ListView(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(
                height: (height * 25) / 100,
                child: CarouselBanner(
                  model: _futureBanner,
                  nav: (String path, String action, dynamic model, String code,
                      String urlGallery) {
                    if (action == 'out') {
                      launchInWebViewWithJavaScript(path);
                    } else if (action == 'in') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarouselForm(
                            code: code,
                            model: model,
                            url: reporterBannerApi,
                            urlGallery: bannerGalleryApi,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 10),
              ReporterListCategoryVertical(
                site: "LC",
                model: _futureCategoryReporter,
                title: "",
                url: '${reporterCategoryApi}read',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
