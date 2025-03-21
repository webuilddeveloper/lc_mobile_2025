import 'package:lc/component/sso/list_content_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:lc/pages/event_calendar/event_calendar_form.dart';
import 'package:lc/pages/event_calendar/event_calendar_main.dart';
import 'package:lc/shared/api_provider.dart';

class BuildEventCalendar extends StatefulWidget {
  const BuildEventCalendar(
      {Key? key, required this.menuModel, required this.model})
      : super(key: key);

  final Future<dynamic> model;
  final Future<dynamic> menuModel;

  @override
  BuildEventCalendarState createState() => BuildEventCalendarState();
}

class BuildEventCalendarState extends State<BuildEventCalendar> {
  dynamic _tempModel = {'imageUrl': '', 'firstName': '', 'lastName': ''};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: widget.menuModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return screen(snapshot.data, false);
          } else if (snapshot.hasError) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              height: 90,
              child: Center(
                child: Text('Network ขัดข้อง'),
              ),
            );
          } else {
            return screen(_tempModel, true);
          }
        });
  }

  ListContentHorizontal screen(dynamic model, bool isLoading) {
    var title = isLoading ? '' : model[0]['title'];
    var imageUrl = isLoading ? '' : model[0]['imageUrl'];

    return ListContentHorizontal(
      title: title,
      url: eventCalendarApi,
      imageUrl: imageUrl,
      model: widget.model,
      urlComment: eventCalendarCommentApi,
      navigationList: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCalendarMain(
              title: model[0]['title'],
            ),
          ),
        );
      },
      navigationForm: (
        String code,
        String url,
        dynamic model,
        String urlComment,
        String urlGallery,
      ) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCalendarFormPage(
              code: code,
              model: model,
            ),
          ),
        );
      },
      urlGallery: eventCalendarGalleryApi,
    );
  }
  // .end
}
