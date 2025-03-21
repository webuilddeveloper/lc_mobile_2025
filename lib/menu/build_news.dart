import 'package:flutter/material.dart';
import 'package:lc/component/sso/list_content_horizontal.dart';
import 'package:lc/pages/news/news_form.dart';
import 'package:lc/pages/news/news_list.dart';
import 'package:lc/shared/api_provider.dart';

class BuildNews extends StatefulWidget {
  const BuildNews({super.key, required this.menuModel, required this.model});

  final Future<dynamic> model;
  final Future<dynamic> menuModel;

  @override
  BuildNewsState createState() => BuildNewsState();
}

class BuildNewsState extends State<BuildNews> {
  final dynamic _tempModel = {'imageUrl': '', 'firstName': '', 'lastName': ''};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: widget.menuModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return screen(snapshot.data, false);
          } else if (snapshot.hasError) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              height: 90,
              child: const Center(
                child: Text('Network ขัดข้อง'),
              ),
            );
          } else {
            return screen(_tempModel, true);
          }
        });
  }

  ListContentHorizontal screen(dynamic model, bool isLoading) {
    var title = isLoading ? '' : model[7]['title'];
    var imageUrl = isLoading ? '' : model[7]['imageUrl'];

    return ListContentHorizontal(
      title: title,
      url: newsApi,
      imageUrl: imageUrl,
      model: widget.model,
      urlComment: newsCommentApi,
      navigationList: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsList(
              title: model[7]['title'],
            ),
          ),
        );
      },
      navigationForm: (
        String code,
        String url,
        dynamic model,
        String urlComment,
        String urlGallery,
      ) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsForm(
              code: code,
              model: model,
            ),
          ),
        );
      },
      urlGallery: newsGalleryApi,
    );
  }
  // .end
}
