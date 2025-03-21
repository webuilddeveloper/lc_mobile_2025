import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lc/pages/blank_page/blank_loading.dart';
import 'package:lc/pages/lawyer/lawyer_result_of_vote_counting_list_vertical.dart';
import 'package:lc/shared/api_provider.dart';

class LawyerResultOfVoteCountingList extends StatefulWidget {
  const LawyerResultOfVoteCountingList({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LawyerResultOfVoteCountingList createState() =>
      _LawyerResultOfVoteCountingList();
}

class _LawyerResultOfVoteCountingList
    extends State<LawyerResultOfVoteCountingList> {
  String selectedType = '0';
  late Future<dynamic> futureModel;
  late Future<dynamic> futureModel2;

  final storage = const FlutterSecureStorage();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  void initState() {
    futureModel =
        postDio(employeeElectionLcApi, {'category': '20220726164051-787-883'});
    futureModel2 =
        postDio(employeeElectionLcApi, {'category': '20220726164102-319-178'});
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
                      'ผลการนับคะแนน',
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
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
            rowVote(),
            _card(),
          ],
        ),
      ),
    );
  }

  _card() {
    return Expanded(child: selectedType == '0' ? _tap1() : _tap2());
  }

  rowVote() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 15),
              child: SizedBox(
                width: 30,
                child: Text(
                  'เบอร์',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Text(
                  'ชื่อผู้สมัคร',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 15, top: 10, bottom: 10),
              child: SizedBox(
                width: 50,
                child: Text(
                  'คะแนน',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tap1() {
    return FutureBuilder<dynamic>(
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // data from refresh api
        if (snapshot.hasData) {
          snapshot.data.sort((a, b) {
            return compareIntPrefixes(
                b['scoreCandidate'].toString(), a['scoreCandidate'].toString());
          });
          return LawyerResultOfVoteCountingListVertical(
            model: snapshot.data,
            title: 'ผู้สมัครนายก',
          );
        } else if (snapshot.hasError) {
          return const BlankLoading();
        } else {
          return const BlankLoading();
        }
      },
    );
  }

  _tap2() {
    return FutureBuilder<dynamic>(
      future: futureModel2, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // data from refresh api
        if (snapshot.hasData) {
          snapshot.data.sort((a, b) {
            return compareIntPrefixes(
                b['scoreBoard'].toString(), a['scoreBoard'].toString());
          });
          return LawyerResultOfVoteCountingListVertical(
            model: snapshot.data,
            title: 'ผู้สมัครกรรมการ',
          );
        } else if (snapshot.hasError) {
          return const BlankLoading();
        } else {
          return const BlankLoading();
        }
      },
    );
  }
  //

  int? parseIntPrefix(String s) {
    var re = RegExp(r'(-?[0-9]+).*');
    var match = re.firstMatch(s);
    if (match == null) {
      return null;
    }
    return int.parse(match.group(1)!);
  }

  int compareIntPrefixes(String a, String b) {
    var aValue = parseIntPrefix(a);
    var bValue = parseIntPrefix(b);
    if (aValue != null && bValue != null) {
      return aValue - bValue;
    }

    if (aValue == null && bValue == null) {
      // If neither string has an integer prefix, sort the strings lexically.
      return a.compareTo(b);
    }

    // Sort strings with integer prefixes before strings without.
    if (aValue == null) {
      return 1;
    } else {
      return -1;
    }
  }
}
