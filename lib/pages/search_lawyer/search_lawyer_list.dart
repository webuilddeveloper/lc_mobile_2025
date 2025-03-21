import 'package:flutter/material.dart';
import 'package:lc/pages/search_lawyer/search_lawyer_list_vertical.dart';
import 'package:lc/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchLawyerList extends StatefulWidget {
  const SearchLawyerList({super.key, this.keySearch, this.lcCategory = false});

  final String? keySearch;
  final bool lcCategory;

  @override
  // ignore: library_private_types_in_public_api
  _SearchLawyerList createState() => _SearchLawyerList();
}

class _SearchLawyerList extends State<SearchLawyerList> {
  _SearchLawyerList();

  late SearchLawyerListVertical lawyer;
  late bool hideSearch = true;
  bool isNull = false;
  late final txtDescription = TextEditingController();
  late String keySearch;
  late String firstName;
  late String lastName;
  late int _limit = 10;
  late String idcard;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    txtDescription.text = widget.keySearch!;
    keySearch = widget.keySearch ?? '';
    idcard = widget.keySearch ?? '';
    super.initState();
    _callRead();
  }

  _callRead() {
    if (widget.keySearch != null && widget.keySearch != '') {
      setState(
        () {
          keySearch = idcard;
          lawyer = SearchLawyerListVertical(
            model: service.postDio('${service.lawyerApi}read',
                {"idcard": idcard, 'limit': _limit}),
            lcCategory: widget.lcCategory,
          );
        },
      );
    }
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      if (isNull != true) {
        _callRead();
      }
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
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
        backgroundColor: const Color(0xFFf2f1f3),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0XFFF7F7F7),
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
                const Expanded(
                  child: Text(
                    'ตรวจสอบรายชื่อทนายความ',
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
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              // SizedBox(height: 5),
              // KeySearch(
              //   initialValue: txtDescription.text,
              //   show: hideSearch,
              //   onKeySearchChange: (String val) {
              //     _checkName(val);
              //   },
              // ),
              const SizedBox(height: 10),
              widget.keySearch == null || widget.keySearch == ''
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          'ข้อมูลสำหรับสมาชิก\nสภาทนายความ\nกรุณายืนยันตัวตน',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : Expanded(
                      child: SmartRefresher(
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
                        child: lawyer,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }


  _checkIDCard(String value) {
    if (value == '' || value == null) {
      idcard = '-';
      isNull = true;
    } else {
      idcard = value;
      isNull = false;
    }
    if (isNull != true) {
      _callRead();
    }
  }
}
