import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/component/carousel_banner.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/pages/reporter/reporter_list_category_vertical.dart';
import 'package:lc/v3/reporter_v3/reporter_history_list_v3.dart';
import 'package:lc/v3/widget/header_v3.dart';

class ReporterListCategoryV3 extends StatefulWidget {
  const ReporterListCategoryV3({super.key, this.title});
  final String? title;
  @override
  _ReporterListCategoryV3 createState() => _ReporterListCategoryV3();
}

class _ReporterListCategoryV3 extends State<ReporterListCategoryV3> {
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

  void _handleClickMe() async {
    var value = await storage.read(key: 'dataUserLoginLC');
    var user = json.decode(value!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporterHistoryListV3(
          title: 'ประวัติ',
          username: user['username'],
        ),
      ),
    );
    // Navigator.pop(context);
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
        appBar: headerV3(
          context,
          goBack,
          title: widget.title!,
          isButtonRight: true,
          rightButton: () => _handleClickMe(),
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
