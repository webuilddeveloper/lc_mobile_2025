// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lc/component/sso/list_content_horizontal_loading.dart';
import 'package:lc/shared/extension.dart';

// ignore: must_be_immutable
class ListContentHorizontal2 extends StatefulWidget {
  const ListContentHorizontal2({
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
  _ListContentHorizontal2 createState() => _ListContentHorizontal2();
}

class _ListContentHorizontal2 extends State<ListContentHorizontal2> {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                // Container(
                //   padding: EdgeInsets.all(8.0),
                //   margin: EdgeInsets.only(left: 15, right: 5.0),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [
                //         Theme.of(context).accentColor,
                //         Theme.of(context).accentColor,
                //       ],
                //       begin: Alignment.topLeft,
                //       end: new Alignment(1, 0.0),
                //     ),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   height: 30,
                //   width: 30,
                //   child: Container(
                //     child: loadingImageNetwork(
                //       widget.imageUrl,
                //     ),
                //   ),
                // ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(
                    bottom: 5,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      // color: Theme.of(context).accentColor,
                      // fontWeight: FontWeight.w500,
                      color: Color(0xFF1B6CA8),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                widget.navigationList();
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(right: 15),
                margin: const EdgeInsets.only(bottom: 5),
                child: const Text(
                  'ดูทั้งหมด',
                  style: TextStyle(
                    color: Color(0xFFED6B2D),
                    // decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        renderCard(
          widget.title,
          widget.url,
          widget.model,
          widget.urlComment,
          widget.navigationForm,
          widget.urlGallery,
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
        return SizedBox(
          height: 180,
          child: ListView.builder(
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
          ),
        );
      } else if (snapshot.hasError) {
        return Container();
      } else {
        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListContentHorizontalLoading();
            },
          ),
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
          ? const EdgeInsets.only(left: 5.0, bottom: 5.0, top: 5.0, right: 2.5)
          : index == lastIndex - 1
              ? const EdgeInsets.only(left: 2.5, bottom: 5.0, top: 5.0, right: 5.0)
              : const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(220),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: model['imageUrl64'] == null
                        ? NetworkImage(model['imageUrl'])
                        : MemoryImage(image64(model['imageUrl64'])),
                  ),
                ),
              ),
              // child: loadingImageNetwork(
              //   model['imageUrl'],
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          // Expanded( child:
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  model['title'],
                  style: const TextStyle(
                    // fontWeight: FontWeight.w400,
                    fontSize: 10,
                    fontFamily: 'Kanit',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // ),
        ],
      ),
    ),
  );
}
