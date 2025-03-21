import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

class CremationHistoryForm extends StatefulWidget {
  const CremationHistoryForm({Key? key, @required this.title, this.model})
      : super(key: key);

  final title;
  final dynamic model;

  @override
  State<CremationHistoryForm> createState() => _CremationHistoryFormState();
}

class _CremationHistoryFormState extends State<CremationHistoryForm>
    with TickerProviderStateMixin {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureModelReceipt;
  Random random = new Random();

  String selectedType = '0';

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
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
                    widget.title,
                    style: TextStyle(
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
            SizedBox(height: 25),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedType = '0';
                              });
                            },
                            child: Container(
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectedType == '0'
                                    ? Color(0xFF2D9CED)
                                    : Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'ประวัติการโอน',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decorationColor: selectedType == '0'
                                      ? Color(0xFF2D9CED)
                                      : Colors.transparent,
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedType = '1';
                              });
                            },
                            child: Container(
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectedType == '1'
                                    ? Color(0xFF2D9CED)
                                    : Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'ใบเสร็จที่ชำระแล้ว',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Kanit',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  decorationColor: selectedType == '1'
                                      ? Color(0xFF2D9CED)
                                      : Colors.transparent,
                                  decorationThickness: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SmartRefresher(
                enablePullDown: false,
                enablePullUp: true,
                footer: ClassicFooter(
                  loadingText: ' ',
                  canLoadingText: ' ',
                  idleText: ' ',
                  idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
                ),
                controller: _refreshController,
                onLoading: _onLoading,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    selectedType == '0' ? _buildHistory() : _buildReceipt()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return FutureBuilder<dynamic>(
      future: _futureModel,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('ไม่พบข้อมูล'),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              itemCount: snapshot.data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (_, __) =>
                  _buildItemHistory(snapshot.data.toList()[__]),
            );
          }
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
            ),
            child: CircularProgressIndicator(
              color: Color(0xFFED6B2D),
            ),
          );
        }
      },
    );
  }

  Widget _buildItemHistory(dynamic model) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 100,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['title']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF052598),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 15),
                        Text(
                          '${model['createDate']}' != null
                              ? dateStringToDate('${model['createDate']}')
                              : '',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  '${model['payPrice']} บาท',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF052598),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Expanded(
              child: Divider(
                color: Color(0xFFDDDDDD),
                height: 2,
                thickness: 2,
              ),
            ),
          ],
        ));
  }

  Widget _buildReceipt() {
    return FutureBuilder<dynamic>(
      future: _futureModelReceipt,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text('ไม่พบข้อมูล'),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              itemCount: snapshot.data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (_, __) =>
                  _buildItemReceipt(snapshot.data.toList()[__]),
            );
          }
        } else if (snapshot.hasError) {
          return Container();
        } else {
          // return Container(
          //   alignment: Alignment.center,
          //   padding: EdgeInsets.only(top: 50),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.4),
          //     borderRadius: BorderRadius.circular(15),
          //   ),
          //   child: CircularProgressIndicator(
          //     color: Color(0xFFED6B2D),
          //   ),
          // );
          return Container();
        }
      },
    );
  }

  Widget _buildItemReceipt(dynamic model) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 100,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ใบเสร็จที่ชำระเสร็จสิ้น',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF052598),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 15),
                        Text(
                          '${model['createDate']}' != null
                              ? dateStringToDate('${model['createDate']}')
                              : '',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${model['payPrice']} บาท',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF052598),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: InkWell(
                            onTap: () => _downloadQR(model['imageUrl']),
                            child: Text(
                              'ดาวน์โหลดใบเสร็จ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF052598),
                                decoration: TextDecoration.underline,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Divider(
                color: Color(0xFFDDDDDD),
                height: 2,
                thickness: 2,
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _futureModel = postDio(server + 'cremation/payhistory/read', {
        'skip': 0,
        'limit': 99,
        'cremation_no': widget.model['cremation_no'].toString(),
      });
      _futureModelReceipt = postDio(server + 'cremation/receipt/read', {
        'skip': 0,
        'limit': 100,
        'cremation_no': widget.model['cremation_no'].toString(),
      });
    });
    await Future.delayed(Duration(milliseconds: 2000));

    _refreshController.loadComplete();
  }

  _callRead() async {
    _futureModel = postDio(server + 'cremation/payhistory/read', {
      'skip': 0,
      'limit': 99,
      'cremation_no': widget.model['cremation_no'].toString(),
    });
    _futureModelReceipt = postDio(server + 'cremation/receipt/read', {
      'skip': 0,
      'limit': 100,
      'cremation_no': widget.model['cremation_no'].toString(),
    });
  }

  _downloadQR(String imageurl) async {
    var _url = imageurl;

    // Download image
    final http.Response response = await http.get(Uri.parse(_url));

    // Get temporary directory
    final dir = await getApplicationDocumentsDirectory();

    // Create an image name
    var filename = '${dir.path}/_receipt${random.nextInt(100)}.png';

    // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(response.bodyBytes);

    // Ask the user to save it
    final params = SaveFileDialogParams(sourceFilePath: file.path);
    final finalPath = await FlutterFileDialog.saveFile(params: params);

    if (finalPath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ดาวน์โหลดใบเสร็จเรียบร้อย'),
        ),
      );
    }
  }
}
