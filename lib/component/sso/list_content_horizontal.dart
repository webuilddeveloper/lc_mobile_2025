// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lc/component/menu/title_menu.dart';
import 'package:lc/component/sso/list_content_horizontal_loading.dart';
import 'package:lc/shared/extension.dart';

import '../loadingImageNetwork.dart';

// ignore: must_be_immutable
class ListContentHorizontal extends StatefulWidget {
  const ListContentHorizontal({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.url,
    required this.model,
    required this.urlComment,
    required this.navigationList,
    required this.navigationForm,
    required this.urlGallery,
  });

  final String title;
  final String imageUrl;
  final String url;
  final String urlGallery;
  final Future<dynamic> model;
  final String urlComment;
  final Function() navigationList;
  final Function(String, String, dynamic, String, String) navigationForm;

  @override
  _ListContentHorizontal createState() => _ListContentHorizontal();
}

class _ListContentHorizontal extends State<ListContentHorizontal> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleMenu(
          context: context,
          title: widget.title,
          imageUrl: widget.imageUrl,
          callback: () {
            widget.navigationList();
          },
        ),
        Container(
          alignment: Alignment.center,
          height: 240,
          child: renderCard(
            widget.title,
            widget.url,
            widget.model,
            widget.urlComment,
            widget.navigationForm,
            widget.urlGallery,
          ),
        ),
      ],
    );
  }
}

renderCard(
  String title,
  String url,
  Future<dynamic> model,
  String urlComment,
  Function navigationForm,
  String urlGallery,
) {
  return FutureBuilder<dynamic>(
    future: model, // function where you call your api
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      // AsyncSnapshot<Your object type>

      if (snapshot.hasData) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return myCard(
              title,
              index,
              snapshot.data.length,
              url,
              snapshot.data[index],
              urlComment,
              context,
              navigationForm,
              urlGallery,
            );
          },
        );
        // } else if (snapshot.hasError) {
        //   return Center(child: Text('Error: ${snapshot.error}'));
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
  );
}

myCard(
  String title,
  int index,
  int lastIndex,
  String url,
  dynamic model,
  String urlComment,
  BuildContext context,
  Function navigationForm,
  String urlGallery,
) {
  return InkWell(
    onTap: () {
      navigationForm(model['code'], url, model, urlComment, urlGallery);
    },
    child: Container(
      margin: index == 0
          ? const EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0, right: 5.0)
          : index == lastIndex - 1
              ? const EdgeInsets.only(
                  left: 5.0, bottom: 5.0, top: 5.0, right: 10.0)
              : const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: Color(0xFF9A1120),
          color: Colors.transparent),
      width: 150,
      height: 250,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              color: Colors.white.withAlpha(220),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: model['imageUrl64'] == null
                    ? NetworkImage(model['imageUrl'])
                    : MemoryImage(image64(model['imageUrl64'])),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 120),
            padding: const EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            height: 120,
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: const Color(0xFF359EEA)),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
                color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black.withAlpha(150),
                    fontFamily: 'Kanit',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                // Text(
                //   dateStringToDate(model['createDate']),
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 8,
                //     fontFamily: 'Kanit',
                //     color: Colors.black.withAlpha(150),
                //   ),
                // ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: loadingImageNetwork(
                            model['userList'] != null &&
                                    model['userList'].length > 0
                                ? '${model['userList'][0]['imageUrl']}'
                                : '${model['imageUrlCreateBy']}',
                            fit: BoxFit.fill,
                            isProfile: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          model['userList'] != null &&
                                  model['userList'].length > 0
                              ? '${model['userList'][0]['firstName']} ${model['userList'][0]['lastName']}'
                              : '${model['createBy']}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
