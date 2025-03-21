import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lc/component/loading_tween.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.category = '', this.title = ''});

  final String title;
  final String category;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late TextEditingController _searchController;
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureCategoryModel = Future.value();
  String _categoryCode = '';
  int _limit = 20;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: Container(
            width: double.infinity,
            color: Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 15,
              right: 15,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: const Color(0x408AD2FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF2D9CED),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 35,
                child: TextFormField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                    _callRead();
                  },
                  decoration: _decorationSearch(
                    context,
                    hintText: 'ค้นหาเบอร์ติดต่อ',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 25,
                width: double.infinity,
                child: FutureBuilder(
                  future: _futureCategoryModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (_, index) =>
                            _builditemCategory(snapshot.data[index]),
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemCount: snapshot.data.length,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: _futureModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return const Center(
                          child: Text(
                            'ไม่พบข้อมูล',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return SmartRefresher(
                        enablePullDown: false,
                        enablePullUp: true,
                        footer: const ClassicFooter(
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
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          itemBuilder: (_, index) =>
                              _buildItem(snapshot.data[index]),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemCount: snapshot.data.length,
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _builditemCategory(dynamic model) {
    bool thisItem = model['code'] == _categoryCode;
    return GestureDetector(
      onTap: () => setState(() {
        _categoryCode = model['code'];
        _callRead();
      }),
      child: Container(
        height: 25,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: thisItem ? const Color(0xFF2D9CED) : const Color(0x268AD2FF),
          borderRadius: BorderRadius.circular(12.5),
        ),
        child: Text(
          model['title'],
          style: TextStyle(
            color: thisItem ? Colors.white : const Color(0x802D9CED),
            fontSize: 13,
            fontWeight: thisItem ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildItem(dynamic model) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse('tel:${model['phone']}'),
          mode: LaunchMode.externalApplication),
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  width: 1,
                  color: const Color(0xFF2D9CED),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.5),
                child: CachedNetworkImage(
                  imageUrl: model['imageUrl'],
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (_, __, ___) => LoadingTween(),
                  errorWidget: (_, __, ___) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/metro-file-picture.png',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    model['phone'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D9CED),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 15,
                      color: Color(0x26707070),
                      offset: Offset(0, 0),
                    ),
                  ]),
              child: Image.asset(
                'assets/images/phone_2.png',
                height: 22.7,
                width: 22.7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static InputDecoration _decorationSearch(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(
          color: Color(0xFF2D9CED),
          fontSize: 12,
        ),
        // hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF2FAFF),
        prefixIcon: Container(
          padding: const EdgeInsets.all(9),
          child: Image.asset(
            'assets/images/search.png',
            color: const Color(0xFF2D9CED),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(15.0, 2.0, 2.0, 2.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Color(0xFF2D9CED)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Color(0xFF2D9CED)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Color(0xFFF2FAFF)),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  @override
  void initState() {
    _searchController = TextEditingController(text: '');
    _categoryCode = widget.category;
    _callReadCategory();
    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _callReadCategory() async {
    var res = await postDio('${contactCategoryApi}read', {});
    var data = [
      {'title': 'ทั้งหมด', 'code': ''},
      ...res
    ];
    setState(() {
      _futureCategoryModel = Future.value(data);
    });
  }

  void _onLoading() async {
    setState(() {
      _limit += 10;
    });
    _callRead();

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void _callRead() async {
    setState(() {
      _futureModel = postDio('${contactApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': _categoryCode,
        'keySearch': _searchController.text
      });
    });
  }
}
