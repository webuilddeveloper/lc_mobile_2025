import 'package:flutter/material.dart';
import 'package:lc/component/header.dart';
import 'package:lc/pages/reporter/reporter_history_list_vertical.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReporterHistoryList extends StatefulWidget {
  const ReporterHistoryList({super.key, required this.title, required this.username});

  final String title;
  final String username;

  @override
  // ignore: library_private_types_in_public_api
  _ReporterHistoryList createState() => _ReporterHistoryList();
}

class _ReporterHistoryList extends State<ReporterHistoryList> {
  late ReporterHistoryListVertical reporterHistory;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;

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
    // _controller.addListener(_scrollListener);
    super.initState();

    reporterHistory = ReporterHistoryListVertical(
      site: "LC",
      model: post('${reporterApi}read',
          {'skip': 0, 'limit': _limit, 'createBy': widget.username}),
      url: '${reporterApi}read',
      urlGallery: '${reporterGalleryApi}read',
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      reporterHistory = ReporterHistoryListVertical(
        site: 'LC',
        model: post('${reporterApi}read',
            {'skip': 0, 'limit': _limit, 'createBy': widget.username}),
        url: '${reporterApi}read',
        urlGallery: '${reporterGalleryApi}read',
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context);
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
            child: ListView(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              // controller: _controller,
              children: [
                reporterHistory,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
