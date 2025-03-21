import 'package:flutter/material.dart';
import 'package:lc/component/carousel_banner.dart';
import 'package:lc/component/carousel_form.dart';
import 'package:lc/component/header.dart';
import 'package:lc/component/link_url_in.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/pages/contact/contact_list_category_vertical.dart';

class ContactListCategory extends StatefulWidget {
  ContactListCategory({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ContactListCategory createState() => _ContactListCategory();
}

class _ContactListCategory extends State<ContactListCategory> {
  late ContactListCategoryVertical contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;

  late Future<dynamic> _futureBanner;
  late Future<dynamic> _futureCategoryContact;
  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _futureCategoryContact =
        postDio('${contactCategoryApi}read', {'skip': 0, 'limit': 999});
    _futureBanner =
        postDio('${contactBannerApi}read', {'skip': 0, 'limit': 50});

    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
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
        appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            // controller: _controller,
            children: [
              CarouselBanner(
                model: _futureBanner,
                nav: (String path, String action, dynamic model, String code,
                    String urlGallery) {
                  if (action == 'out') {
                    launchInWebViewWithJavaScript(path);
                    // launchURL(path);
                  } else if (action == 'in') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarouselForm(
                          code: code,
                          model: model,
                          url: contactBannerApi,
                          urlGallery: bannerGalleryApi,
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              ContactListCategoryVertical(
                site: "LC",
                model: _futureCategoryContact,
                title: "",
                url: '${contactCategoryApi}read',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
