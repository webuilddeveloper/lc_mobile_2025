import 'package:flutter/material.dart';
import 'package:lc/component/sso/list_content_horizontal_loading.dart';
import 'package:lc/shared/api_provider.dart';

// ignore: must_be_immutable
class ListContentHorizontalPrivilegeV3 extends StatefulWidget {
  ListContentHorizontalPrivilegeV3(
      {Key? key,
      required this.title,
      required this.code,
      required this.model,
      required this.navigationList,
      required this.navigationForm})
      : super(key: key);

  final String code;
  final String title;
  final Future<dynamic> model;
  final Function() navigationList;
  final Function(String, dynamic) navigationForm;

  @override
  _ListContentHorizontalPrivilegeV3 createState() =>
      _ListContentHorizontalPrivilegeV3();
}

class _ListContentHorizontalPrivilegeV3
    extends State<ListContentHorizontalPrivilegeV3> {
  late Future<dynamic> _futurePrivilege;

  @override
  void initState() {
    _futurePrivilege = post('${privilegeApi}read',
        {'skip': 0, 'limit': 100, 'category': widget.code});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10.0),
                      margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.navigationList();
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 10.0),
                        margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                        child: Text(
                          'ดูทั้งหมด',
                          style: TextStyle(fontSize: 12.0, fontFamily: 'Kanit'),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 220,
                  color: Colors.transparent,
                  child: renderCard(
                    widget.title,
                    widget.model,
                    widget.navigationForm,
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.navigationList();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 2),
                        margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.5),
                            color: Color(0xFF8AD2FF).withOpacity(.25)),
                        child: Text(
                          'ดูทั้งหมด',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Kanit',
                              color: Color(0xFF2D9CED)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 220,
                color: Colors.transparent,
                child: renderCard(
                    widget.title, widget.model, widget.navigationForm),
              ),
            ],
          );
        }
      },
    );
  }
}

renderCard(String title, Future<dynamic> model, Function navigationForm) {
  return FutureBuilder<dynamic>(
    future: model, // function where you call your api
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      // AsyncSnapshot<Your object type>

      if (snapshot.hasData) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return myCard(index, snapshot.data.length, snapshot.data[index],
                context, navigationForm);
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

renderCardList(String title, Future<dynamic> model, Function navigationForm) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 10,
    itemBuilder: (context, index) {
      return ListContentHorizontalLoading();
    },
  );
}

myCard(int index, int lastIndex, dynamic model, BuildContext context,
    Function navigationForm) {
  return InkWell(
    onTap: () {
      navigationForm(model['code'], model);
    },
    child: Container(
      margin: index == 0
          ? EdgeInsets.only(left: 10.0, right: 5.0)
          : index == lastIndex - 1
              ? EdgeInsets.only(left: 5.0, right: 15.0)
              : EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5),
          // color: Color(0xFF9A1120),
          color: Colors.transparent),
      width: 164.0,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 164.0,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(15),
              color: Colors.white.withAlpha(220),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(model['imageUrl']),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 160.0),
            padding: EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0),
              ),
              // color: Color(0xFFDDDDDD),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF023047),
                    fontFamily: 'Kanit',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                // Text(
                //   dateStringToDate(model['createDate']),
                //   style: TextStyle(
                //     fontWeight: FontWeight.normal,
                //     fontSize: 8,
                //     fontFamily: 'Kanit',
                //     color: Color(0xFF023047),
                //   ),
                //   overflow: TextOverflow.ellipsis,
                // ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
