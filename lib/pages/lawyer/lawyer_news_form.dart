import 'package:flutter/material.dart';
import 'package:lc/component/button_close_back.dart';
import 'package:lc/pages/lawyer/lawyer_content.dart';
import 'package:lc/shared/api_provider.dart';

// ignore: must_be_immutable
class LawyerNewsForm extends StatefulWidget {
  const LawyerNewsForm({
    super.key,
    this.code,
    this.model,
  });

  final String? code;
  final dynamic model;

  @override
  // ignore: library_private_types_in_public_api
  _LawyerNewsForm createState() => _LawyerNewsForm();
}

class _LawyerNewsForm extends State<LawyerNewsForm> {
  @override
  void initState() {
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
            child: ListView(
              shrinkWrap: true,
              children: [
                Stack(
                  children: [
                    LawyerContent(
                      code: widget.code!,
                      url: newsElectionLcApi,
                      model: widget.model,
                      urlGallery: newsGalleryElectionLcApi,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
