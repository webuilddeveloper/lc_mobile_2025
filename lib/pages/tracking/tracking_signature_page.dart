import 'package:flutter/material.dart';
import 'package:lc/shared/api_provider.dart';

class TrackingSignaturePage extends StatefulWidget {
  const TrackingSignaturePage({Key? key}) : super(key: key);

  @override
  State<TrackingSignaturePage> createState() => _TrackingSignaturePageState();
}

class _TrackingSignaturePageState extends State<TrackingSignaturePage> {
  late TextEditingController _searchController;
  late Future<dynamic> _futureModel;
  List<dynamic> _model = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
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
                      color: Color(0x408AD2FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xFF2D9CED),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'ติดตามสถานะ ทนายความรับรองลายมือชื่อ',
                    style: TextStyle(
                        // fontSize: 20,
                        // fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'รายการ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2D9CED),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<dynamic>(
                  future: _futureModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        padding: EdgeInsets.only(top: 15, bottom: 30),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(dynamic model) {
    return GestureDetector(
      onTap: () => {},
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => ContactPage(
      //       title: '',
      //       category: model['code'],
      //     ),
      //   ),
      // ),
      child: Container(
        height: 80,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // _buildImage([], model['paymentImageUrl']),

            Image.asset('assets/images/img_menu.png'),
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
                    'สถานะ ${model['status'] == 'N' ? 'รอตรวจสอบ' : model['status'] == 'R' ? 'ไม่สำเร็จต้องการข้อมูลเพิ่มเติม' : 'เสร็จสิ้น'}',
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
            // Text(
            //   '${model['total'] ?? ''}',
            //   style: TextStyle(
            //     fontSize: 13,
            //     fontWeight: FontWeight.w400,
            //     color: Color(0xFF707070),
            //   ),
            //   overflow: TextOverflow.ellipsis,
            //   maxLines: 1,
            // ),
            // Icon(
            //   Icons.arrow_forward_ios_rounded,
            //   color: Color(0xFF707070),
            //   size: 16,
            // )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _searchController = TextEditingController(text: '');
    _callRead();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _callRead() async {
    setState(() async {
      // เรียก API ทั้งหมด
      var results = await Future.wait([
        postDio(trackingReadApi, {}),
        postDio(tracking2ReadApi, {}),
        postDio(tracking3ReadApi, {}),
        postDio(tracking4ReadApi, {}),
      ]);

      for (int i = 0; i < results.length; i++) {
        if (results[i] is List) {
          for (var item in results[i]) {
            _model.add({
              'code': item['code'] ?? '',
              'profileCode': item['profileCode'] ?? '',
              'status': item['status'] ?? '',
              'title': 'ทรบ. ${i + 1}' // ใช้ index เพื่อกำหนด title
            });
          }
        }
      }

      setState(() {
        _futureModel = Future.value(_model);
      });
    });
  }
}
