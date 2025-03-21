import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/lawyer/lawyer_candidate_information_from.dart';
import 'package:lc/pages/lawyer/lawyer_candidate_information_list_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LawyerCandidateInformationList extends StatefulWidget {
  const LawyerCandidateInformationList({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LawyerCandidateInformationList createState() =>
      _LawyerCandidateInformationList();
}

class _LawyerCandidateInformationList
    extends State<LawyerCandidateInformationList> {
  int _limit2 = 12;
  String selectedType = '0';
  late Future<dynamic> futureModel;
  late Future<dynamic> futureModel2;

  final storage = const FlutterSecureStorage();
  final RefreshController _refreshController2 =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  void _onLoading2() async {
    setState(() {
      _limit2 = _limit2 + 12;
      futureModel2 = postDio(employeeElectionLcApi, {
        'category': '20220726164102-319-178',
        'skip': 0,
        'limit': _limit2,
      });
    });

    // await Future.delayed(Duration(milliseconds: 1000));

    _refreshController2.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  void initState() {
    futureModel =
        postDio(employeeElectionLcApi, {'category': '20220726164051-787-883'});
    futureModel2 = postDio(employeeElectionLcApi, {
      'category': '20220726164102-319-178',
      'skip': 0,
      'limit': _limit2,
    });
    // _controller.addListener(_scrollListener);
    super.initState();
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
        backgroundColor: const Color(0xFFF7F7F7),
        body: Column(
          children: [
            InkWell(
              onTap: () => goBack(),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 20,
                  left: 15,
                  right: 15,
                  // bottom: 20,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo/icons/backLeft.png',
                      height: 25,
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      'ข้อมูลผู้สมัคร',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500,
                      ),
                      // maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(5),
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
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedType == '0'
                                    ? const Color(0xFF011895)
                                    : const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'ผู้สมัครนายก',
                                style: TextStyle(
                                  color: selectedType == '0'
                                      ? const Color(0xFFFFFFFF)
                                      : const Color(0x80707070),
                                  fontFamily: 'Kanit',
                                  fontSize: 20,
                                  fontWeight: selectedType == '0'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedType == '1'
                                    ? const Color(0xFF011895)
                                    : const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'ผู้สมัครกรรมการ',
                                style: TextStyle(
                                  color: selectedType == '1'
                                      ? const Color(0xFFFFFFFF)
                                      : const Color(0x80707070),
                                  fontFamily: 'Kanit',
                                  fontSize: 20,
                                  fontWeight: selectedType == '1'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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
            _card(),
          ],
        ),
      ),
    );
  }

  _card() {
    return Expanded(child: selectedType == '0' ? _tap1() : _tap2());
  }

  _tap1() {
    return FutureBuilder<dynamic>(
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // data from refresh api
        if (snapshot.hasData) {
          return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true, // use it
              physics: const ClampingScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return myCardPrimeCandidate(snapshot.data[index], context);
              });
        } else if (snapshot.hasError) {
          return const BlankLoading();
        } else {
          return const BlankLoading();
        }
      },
    );
  }

  myCardPrimeCandidate(dynamic model, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LawyerCandidateInformationFrom(
              code: model['code'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                model['imageUrl'],
                height: 345,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${model['numberCandidate']}',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Color(0xFF2D9CED),
                      fontFamily: 'Kanit',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${model['prefixName']} ${model['firstName']} ${model['lastName']}',
                    style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tap2() {
    return FutureBuilder<dynamic>(
      future: futureModel2, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // data from refresh api
        if (snapshot.hasData) {
          return SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            footer: const ClassicFooter(
              loadingText: ' ',
              canLoadingText: ' ',
              idleText: ' ',
              idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
            ),
            controller: _refreshController2,
            onLoading: _onLoading2,
            child: LawyerCandidateInformationListVertical(
              model: snapshot.data,
            ),
          );
        } else if (snapshot.hasError) {
          return const BlankLoading();
        } else {
          return const BlankLoading();
        }
      },
    );
  }
}
