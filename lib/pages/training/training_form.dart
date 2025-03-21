import 'package:flutter/material.dart';
import 'package:lc/component/button_close_back.dart';
import 'package:lc/component/comment.dart';
import 'package:lc/component/content.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class TrainingForm extends StatefulWidget {
  const TrainingForm({
    super.key,
    this.code,
    this.model,
  });

  final String? code;
  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _TrainingForm createState() => _TrainingForm();
}

class _TrainingForm extends State<TrainingForm> {
  late Comment comment;
  late int _limit;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      comment = Comment(
        code: widget.code!,
        url: trainingCommentApi,
        model: post('${trainingCommentApi}read',
            {'skip': 0, 'limit': _limit, 'code': widget.code}),
        limit: _limit,
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

    comment = Comment(
      code: widget.code!,
      url: trainingCommentApi,
      model: post('${trainingCommentApi}read',
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
                      pathShare: 'content/training/',
                      code: widget.code!,
                      url: '${trainingApi}read',
                      model: widget.model,
                      urlGallery: trainingGalleryApi,
                      urlRotation: rotationEvantCalendarApi,
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
    );
  }
}
