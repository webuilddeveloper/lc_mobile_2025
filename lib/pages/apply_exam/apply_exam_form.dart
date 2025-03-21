import 'package:flutter/material.dart';
import 'package:lc/component/button_close_back.dart';
import 'package:lc/component/comment.dart';
import 'package:lc/component/content.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class ApplyExamForm extends StatefulWidget {
  const ApplyExamForm({
    super.key,
    this.code,
    this.model,
  });

  final String? code;
  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _ApplyExamForm createState() => _ApplyExamForm();
}

class _ApplyExamForm extends State<ApplyExamForm> {
  late Comment comment;
  late int _limit;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      comment = Comment(
        code: widget.code,
        url: applyExamCommentApi,
        model: post('${applyExamCommentApi}read',
            {'skip': 0, 'limit': _limit, 'code': widget.code}),
        limit: _limit,
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    sendReportCategory(widget.model['category']);
    setState(() {
      _limit = 10;
    });

    comment = Comment(
      code: widget.code,
      url: applyExamCommentApi,
      model: post('${applyExamCommentApi}read',
          {'skip': 0, 'limit': _limit, 'code': widget.code}),
      limit: _limit,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
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
        backgroundColor: Colors.white,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).unfocus();
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
                shrinkWrap: true,
                children: [
                  Stack(
                    children: [
                      Content(
                        pathShare: 'content/applyExam/',
                        code: widget.code,
                        url: applyExamApi + 'read',
                        model: widget.model,
                        urlGallery: applyExamGalleryApi,
                        urlRotation: rotationApplyExamApi,
                      ),
                      Positioned(
                        right: 0,
                        top: statusBarHeight + 5,
                        child: Container(
                          child: buttonCloseBack(context),
                        ),
                      ),
                    ],
                  ),
                  comment,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendReportCategory(String category) {
    postCategory(
      '${applyExamCategoryApi}read',
      {'skip': 0, 'limit': 1, 'code': category},
    );
  }
}
