import 'package:flutter/material.dart';
import 'package:lc/pages/blank_page/blank_data.dart';
import 'package:lc/pages/search_lawyer/search_lawyer_form.dart';

class SearchLawyerListVertical extends StatefulWidget {
  const SearchLawyerListVertical({
    super.key,
    this.site,
    this.model,
    this.title,
    this.url,
    this.urlComment,
    this.urlGallery,
    this.lcCategory = false,
  });

  final String? site;
  final Future<dynamic>? model;
  final String? title;
  final String? url;
  final String? urlComment;
  final String? urlGallery;
  final bool lcCategory;

  @override
  // ignore: library_private_types_in_public_api
  _SearchLawyerListVertical createState() => _SearchLawyerListVertical();
}

class _SearchLawyerListVertical extends State<SearchLawyerListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: const Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return card(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            child: const Text(
              'Network ขัดข้อง',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
            ),
          );
        } else {
          return blankListData(context);
        }
      },
    );
  }

  card(dynamic model) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchLawyerForm(
                      model: model[index],
                      lcCategory: widget.lcCategory,
                    ),
                  ),
                );
              },
              child: Container(
                width: 170,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFFFFFFF),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      // padding: EdgeInsets.all(
                      //     '${model['imageUrl']}' != '' ? 0.0 : 5.0),
                      margin: const EdgeInsets.only(bottom: 10, left: 50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.black12),
                      height: 70,
                      width: 70,
                      child: GestureDetector(
                        // onTap: () => widget.nav(),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            'assets/images/user_not_found.png',
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: Center(
                        child: Text(
                          '${model[index]['title_t']}${model[index]['fname_t']} ${model[index]['lname_t']}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF2D9CED),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: const Center(
                        child: Text(
                          "ทนายความ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
