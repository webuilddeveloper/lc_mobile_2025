import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lc/pages/knowledge/knowledge_form.dart';
import 'package:lc/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class KnowledgeList extends StatefulWidget {
  const KnowledgeList({super.key, required this.title});
  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _KnowledgeList createState() => _KnowledgeList();
}

class _KnowledgeList extends State<KnowledgeList>
    with TickerProviderStateMixin {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureCategory;
  String _category = '';
  int _limit = 10;
  final bool _showSearch = true; //false;
  late AnimationController _animationSearchController;
  TextEditingController _searchController = TextEditingController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   FocusScope.of(context).unfocus();
      //   setState(() {
      //     _showSearch = false;
      //   });
      // },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
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
                const SizedBox(width: 30),
              ],
            ),
          ),
        ),
        body: Column(
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
                  idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
                ),
                controller: _refreshController,
                onLoading: _onLoading,
                child: _buildKnowledge(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory() {
    return SizedBox(
      height: 25,
      width: double.infinity,
      child: FutureBuilder(
        future: _futureCategory,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.only(right: 15, left: 15),
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              // ignore: no_wildcard_variable_uses
              itemBuilder: (_, __) => _buildItemCategory(snapshot.data[__]),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: snapshot.data.length,
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildItemCategory(dynamic model) {
    bool thisCatgory = _category == (model['code'] ?? '');
    return GestureDetector(
      onTap: () {
        setState(() {
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
          borderRadius: BorderRadius.circular(12.5),
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

  Widget _buildKnowledge() {
    return FutureBuilder<dynamic>(
      future: _futureModel,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Column(
              children: [
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: AnimatedContainer(
                      height: 25,
                      duration: _animationSearchController.duration ??
                          const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0x408AD2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _showSearch
                          ? TextFormField(
                              controller: _searchController,
                              keyboardType: TextInputType.text,
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  // _showSearch = false;
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
                              color: const Color(0x802D9CED),
                              height: 15,
                              width: 15,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Expanded(
                  child: Center(
                    child: Text('ไม่พบข้อมูล'),
                  ),
                ),
              ],
            );
          } else {
            return MasonryGridView.count(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              itemCount: snapshot.data.length,
              itemBuilder: (_, __) {
                // ignore: no_wildcard_variable_uses
                if (__ == 1) {
                  return Column(
                    children: [
                      GestureDetector(
                        child: AnimatedContainer(
                          height: 25,
                          width: _showSearch
                              ? MediaQuery.of(context).size.width * 0.7
                              : 25,
                          duration: _animationSearchController.duration ??
                              const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0x408AD2FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _showSearch
                              ? TextFormField(
                                  controller: _searchController,
                                  keyboardType: TextInputType.text,
                                  onEditingComplete: () {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      // _showSearch = false;
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
                                  color: const Color(0x802D9CED),
                                  height: 15,
                                  width: 15,
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KnowledgeForm(
                                // ignore: no_wildcard_variable_uses
                                code: snapshot.data.toList()[__]['code'],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            // ignore: no_wildcard_variable_uses
                            snapshot.data.toList()[__]['imageUrl'],
                            height: 220,
                            width: 165,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KnowledgeForm(
                            // ignore: no_wildcard_variable_uses
                            code: snapshot.data.toList()[__]['code'],
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        // ignore: no_wildcard_variable_uses
                        snapshot.data.toList()[__]['imageUrl'],
                        height: 220,
                        width: 165,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                }
              },
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

  InputDecoration _decorationSearch(context, {String hintText = ''}) =>
      InputDecoration(
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
              // _showSearch = false;
              _limit = 0;
            });
            _onLoading();
          },
          child: Container(
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              'assets/images/search.png',
              color: const Color(0x802D9CED),
            ),
          ),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _searchController = TextEditingController(text: '');
              _limit = 0;
            });
            _onLoading();
          },
          child: Container(
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              'assets/images/close_noti_list.png',
              color: const Color(0x802D9CED),
            ),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(6.0, 1.0, 1.0, 1.0),
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

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _animationSearchController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _futureModel = service.postDio(
      '${service.knowledgeApi}read',
      {
        'skip': 0,
        'limit': _limit,
      },
    );

    _futureCategory = service.postCategory(
      '${service.knowledgeCategoryApi}read',
      {'skip': 0, 'limit': 100},
    );
    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _limit += 10;

      _futureModel = service.postDio('${service.knowledgeApi}read', {
        'skip': 0,
        'limit': _limit,
        "category": _category,
        "keySearch": _searchController.text,
      });
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }
}
