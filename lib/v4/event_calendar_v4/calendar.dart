import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:lc/pages/event_calendar/event_calendar_form.dart';
import 'package:lc/shared/api_provider.dart';
import 'package:lc/shared/extension.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPageV4 extends StatefulWidget {
  const CalendarPageV4({super.key});

  @override
  _CalendarPageV4State createState() => _CalendarPageV4State();
}

class _CalendarPageV4State extends State<CalendarPageV4>
    with TickerProviderStateMixin {
  final storage = new FlutterSecureStorage();
  ValueNotifier<List<dynamic>>? _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  LinkedHashMap<DateTime, List<dynamic>>? model;
  var markData = [];
  Map<DateTime, List<dynamic>>? itemEvents;

  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    model = LinkedHashMap<DateTime, List<dynamic>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(
        Map.fromIterable(
          [0],
          key: (item) => DateTime.now(),
          value: (item) => [],
        ),
      );

    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController!.forward();
    getMarkerEvent();
  }

  @override
  void dispose() {
    _selectedEvents!.dispose();
    super.dispose();
  }

  getMarkerEvent() async {
    var objectData = [];
    // var value = await storage.read(key: 'dataUserLoginSOLAR');
    // var data = json.decode(value);
    final result = await postDio(server + "m/EventCalendar/mark/read2", {
      "year": DateTime.now().year,
      "organization": [],
    });
    if (result != null) {
      objectData = result;

      for (int i = 0; i < objectData.length; i++) {
        if (objectData[i]['items'].length > 0) {
          markData.add(objectData[i]);
        }
      }

      itemEvents = Map.fromIterable(
        markData,
        key: (item) => DateTime.parse(item['date']),
        value: (item) => item['items'],
      );

      var mainEvent = LinkedHashMap<DateTime, List<dynamic>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(itemEvents!);

      setState(() {
        model = mainEvent;
      });
    }
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Implementation example
    // print('kEvents ---> $kEvents');

    // return kEvents[day] ?? [];
    return model![day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents!.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: screen(),
    );
  }

  screen() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(29),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),
          child: TableCalendar<dynamic>(
            firstDay: DateTime.utc(DateTime.now().year - 1, 01, 01),
            lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            availableGestures: AvailableGestures.all,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
            ),
            calendarStyle: CalendarStyle(
              defaultDecoration: BoxDecoration(
                color: Colors.blue.shade50, // สีพื้นหลัง
                borderRadius: BorderRadius.circular(12),
              ),
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle().copyWith(
                color: Colors.black,
                fontFamily: 'Sarabun',
                fontWeight: FontWeight.normal,
              ),
              holidayTextStyle: TextStyle().copyWith(
                color: Color(0xFFC5DAFC),
                fontFamily: 'Sarabun',
                fontWeight: FontWeight.normal,
              ),
            ),
            onDaySelected: _onDaySelected,
            // onRangeSelected: _onRangeSelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                final thaiMonth = DateFormat.MMMM('th_TH').format(day);
                final buddhistYear = day.year + 543;
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    children: [
                      // --- Header เดิม ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _focusedDay = DateTime(
                                    _focusedDay.year, _focusedDay.month - 1, 1);
                              });
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 26,
                            ),
                          ),
                          Text(
                            '$thaiMonth $buddhistYear',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _focusedDay = DateTime(
                                    _focusedDay.year, _focusedDay.month + 1, 1);
                              });
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 26,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // --- ⭐ เส้นคั่นระหว่าง Header กับ Day Row ---
                      const Divider(
                        thickness: 1,
                        height: 1,
                        color: Color(0xFFD9D9D9),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
              selectedBuilder: (context, date, _) {
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0)
                      .animate(_animationController!),
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2D9CED),
                    ),
                    width: 35,
                    height: 35,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(
                          fontSize: 16.0,
                          fontFamily: 'Sarabun',
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                  ),
                );
              },
              defaultBuilder: (context, date, _) {
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0)
                      .animate(_animationController!),
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    width: 35,
                    height: 35,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(
                        fontSize: 16.0,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.normal,
                        // color: Colors.white
                      ),
                    ),
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0)
                      .animate(_animationController!),
                  child: Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1,
                        color: Color(0xFF2D9CED),
                      ),
                      // color: Color(0xFF2D9CED),
                    ),
                    width: 35,
                    height: 35,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(
                        fontSize: 16.0,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.normal,
                        // color: Colors.white
                      ),
                    ),
                  ),
                );
              },
              markerBuilder: (context, day, events) =>
                  events.length > 0 ? _buildEventsMarker(events) : Container(),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ValueListenableBuilder<List<dynamic>>(
              valueListenable: _selectedEvents!,
              builder: (context, value, _) {
                final thaiMonth = DateFormat.MMMM('th_TH').format(_focusedDay);
                final buddhistYear = _focusedDay.year + 543;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_focusedDay.day} $thaiMonth $buddhistYear',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${value.length} กิจกรรม',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: value.length > 0
                          ? ListView.builder(
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return eventCard(value[index]);
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Text(
                                'ไม่พบกิจกรรม',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsMarker(List events) {
    if (events.length == 0) ;
    return Positioned(
      bottom: -4,
      right: 0,
      left: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF2D9CED),
          // events.length > 1
          //     ? Color(0xFF2D9CED)
          //     : Color(0xFFa7141c).withOpacity(0.8),
        ),
        width: 7.0,
        height: 7.0,
      ),
    );
  }

  eventCard(event) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCalendarFormPage(
              code: event['code'],
              model: event,
            ),
          ),
        );
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        padding: EdgeInsets.all(12),
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFfF2FAFF),
          borderRadius: BorderRadius.circular(12.0),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 0,
          //     blurRadius: 3,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                '${event['imageUrl']}',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event['title']}',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Sarabun',
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    event['dateStart'] != '' && event['dateEnd'] != ''
                        ? dateStringToDate(event['dateStart']) +
                            " - " +
                            dateStringToDate(event['dateEnd'])
                        : '',
                    style: TextStyle(fontFamily: 'Sarabun', fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
