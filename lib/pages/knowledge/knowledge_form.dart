import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lc/component/link_url_in.dart';
import 'dart:async';
import 'package:lc/shared/api_provider.dart';
import 'package:flutter/services.dart';

class KnowledgeForm extends StatefulWidget {
  const KnowledgeForm({
    super.key,
    required this.code,
    this.model,
  });
  final String code;
  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _KnowledgeDetailPageState createState() =>
      // ignore: no_logic_in_create_state
      _KnowledgeDetailPageState(code: code);
}

class _KnowledgeDetailPageState extends State<KnowledgeForm> {
  _KnowledgeDetailPageState({required this.code});

  late Future<dynamic> _futureModel;
  String code;

  @override
  void initState() {
    super.initState();
    _futureModel = postDio(
      '${knowledgeApi}read',
      {'skip': 0, 'limit': 1, 'code': widget.code},
    );
  }

  sendReportCategory(String category) {
    postCategory(
      '${knowledgeCategoryApi}read',
      {'skip': 0, 'limit': 1, 'code': category},
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: FutureBuilder<dynamic>(
          future: _futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              sendReportCategory(snapshot.data[0]['category']);
              return myContent(
                snapshot.data[0],
              );
            } else {
              return noContent();
            }
          },
        ),
      ),
    );
  }

  Widget myContent(dynamic model) {
    return SingleChildScrollView(
      child: ListView(
        padding: const EdgeInsets.only(right: 15, left: 15, top: 30),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          _buildHeader(),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                height: 429,
                child: Image.asset(
                  'assets/images/bg_knowledge_form.png',
                  height: 273,
                  width: 273,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      model['imageUrl'],
                      height: 220,
                      width: 165,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 18),
                  InkWell(
                    onTap: () =>
                        launchInWebViewWithJavaScript(model['fileUrl']),
                    child: Container(
                      height: 40,
                      width: 170,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D9CED),
                        borderRadius: BorderRadius.circular(73),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'ดาวน์โหลด',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    model['title'],
                    style: const TextStyle(
                      fontSize: 17,
                      color: Color(0xFF000000),
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  model['description'] != ''
                      ? const Row(
                          children: [
                            Text(
                              'รายละเอียด',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xFF000000),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      : Container(),
                  model['description'] != ''
                      ? Html(
                          data: model['description'],
                          onLinkTap: (String? url,
                              Map<String, String> attributes, element) {
                            launchInWebViewWithJavaScript(url!);
                            //open URL in webview, or launch URL in browser, or any other logic here
                          },
                        )
                      : Container(),
                  const Row(
                    children: [
                      Text(
                        'ข้อมูล',
                        style: TextStyle(
                            fontSize: 17,
                            color: Color(0xFF000000),
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  model['author'] != ''
                      ? _buildTextDetail(
                          'ผู้แต่ง',
                          '${model['author']}',
                        )
                      : Container(),
                  model['publisher'] != ''
                      ? _buildTextDetail(
                          'สำนักพิมพ์',
                          '${model['publisher']}',
                        )
                      : Container(),
                  model['categoryList'][0]['title'] != ''
                      ? _buildTextDetail(
                          'หมวดหมู่',
                          '${model['categoryList'][0]['title']}',
                        )
                      : Container(),
                  model['bookType'] != ''
                      ? _buildTextDetail(
                          'ประเภทหนังสือ',
                          '${model['bookType']}',
                        )
                      : Container(),
                  model['numberOfPages'] != ''
                      ? _buildTextDetail(
                          'จำนวนหน้า',
                          model['numberOfPages'].toString(),
                        )
                      : Container(),
                  model['size'] != ''
                      ? _buildTextDetail(
                          'ขนาด',
                          model['size'].toString(),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget noContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            const SizedBox(height: 35),
            InkWell(
              onTap: () => {
                Navigator.pop(context),
              },
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/rectangle_knowledge_form.png",
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 15),
                Container(
                  height: 220,
                  width: 165,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFFD9D9D9),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 45,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.5),
                    color: const Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  height: 20,
                  width: 292,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.5),
                    color: const Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 20,
                  width: 105,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.5),
                    color: const Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.5),
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Container(
                  height: 15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.5),
                    color: const Color(0xFF707070),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.5),
                    color: const Color(0xFF707070),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.5),
                    color: const Color(0xFF707070),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Container(
                      height: 20,
                      width: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.5),
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                Container(
                  height: 15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.5),
                    color: const Color(0xFF707070),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.5),
                    color: const Color(0xFF707070),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.5),
                    color: const Color(0xFF707070),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextDetail(String title, String value) {
    return Row(
      children: [
        Container(
          width: 100,
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF707070),
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF707070),
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          onTap: () => {
            Navigator.pop(context),
          },
          child: Image.asset(
            "assets/images/back_arrow_v2.png",
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
  //
}
