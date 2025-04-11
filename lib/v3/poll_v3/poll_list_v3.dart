import 'package:flutter/material.dart';
import 'package:lc/models/user.dart';
import 'package:lc/shared/api_provider.dart' as service;
import 'package:lc/v3/poll_v3/poll_list_vertical_v3.dart';
import 'package:lc/v3/widget/header_v3.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../shared/api_provider.dart';

class PollListV3 extends StatefulWidget {
  const PollListV3({Key? key, required this.userData, required this.title})
      : super(key: key);

  final User userData;
  final String title;

  @override
  _PollListV3 createState() => _PollListV3();
}

class _PollListV3 extends State<PollListV3> with TickerProviderStateMixin {
  late PollListVerticalV3 poll;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;
  bool _showSearch = false;
  late AnimationController _animationSearchController;
  TextEditingController _searchController = new TextEditingController();
  bool _isSearch = false;
  String categorySelected = '';
  bool isHighlight = false;
  bool isMain = true;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      poll = new PollListVerticalV3(
        site: "LC",
        model: service.postDio('${service.pollApi}read',
            {'skip': 0, 'limit': _limit, 'username': widget.userData.username}),
        titleHome: widget.title,
        url: '${service.pollApi}read',
        urlGallery: service.pollGalleryApi,
        callBack: () => {_onLoading()},
        title: '',
        urlComment: '',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _animationSearchController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    // _controller.addListener(_scrollListener);
    super.initState();

    poll = new PollListVerticalV3(
      // poll = new PollListVertical(

      site: "LC",
      model: service.postDio('${service.pollApi}read',
          {'skip': 0, 'limit': _limit, 'username': widget.userData.username}),
      url: '${service.pollApi}read',
      urlGallery: service.pollGalleryApi,
      titleHome: widget.title,
      // callBack: () => {
      //   // _onLoading()
      //   null
      // }, 
      title: '', urlComment: '',
    );
  }

