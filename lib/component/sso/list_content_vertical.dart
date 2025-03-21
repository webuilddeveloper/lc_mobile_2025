import 'package:flutter/material.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';

// ignore: must_be_immutable
class ListContentVertical extends StatefulWidget {
  const ListContentVertical({super.key, required this.title, required this.url});

  final String title;
  final String url;
  // Future<dynamic> _model;
  // String _urlComment;

  @override
  // ignore: library_private_types_in_public_api
  _ListContentVertical createState() => _ListContentVertical();
}

class _ListContentVertical extends State<ListContentVertical> {
  late Future<dynamic> _futureModel;

  @override
  void initState() {
    super.initState();
    _futureModel = post('${widget.url}read', {'skip': 0, 'limit': 10});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(

        // future: widget.model,
        future: _futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true, // 1st add
              physics: const ClampingScrollPhysics(), // 2nd
              // scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return myCard('', '', snapshot.data[index], context);
              },
            );
          } else {
            return const Text('x');
          }
        });
  }
}

myCard(String title, String url, dynamic model, BuildContext context) {
  return InkWell(
    onTap: () {},
    child: Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: Color(0xFF9A1120),
          color: Colors.transparent),
      width: 150,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
              ),
              color: Colors.white.withAlpha(220),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(model['imageUrl']),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 250),
            padding: const EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
                color: Colors.black.withAlpha(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: Colors.black.withAlpha(150),
                    fontFamily: 'Kanit',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  dateStringToDate(model['createDate']),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8,
                    color: Colors.black.withAlpha(150),
                    fontFamily: 'Kanit',
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
