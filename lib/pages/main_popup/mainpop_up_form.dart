import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lc/pages/poll/poll_form.dart';

class MainPopup extends StatefulWidget {
  const MainPopup({super.key, required this.model, required this.nav});

  final Future<dynamic> model;
  final Function(String, String, dynamic, String, String) nav;

  @override
  // ignore: library_private_types_in_public_api
  _MainPopup createState() => _MainPopup();
}

class _MainPopup extends State<MainPopup> {
  final txtDescription = TextEditingController();
  int _current = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // double sideLength = 50;
        // final double height = MediaQuery.of(context).size.height;
        if (snapshot.hasData) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  snapshot.data[_current]['isPopup'] == true
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PollForm(
                                code: snapshot.data[_current]['code'],
                                model: snapshot.data[_current],
                                titleMenu: 'AA',
                                titleHome: 'AA',
                                url: snapshot.data[_current]['url']),
                          ),
                        )
                      : widget.nav(
                          snapshot.data[_current]['linkUrl'],
                          snapshot.data[_current]['action'],
                          snapshot.data[_current],
                          snapshot.data[_current]['code'],
                          '',
                        );
                },
                child: snapshot.data.length > 1
                    ? CarouselSlider(
                        options: CarouselOptions(
                          height: height * 0.6,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: snapshot.data.map<Widget>(
                          (document) {
                            return SizedBox(
                              height: 480,
                              width: 360,
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    '${document['imageUrl']}',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      )
                    : SizedBox(
                        height: 480,
                        width: 360,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              '${snapshot.data[0]['imageUrl']}',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          );
        } else {
          return Container(height: (height * 22.5) / 100);
        }
      },
    );
  }
}
