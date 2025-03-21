import 'package:flutter/material.dart';
import 'package:lc/component/menu/title_menu.dart';
import 'package:lc/shared/extension.dart';

class ListButtonHorizontal extends StatefulWidget {
  const ListButtonHorizontal({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.model,
    required this.navigationList,
    required this.navigationForm,
  });

  final String title;
  final String imageUrl;
  final Future<dynamic> model;
  final Function navigationList;
  final Function(String) navigationForm;

  @override
  // ignore: library_private_types_in_public_api
  _ListButtonHorizontal createState() => _ListButtonHorizontal();
}

class _ListButtonHorizontal extends State<ListButtonHorizontal> {
  // ignore: prefer_final_fields
  dynamic _tempModel = {'title': '', 'imageUrl': '', 'phone': ''};

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return listView(snapshot.data, false);
        } else if (snapshot.hasError) {
          return Container(
            height: 145,
            color: Colors.white,
          );
        } else {
          return listView(_tempModel, true);
        }
      },
    );
  }

  listView(dynamic model, bool isLoading) {
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
          color: Colors.white,
          alignment: Alignment.center,
          height: 145,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return myCircle(
                  model: isLoading ? _tempModel : model[index],
                  isLoading: isLoading,
                  navigationForm: widget.navigationForm);
            },
          ),
        ),
      ],
    );
  }

  myCircle({dynamic model, required bool isLoading, required Function navigationForm}) {
    var title = model['title'] != '' ? model['title'] : _tempModel['title'];
    var phone = model['phone'] != '' ? model['phone'] : _tempModel['phone'];
    // var imageUrl =
    //     model['imageUrl'] != '' ? model['imageUrl'] : _tempModel['imageUrl'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              navigationForm(phone);
            },
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(45),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  backgroundImage: model['imageUrl64'] == null
                      ? NetworkImage(model['imageUrl'])
                      : MemoryImage(image64(model['imageUrl64']))),
            ),
          ),
          Expanded(
            child: Container(
              width: 90.0,
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Kanit',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
