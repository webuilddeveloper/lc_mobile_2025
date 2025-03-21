import 'package:flutter/material.dart';
import 'package:lc/component/header.dart';
import 'package:lc/component/key_search.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/pages/contact/contact_list_vertical.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactList extends StatefulWidget {
  ContactList({
    Key? key,
    required this.title,
    required this.code,
  }) : super(key: key);

  final String title;
  final String code;

  @override
  _ContactList createState() => _ContactList();
}

class _ContactList extends State<ContactList> {
  late ContactListVertical contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<dynamic> _futureContact;

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _controller.addListener(_scrollListener);
    _futureContact = postDio('${contactApi}read',
        {'skip': 0, 'limit': _limit, 'category': widget.code});

    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      _futureContact = postDio('${contactApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': widget.code,
        'keySearch': keySearch
      });

      contact = new ContactListVertical(
        site: "LC",
        model: _futureContact,
        title: "",
        url: '${contactApi}read',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

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
        backgroundColor: Colors.white,
        appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: Column(
            children: [
              SizedBox(height: 10),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      keySearch = val;
                      _futureContact = postDio('${contactApi}read', {
                        'skip': 0,
                        'limit': _limit,
                        'category': widget.code,
                        'keySearch': keySearch
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              Expanded(
                child: SmartRefresher(
                  enablePullDown: false,
                  enablePullUp: true,
                  footer: ClassicFooter(
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
                  child: ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    // controller: _controller,
                    children: [
                      ContactListVertical(
                        site: "LC",
                        model: _futureContact,
                        title: "",
                        url: '${contactApi}read',
                      ),
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
}
