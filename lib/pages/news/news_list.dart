import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lc/component/loadingImageNetwork.dart';
import 'package:lc/pages/news/news_form.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:lc/v4/widget/header_v4.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class NewsList extends StatefulWidget {
  const NewsList({super.key, @required this.title});

  // ignore: prefer_typing_uninitialized_variables
  final title;

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> with TickerProviderStateMixin {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureModelHighlight;
  late Future<dynamic> _futureCategory;
  final String _keySearch = '';
  String _category = '';
  int _limit = 10;
  int _carouselNewsIndex = 0;
  bool _showSearch = false;
  bool _isSearch = false;
  late AnimationController _animationSearchController;
  TextEditingController _searchController = TextEditingController();
  String sortNews = "new";

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          _showSearch = false;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: headerV4(context, () => {
          Navigator.pop(context,false),
        }, title: 'ข่าวประชาสัมพันธ์'),
        
        body: Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            children: [
              _buildCategory(),
              const SizedBox(height: 10),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: const ClassicFooter(
                    loadingText: ' ',
                    canLoadingText: ' ',
                    idleText: ' ',
                    idleIcon:
                        Icon(Icons.arrow_upward, color: Colors.transparent),
                  ),
                  controller: _refreshController,
                  onLoading: _onLoading,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      if ((_category == '') && !_isSearch) _buildHighlight(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildNews(),
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

  Widget _buildCategory() {
    return Column(
      children: [
        SizedBox(
          height: 35,
          child: TextFormField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _isSearch = true;
                _showSearch = false;
                _limit = 0;
              });
              _onLoading();
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
              filter: true,
              onTapFilter: () {
                showFilterModal();
              },
            ),
            validator: (model) {
              if (model!.isEmpty) {
                return 'กรุณากรอกวันเดือนปีเกิด.';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: FutureBuilder(
            future: _futureCategory,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                  padding: const EdgeInsets.only(right: 15),
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) =>
                      // ignore: no_wildcard_variable_uses
                      _buildItemCategory(snapshot.data[__]),
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemCount: snapshot.data.length,
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemCategory(dynamic model) {
    bool thisCatgory = _category == (model['code'] ?? '');
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSearch = false;
          _category = model['code'];
          _limit = 0;
        });
        _onLoading();
      },
      child: Container(
        height: 25,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color:
              thisCatgory ? const Color(0xFF2D9CED) : const Color(0x268AD2FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${model['title']}',
          style: TextStyle(
            fontSize: 13,
            color: thisCatgory ? Colors.white : const Color(0x802D9CED),
            fontWeight: thisCatgory ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildHighlight() {
    return FutureBuilder(
      future: _futureModelHighlight,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                // height: MediaQuery.of(context).size.width - 30 + 37,
                height: MediaQuery.of(context).size.width - 250,
                width: double.infinity,
                child: CarouselSlider(
                  items: snapshot.data
                      .map<Widget>((e) => _buildHighlightItemNews(e))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 1,
                    viewportFraction: 1,
                    onPageChanged: (i, value) {
                      setState(() {
                        _carouselNewsIndex = i;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: snapshot.data.map<Widget>(
                    (e) {
                      int index = snapshot.data.indexOf(e);
                      bool thisCarousel = _carouselNewsIndex == index;
                      return Container(
                        width: thisCarousel ? 17.5 : 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: thisCarousel
                              ? const Color(0xFF8AD2FF)
                              : Colors.white,
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFF8AD2FF),
                          ),
                          borderRadius: BorderRadius.circular(3.5),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildHighlightItemNews(dynamic model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsForm(
              code: model['code'],
              model: model,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0x268AD2FF),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: loadingImageNetwork(
                model['imageUrl'],
                height: MediaQuery.of(context).size.width - 30,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 15,
            right: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 88,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: const Color(0x99FFFFFF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child:
                    // BackdropFilter(
                    //   filter: ImageFilter.blur(
                    //     sigmaX: 5.0,
                    //     sigmaY: 5.0,
                    //   ),
                    //   child:
                    Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${model['createDate']}' != null
                              ? dateStringToDate('${model['createDate']}')
                              : '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),

                // ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Icon(
              Icons.bookmark,
              size: 25,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNews() {
    return FutureBuilder<dynamic>(
      future: _futureModel,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return const Center(
              child: Text('ไม่พบข้อมูล'),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 15,
              //   vertical: 10,
              // ),
              itemCount: snapshot.data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (_, __) =>
                  // ignore: no_wildcard_variable_uses
                  _buildItemNews(snapshot.data.toList()[__]),
            );
          }
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildItemNews(dynamic model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsForm(
              code: model['code'],
              model: model,
            ),
          ),
        );
      },
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.black.withOpacity(0.20),
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: loadingImageNetwork(model['imageUrl'],
                  height: 100, width: 90, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model['title']}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 14,
                          color: Color(0xFF808080),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${model['createDate']}' != null
                              ? 'วันที่ ' +
                                  dateStringToDate('${model['createDate']}')
                              : '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _decorationSearch(context,
          {String hintText = '',
          bool filter = false,
          VoidCallback? onTapFilter}) =>
      InputDecoration(
        // label: Text(hintText),
        // labelStyle: const TextStyle(
        //   color: Color(0xFF707070),
        //   fontSize: 12,
        // ),
        isDense: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF707070),
          fontSize: 12,
        ),
        filled: true,
        fillColor: Color(0xFFF2FAFF),
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
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/search.png',
              color: const Color(0x802D9CED),
              height: 20,
              width: 20,
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
              padding: const EdgeInsets.all(0),
              child: filter
                  ? GestureDetector(
                      onTap: onTapFilter,
                      child: const Icon(
                        Icons.tune,
                        color: Color(0xFF2D9CED),
                        size: 20,
                      ),
                    )
                  : SizedBox()),
        ),
        contentPadding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  showFilterModal() {
    return showCupertinoModalBottomSheet(
        context: context,
        barrierColor: Color(0xFF04446C).withOpacity(0.5),
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadow: BoxShadow(
          blurRadius: 6,
          offset: Offset(0.75, 0),
          blurStyle: BlurStyle.normal,
          color: Colors.grey.withOpacity(0.4),
        ),
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: new Container(
              height: 250,
              width: double.infinity,
              margin: EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(29),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: Offset(0.75, 0),
                      color: Colors.grey.withOpacity(0.4),
                    )
                  ]),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'เรียงลำดับจาก',
                            style: TextStyle(
                                fontSize: 20, color: Color(0xFF011895)),
                          ),
                        ),
                        SizedBox(height: 37),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "ใหม่สุด",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Radio(
                                  value: "new",
                                  groupValue: sortNews,
                                  onChanged: (value) {
                                    setState(() {
                                      sortNews = value!;
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            ),
                            Divider(
                              color: Color(0xFFD9D9D9),
                            ),
                            Row(
                              children: [
                                Text(
                                  "เก่าสุด",
                                  style: TextStyle(fontSize: 12),
                                ),
                                Radio(
                                  value: "old",
                                  groupValue: sortNews,
                                  onChanged: (value) {
                                    setState(() {
                                      sortNews = value!;
                                      Navigator.pop(context);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2D9CED),
                        ),
                        child: Icon(
                          Icons.clear,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    _animationSearchController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _futureModel = postDio('${newsApi}read', {
      'skip': 0,
      'limit': _limit,
      "category": _category,
      "keySearch": _keySearch
    });

    _futureCategory = postDioCategory(
      '${newsCategoryApi}read',
      {'skip': 0, 'limit': 100},
    );

    _futureModelHighlight = postDio('${newsApi}read', {
      'skip': 0,
      'limit': _limit,
      "isHighlight": true,
    });
    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _limit += 10;

      _futureModel = postDio('${newsApi}read', {
        'skip': 0,
        'limit': _limit,
        "category": _category,
        "keySearch": _searchController.text,
      });
      _futureModelHighlight = postDio('${newsApi}read', {
        'skip': 0,
        'limit': 10,
        "isHighlight": true,
      });
    });
    await Future.delayed(const Duration(milliseconds: 2000));

    _refreshController.loadComplete();
  }
}
