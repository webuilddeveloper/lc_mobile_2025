import 'package:flutter/material.dart';

class BuildAboutUs extends StatefulWidget {
  const BuildAboutUs({super.key, required this.menuModel, this.model});

  final Future<dynamic>? model;
  final Future<dynamic> menuModel;

  @override
  BuildAboutUsState createState() => BuildAboutUsState();
}

class BuildAboutUsState extends State<BuildAboutUs> {
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

  Column screen(dynamic model, bool isLoading) {
    var title = isLoading ? '' : model[9]['title'];
    var imageUrl = isLoading ? '' : model[9]['imageUrl'];

    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Container(
        //       padding: EdgeInsets.all(6.0),
        //       margin: EdgeInsets.only(left: 15, right: 5.0),
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           colors: [
        //             Theme.of(context).accentColor,
        //             Theme.of(context).primaryColor,
        //           ],
        //           begin: Alignment.topLeft,
        //           end: new Alignment(1, 0.0),
        //         ),
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       height: 30,
        //       width: 30,
        //       child: Container(
        //         child: Image.asset(
        //           'assets/logo/icons/i.png',
        //         ),
        //       ),
        //     ),
        //     Container(
        //       alignment: Alignment.centerLeft,
        //       // padding: EdgeInsets.only(left: 15),
        //       margin: EdgeInsets.only(bottom: 5),
        //       child: Text(
        //         title,
        //         style: TextStyle(
        //           color: Color(0xFFFFFFFF),
        //           fontWeight: FontWeight.w500,
        //           fontSize: 15,
        //           fontFamily: 'Kanit',
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => AboutUsForm(
            //       model: widget.model,
            //       title: title,
            //     ),
            //   ),
            // );
          },
          child: Container(
            height: 80.0,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ],
    );
  }

  // .end
}
