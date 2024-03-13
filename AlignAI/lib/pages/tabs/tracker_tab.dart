// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'dart:async';
import 'package:align_ai/api.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/event_model.dart';

class Event {
  final int id;
  final String eventData;
  bool done;

  Event(this.id, this.eventData, [this.done = false]);

  @override
  String toString() => eventData;
}

class TrackerTab extends StatefulWidget {
  @override
  _TrackerTabState createState() => _TrackerTabState();
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 3, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 3, kToday.month, kToday.day);

class _TrackerTabState extends State<TrackerTab> {
  ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .disabled; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  LinkedHashMap<DateTime, List<Event>> kEvents =
      LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<bool> fetchEvents() async {
    await this._memoizer.runOnce(() async {
      List<EventModel> fetchedEvents = await getEvents();
      fetchedEvents.forEach((event) {
        if (kEvents[DateTime.parse(event.eventDate)] == null)
          kEvents[DateTime.parse(event.eventDate)] = [
            Event(event.id, event.eventData)
          ];
        else
          kEvents[DateTime.parse(event.eventDate)]
              .add(Event(event.id, event.eventData));
      });
    });

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    return true;
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
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

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime start, DateTime end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  final _formKey = GlobalKey<FormState>();

  final eventDataController = TextEditingController();

  showCreateForm() async {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 16,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter Event Details',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Event details cannot be empty";
                    else
                      return null;
                  },
                  controller: eventDataController,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      String eventData = eventDataController.text;
                      EventModel createdEvent = await createEvent(
                          _selectedDay.toString().split(" ")[0], eventData);
                      if (createdEvent != null) {
                        Navigator.pop(dialogContext);
                        setState(() {
                          if (kEvents[_selectedDay] == null)
                            kEvents[_selectedDay] = [
                              Event(createdEvent.id, createdEvent.eventData)
                            ];
                          else
                            kEvents[_selectedDay].add(
                                Event(createdEvent.id, createdEvent.eventData));
                        });
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(content: Text('Event created!')),
                        );
                        eventDataController.clear();
                      } else
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to create Event')),
                        );
                    }
                  },
                  child: Text(
                    "Create",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TableCalendar<Event>(
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  rangeStartDay: _rangeStart,
                  rangeEndDay: _rangeEnd,
                  calendarFormat: _calendarFormat,
                  rangeSelectionMode: _rangeSelectionMode,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    formatButtonVisible: false,
                    leftChevronIcon: Icon(
                      MdiIcons.chevronLeft,
                      color: Colors.white,
                    ),
                    rightChevronIcon: Icon(
                      MdiIcons.chevronRight,
                      color: Colors.white,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Colors.amber.shade200,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.purple.shade200,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                    defaultTextStyle: TextStyle(
                      color: Colors.amber.shade200,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    holidayTextStyle: TextStyle(
                      color: Colors.pink.shade300,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    weekendTextStyle: TextStyle(
                      color: Colors.purple.shade200,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          LinearGradient(colors: [Colors.amber, Colors.pink]),
                    ),
                    todayDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                    ),
                    markerDecoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    markerMargin: const EdgeInsets.symmetric(horizontal: 1),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onDaySelected: _onDaySelected,
                  onRangeSelected: _onRangeSelected,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Add Event",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: showCreateForm,
                      icon: Icon(MdiIcons.plusCircle),
                      color: Colors.white,
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(144, 33, 33, 33),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade600),
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.grey.shade700,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade800,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]),
                              child: ListTile(
                                onTap: () => print('${value[index]}'),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${value[index]}'),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // IconButton(
                                        //   onPressed: () {},
                                        //   icon: const Icon(MdiIcons.close),
                                        //   color: Colors.red.shade300,
                                        // ),
                                        IconButton(
                                          onPressed: () async {
                                            final successful =
                                                await deleteEvent(
                                                    value[index].id);
                                            if (successful) {
                                              setState(() {
                                                kEvents[_selectedDay]
                                                    .remove(value[index]);
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Failed to remove Event')),
                                              );
                                            }
                                          },
                                          icon: const Icon(MdiIcons.check),
                                          color: Colors.green.shade300,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator(
            color: Colors.amber,
          );
        }
      },
    );
  }
}
