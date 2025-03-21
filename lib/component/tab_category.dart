import 'package:flutter/material.dart';
import 'package:lc/shared/api_provider.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key, this.site, this.model, this.onChange});

//  final VoidCallback onTabCategory;
  final String? site;
  final Function(String)? onChange;
  final Future<dynamic>? model;

  @override
  // ignore: library_private_types_in_public_api
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(6.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    widget.onChange!(snapshot.data[index]['code']);
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      snapshot.data[index]['title'],
                      style: TextStyle(
                        color:
                            index == selectedIndex ? Colors.black : Colors.grey,
                        decoration: index == selectedIndex
                            ? TextDecoration.underline
                            : null,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}

class CategorySelectorV2 extends StatefulWidget {
  const CategorySelectorV2({super.key, this.site, this.model, this.onChange});

//  final VoidCallback onTabCategory;
  final String? site;
  final Function(String, String)? onChange;
  final Future<dynamic>? model;

  @override
  // ignore: library_private_types_in_public_api
  _CategorySelectorV2State createState() => _CategorySelectorV2State();
}

class _CategorySelectorV2State extends State<CategorySelectorV2> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2,
            ),
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  widget.onChange!(snapshot.data[index]['code'],
                      snapshot.data[index]['title']);
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 10.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: index == selectedIndex
                          ? Colors.grey.shade200.withOpacity(0.5)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: Text(
                        snapshot.data[index]['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class CategorySelector2 extends StatefulWidget {
  const CategorySelector2({
    super.key,
    this.site,
    this.model,
    this.onChange,
    this.path,
    this.code = '',
    this.skip,
    this.limit,
  });

//  final VoidCallback onTabCategory;
  final String? site;
  final Function(String, String)? onChange;
  final Future<dynamic>? model;
  final String? code;
  final String? path;
  final dynamic skip;
  final dynamic limit;

  @override
  // ignore: library_private_types_in_public_api
  _CategorySelector2State createState() => _CategorySelector2State();
}

class _CategorySelector2State extends State<CategorySelector2> {
  dynamic res;
  String selectedIndex = '';
  String selectedTitleIndex = '';

  @override
  void initState() {
    res = postDioCategoryWeMart(widget.path!, {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: res, // function where you call your api\
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          return Wrap(
            children: snapshot.data
                .map<Widget>(
                  (c) => GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      widget.onChange!(c['code'], c['title']);
                      setState(() {
                        selectedIndex = c['code'];
                        selectedTitleIndex = c['title'];
                      });
                    },
                    child: Container(
                      width: 85,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 10, bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: c['code'] == selectedIndex
                            ? const Color(0xFFFFFFFF).withOpacity(0.2)
                            : Colors.transparent,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Text(
                        c['title'],
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          // decoration: index == selectedIndex
                          //     ? TextDecoration.underline
                          //     : null,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.2,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        } else {
          return Container(
            height: 25.0,
            // padding: EdgeInsets.only(left: 5.0, right: 5.0),
            // margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}

class CategorySelector2NoAll extends StatefulWidget {
  const CategorySelector2NoAll({
    super.key,
    this.site,
    this.model,
    this.onChange,
    this.path,
    this.code = '',
    this.skip,
    this.limit,
  });

//  final VoidCallback onTabCategory;
  final String? site;
  final Function(String)? onChange;
  final Future<dynamic>? model;
  final String? code;
  final String? path;
  final dynamic skip;
  final dynamic limit;

  @override
  // ignore: library_private_types_in_public_api
  _CategorySelector2StateNoAll createState() => _CategorySelector2StateNoAll();
}

class _CategorySelector2StateNoAll extends State<CategorySelector2NoAll> {
  dynamic res;
  String selectedIndex = '';

  @override
  void initState() {
    res = postDioCategoryWeMartNoAll(
        widget.path!, {'skip': widget.skip, 'limit': widget.limit});
    // selectedIndex = widget.code;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: res, // function where you call your api\
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          return SizedBox(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onChange!(snapshot.data[index]['code']);
                    setState(() {
                      selectedIndex = snapshot.data[index]['code'];
                    });
                  },
                  child: Container(
                    width: 85,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: snapshot.data[index]['code'] == selectedIndex
                          ? const Color(0xFF3F73E6)
                          : Colors.transparent,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7.0,
                      // vertical: 5.0,
                    ),
                    child: Text(
                      snapshot.data[index]['title'],
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 25.0,
            // padding: EdgeInsets.only(left: 5.0, right: 5.0),
            // margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
