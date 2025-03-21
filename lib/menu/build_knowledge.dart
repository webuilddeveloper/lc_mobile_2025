import 'package:flutter/material.dart';
import 'package:lc/component/sso/list_content_horizontal_2.dart';
import 'package:lc/pages/knowledge/knowledge_form.dart';
import 'package:lc/pages/knowledge/knowledge_list.dart';
import 'package:lc/shared/api_provider.dart';

class BuildKnowledge extends StatefulWidget {
  BuildKnowledge({Key? key, required this.menuModel, required this.model}) : super(key: key);

  final Future<dynamic> model;
  final Future<dynamic> menuModel;

  @override
  BuildKnowledgeState createState() => BuildKnowledgeState();
}

class BuildKnowledgeState extends State<BuildKnowledge> {
  dynamic _tempModel = {'imageUrl': '', 'firstName': '', 'lastName': ''};

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
              child: Center(
                child: Text('Network ขัดข้อง'),
              ),
            );
          } else {
            return screen(_tempModel, true);
          }
        });
  }

  ListContentHorizontal2 screen(dynamic model, bool isLoading) {
    var title = isLoading ? '' : model[6]['title'];
    var imageUrl = isLoading ? '' : model[6]['imageUrl'];

    return ListContentHorizontal2(
      title: title,
      url: newsApi,
      imageUrl: imageUrl,
      model: widget.model,
      urlComment: newsCommentApi,
      navigationList: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KnowledgeList(
              title: model[6]['title'],
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
            builder: (context) => KnowledgeForm(
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
