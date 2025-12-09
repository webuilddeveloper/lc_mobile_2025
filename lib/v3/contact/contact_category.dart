import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lc/component/loading_tween.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/v3/contact/contact.dart';
import 'package:lc/v4/widget/header_v4.dart';

class ContactCategoryPage extends StatefulWidget {
  const ContactCategoryPage({Key? key, this.title = ''}) : super(key: key);

  final String title;

  @override
  State<ContactCategoryPage> createState() => _ContactCategoryPageState();
}

class _ContactCategoryPageState extends State<ContactCategoryPage> {
  late TextEditingController _searchController;
  late Future<dynamic> _futureModel;
  String _categoryCode = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: headerV4(
            context,
            () => {
                  Navigator.pop(context, false),
                },
            title: 'เบอร์ติดต่อ'),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ประเภทเบอร์',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D9CED),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContactPage(
                          title: widget.title,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFF8AD2FF).withOpacity(0.25),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        'ทั้งหมด',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF2D9CED),
                          // decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: _futureModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        padding: EdgeInsets.only(top: 15),
                        itemBuilder: (_, index) =>
                            _buildItem(snapshot.data[index]),
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemCount: snapshot.data.length,
                      );
                    } else {
                      return Center(
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

  Widget _buildItem(dynamic model) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ContactPage(
            title: widget.title,
            category: model['code'],
          ),
        ),
      ),
      child: Container(
        height: 80,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(model['images'], model['imageUrl']),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D9CED),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${model['description'] ?? ''}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF707070),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Text(
              '${model['total'] ?? ''}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF707070),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF707070),
              size: 16,
            )
          ],
        ),
      ),
    );
  }

  _buildImage(List<dynamic> model, String def) {
    double height = model.length == 1 ? 60 : 29;
    double width = model.length == 1 ? 60 : 29;
    if (model.length == 2) {
      height = 60;
    }

    if (model.length == 0) {
      return Container(
        height: 60,
        width: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: CachedNetworkImage(
            imageUrl: def,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (_, __, ___) => LoadingTween(),
            errorWidget: (_, __, ___) => Container(
              color: Color(0xFFF2FAFF),
              padding: EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/metro-file-picture.png',
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      height: 60,
      width: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Wrap(
          runSpacing: 1,
          spacing: 1,
          children: model
              .asMap()
              .map((i, e) => MapEntry(
                  i,
                  CachedNetworkImage(
                    imageUrl: e,
                    height: height,
                    width: model.length == 3 ? 60 : width,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (_, __, ___) => LoadingTween(),
                    errorWidget: (_, __, ___) => Container(
                      color: Color(0xFFF2FAFF),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/metro-file-picture.png',
                      ),
                    ),
                  )))
              .values
              .toList(),
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
        fillColor: Color(0xFFF2FAFF),
        prefixIcon: Container(
          padding: EdgeInsets.all(9),
          child: Image.asset(
            'assets/images/search.png',
            color: Color(0xFF2D9CED),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(15.0, 2.0, 2.0, 2.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Color(0xFF2D9CED)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Color(0xFF2D9CED)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Color(0xFFF2FAFF)),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  @override
  void initState() {
    _searchController = TextEditingController(text: '');
    _futureModel = postDio('${contactCategoryApi}read', {});
    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _callRead() async {
    setState(() {
      _futureModel = postDio('${contactCategoryApi}read', {
        'keySearch': _searchController.text,
      });
    });
  }
}
