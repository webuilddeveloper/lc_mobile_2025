import 'package:flutter/material.dart';

class MenuGridItem extends StatefulWidget {
  const MenuGridItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.isPrimaryColor,
      this.nav,
      required this.isCenter,
      required this.subTitle});

  final Function? nav;
  final bool? isPrimaryColor;
  final String imageUrl;
  final String title;
  final String subTitle;
  final bool isCenter;

  @override
  // ignore: library_private_types_in_public_api
  _MenuGridItem createState() => _MenuGridItem();
}

class _MenuGridItem extends State<MenuGridItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Expanded(
      flex: 0,
      child: InkWell(
        onTap: () {
          widget.nav!();
        },
        child: Container(
          width: (width * 25) / 100,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B6CA8),
                  borderRadius: BorderRadius.circular(100),
                ),
                height: 50,
                width: 50,
                child: Container(
                  child: Image.network(
                    widget.imageUrl,
                    // color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              // SizedBox(height: (height * 1.5) / 100,),
              SizedBox(
                height: 60,
                width: 100,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 13.00,
                          fontFamily: 'Kanit',
                          color: Color(0xFF1B6CA8),
                          fontWeight: FontWeight.w500,
                        ),
                        // maxLines: 1,
                        textAlign: TextAlign.center,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    widget.subTitle != null
                        ? Container(
                            child: Text(
                              widget.subTitle ?? '',
                              style: TextStyle(
                                  fontSize: (height * 1.6) / 100,
                                  fontFamily: 'Kanit',
                                  color: Theme.of(context).primaryColorDark,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : const SizedBox(
                            height: 0.0,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