  goBack() async {
    Navigator.pop(context);
    // Navigator.of(context).popUntil((route) => route.isFirst);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => MenuV2(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: headerV3(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: Column(
            children: [
              SizedBox(height: 5),
              tabCategory(),
              SizedBox(height: 5),
              // KeySearch(
              //   show: hideSearch,
              //   onKeySearchChange: (String val) {
              //     // pollList(context, service.post('${service.pollApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
              //     setState(
              //       () => {
              //         _searchController.text = val,
              //         poll = new PollListVerticalV3(
              //           site: 'LC',
              //           model: service.postDio('${service.pollApi}read', {
              //             'skip': 0,
              //             'limit': _limit,
              //             "keySearch": _searchController.text,
              //             'category': category,
              //             'username': widget.userData.username
              //           }),
              //           url: '${service.pollApi}read',
              //           urlGallery: '${service.pollGalleryApi}',
              //           callBack: () => {_onLoading()},
              //         )
              //       },
              //     );
              //   },
              // ),
              // SizedBox(height: 10),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: ClassicFooter(
                    loadingText: ' ',
                    canLoadingText: ' ',
                    idleText: ' ',
                    idleIcon: Icon(
                      Icons.arrow_upward,
                      color: Colors.transparent,
                    ),
                  ),
                  controller: _refreshController,
                  onLoading: _onLoading,
                  child: ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      poll,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  tabCategory() {
    return SizedBox(
      // height: 25,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  poll = new PollListVerticalV3(
                    site: 'LC',
                    model: service.postDio('${service.pollApi}read', {
                      'skip': 0,
                      'limit': _limit,
                      'category': category,
                      'username': widget.userData.username
                    }),
                    url: '${service.pollApi}read',
                    urlGallery: '${service.pollGalleryApi}',
                    callBack: () => {_onLoading()},
                    title: '',
                    urlComment: '',
                    titleHome: '',
                  );
                }
              });
            },
            child: AnimatedContainer(
              height: 25,
              width: _showSearch ? MediaQuery.of(context).size.width * 0.7 : 25,
              duration: _animationSearchController.duration ??
                  const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0x408AD2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _showSearch
                  ? TextFormField(
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        // setState(() {
                        //   _isSearch = true;
                        //   _showSearch = false;
                        //   _limit = 0;
                        // });
                        // _onLoading();
                        setState(() {
                          poll = new PollListVerticalV3(
                            site: 'LC',
                            model: service.postDio('${service.pollApi}read', {
                              'skip': 0,
                              'limit': _limit,
                              "keySearch": _searchController.text,
                              'category': category,
                              'username': widget.userData.username
                            }),
                            url: '${service.pollApi}read',
                            urlGallery: '${service.pollGalleryApi}',
                            callBack: () => {_onLoading()}, title: '', urlComment: '', titleHome: '',
                          );
                        });
                      },
                      style: const TextStyle(
                        color: Color(0xFF2D9CED),
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                        fontSize: 15.0,
                      ),
                      decoration: _decorationSearch(
                        context,
                        hintText: 'ค้นหา',
                      ),
                      validator: (model) {
                        if (model!.isEmpty) {
                          return 'กรุณากรอกวันเดือนปีเกิด.';
                        }
                        return null;
                      },
                    )
                  : Image.asset(
                      'assets/images/search.png',
                      color: Color(0x802D9CED),
                      height: 15,
                      width: 15,
                    ),
            ),
          ),
          Expanded(
            child: FutureBuilder<dynamic>(
              //   model: service.postDioCategory(
              //     '${service.pollCategoryApi}read',
              //     {'skip': 0, 'limit': 100},
              //   ),
              future: postDioCategory(
                '${service.pollCategoryApi}read',
                {'skip': 0, 'limit': 100},
              ), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                // AsyncSnapshot<Your object type>

                if (snapshot.hasData) {
                  return Container(
                    height: 45.0,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            if (snapshot.data[index]['code'] != '') {
                              setState(() {
                                _searchController.text = '';
                                isMain = false;
                                isHighlight = false;
                                categorySelected = snapshot.data[index]['code'];
                              });
                            } else {
                              setState(() {
                                isHighlight = true;
                                categorySelected = '';
                                isMain = true;
                              });
                            }
                            setState(() {
                              categorySelected = snapshot.data[index]['code'];
                              poll = new PollListVerticalV3(
                                site: 'LC',
                                model:
                                    service.postDio('${service.pollApi}read', {
                                  'skip': 0,
                                  'limit': _limit,
                                  'category': categorySelected,
                                  'username': widget.userData.username
                                }),
                                url: '${service.pollApi}read',
                                urlGallery: '${service.pollGalleryApi}',
                                callBack: () => {_onLoading()}, title: '', urlComment: '', titleHome: '',
                              );

                              // selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 10.0,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.5)),
                                color: categorySelected ==
                                        snapshot.data[index]['code']
                                    ? Color(0xFF2D9CED)
                                    : Color(0xFF8AD2FF).withOpacity(.15),
                              ),
                              child: Text(
                                snapshot.data[index]['title'],
                                style: TextStyle(
                                  color: categorySelected ==
                                          snapshot.data[index]['code']
                                      ? Colors.white
                                      : Color(0xFF2D9CED).withOpacity(.50),
                                  // decoration:
                                  //     categorySelected == snapshot.data[index]['code']
                                  //         ? TextDecoration.underline
                                  //         : null,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.normal,
                                  letterSpacing: 1,
                                  fontFamily: 'Kanit',
                                ),
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
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: new BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decorationSearch(context, {String hintText = ''}) =>
      InputDecoration(
        // label: Text(hintText),
        // labelStyle: const TextStyle(
        //   color: Color(0xFF707070),
        //   fontSize: 12,
        // ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.transparent,
        prefixIcon: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() {
              _isSearch = true;
              _showSearch = false;
              _limit = 0;
            });
            _onLoading();
          },
          child: Container(
            padding: EdgeInsets.all(3),
            child: Image.asset(
              'assets/images/search.png',
              color: Color(0x802D9CED),
            ),
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              if (_searchController.text == '') {
                _isSearch = false;
                _showSearch = false;
              } else {
                _searchController = TextEditingController(text: '');
              }
            });
          },
          child: Container(
            padding: EdgeInsets.all(3),
            child: _searchController.text == ''
                ? Icon(
                    Icons.arrow_back,
                    color: Color(0xFF2D9CED),
                    size: 16,
                  )
                : Image.asset(
                    'assets/images/close_noti_list.png',
                    color: Color(0x802D9CED),
                  ),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(6.0, 1.0, 1.0, 1.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );
}
