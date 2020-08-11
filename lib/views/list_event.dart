import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar/bloc/event_bloc/blocs.dart';
import 'package:calendar/lib_calendar/table_calendar.dart';
import 'package:calendar/modal/events_in_month.dart';
import 'package:calendar/respons/respons.dart';
import 'package:rect_getter/rect_getter.dart';
import '../widget/bottom_loader.dart';
import '../widget/items.dart';

class ListEvents extends StatefulWidget {


  const ListEvents({Key key}) : super(key: key);

  @override
  ListState createState() {
    return ListState();
  }
}

class ListState extends State<ListEvents> {
  GlobalKey _keyRed = GlobalKey();
  final Key centerKey = ValueKey('second-sliver-list');
  double currentScroll = 0.0;
  static var keysOfTop = {};
  static var keysOfBottom = {};
  bool clickDate = false;
  static var listBottomKey = RectGetter.createGlobalKey();
  static var listTopKey = RectGetter.createGlobalKey();
  CalendarController calendarController;
  ScrollController _scrollController;
  double offsets;

  bool setSelect = false;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();
    calendarController = new CalendarController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    calendarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsBloc>(
      create: (context) =>
      EventsBloc()
        ..add(Fetch(false, DateTime
            .now()
            .month, DateTime
            .now()
            .year)),
      child: BlocListener<EventsBloc, EventsState>(
        condition: (previous, current) => previous.props != current.props,
        listener: (context, state) {
          if (state is EventsUpdate && state.dateTime != null) {
            calendarController.setSelectedDay(state.dateTime);
            setSelect = false;
          }
        },
        child: BlocBuilder<EventsBloc, EventsState>(builder: (context, state) {
          if (state is EventsUpdate) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  var btnn = getOffsetFromDateTime(DateTime.now(), state.bottomList, keysOfBottom, state.bottomList);
                  print('offfset ${btnn}');
                  setState(() {
                    _scrollController.animateTo(
                        getOffsetFromDateTime(DateTime.now(), state.bottomList, keysOfBottom, state.bottomList),
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeInOutBack);
                  });
                },
                child: Icon(Icons.event),
                backgroundColor: Colors.green,
              ),
              body: Column(
                children: <Widget>[
                  TableCalendar(
                    headerVisible: false,
                    onDaySelected: (date, _) {
                      if (date.isBefore(DateTime(DateTime
                          .now()
                          .year, DateTime
                          .now()
                          .month, 01))) {
                        offsets = 2 + getOffsetFromDateTime(date, state.topList, keysOfTop, state.bottomList);
                      } else {
                        offsets = 2 + getOffsetFromDateTime(date, state.topList, keysOfBottom, state.bottomList);
                      }

                      if (!setSelect)
                        setState(() {
                          _scrollController.animateTo(offsets,
                              duration: Duration(milliseconds: 1500), curve: Curves.easeInOutBack);
                        });
                    },
                    rowHeight: 270,
                    calendarController: calendarController,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    builders: CalendarBuilders(
                      todayDayBuilder: (context, date, events) =>
                          new Items().itemCalendar(date, false, inMonth: true, listEv: events, isToday: true),
                      selectedDayBuilder: (context, date, events) {
                        return new Items().itemCalendar(date, true, listEv: events);
                      },
                      outsideDayBuilder: (context, date, events) =>
                          new Items().itemCalendar(date, false, listEv: events),
                      outsideWeekendDayBuilder: (context, date, events) =>
                          new Items().itemCalendar(date, false, listEv: events),
                      dayBuilder: (context, date, events) {
                        return new Items().itemCalendar(date, false, listEv: events, inMonth: true);
                      },
                    ),
                    initialCalendarFormat: CalendarFormat.week,
                  ),
                  Expanded(
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height,
                        child: NotificationListener(
                          onNotification: (ScrollNotification scrollNotification) {
                            if (scrollNotification is ScrollEndNotification &&
                                scrollNotification.metrics.pixels != offsets) {
                              if (RectGetter
                                  .getRectFromKey(listTopKey)
                                  .bottom
                                  .toInt() > _getPositions().toInt()) {
                                int index = getVisibleTop();
                                if (state.topList != null && state.topList.length > 0 && index < state.topList.length) {
                                  getItemInTopList(index, state.topList, context);
                                }
                              } else {
                                int index = getVisibleBottom();
                                if (state.bottomList != null &&
                                    state.bottomList.length > 0 &&
                                    index != null &&
                                    index < state.bottomList.length) {
                                  getItemInBottomList(index, state.bottomList, context);
                                }
                              }
                            } else if (scrollNotification is ScrollEndNotification) {
                              if (RectGetter
                                  .getRectFromKey(listTopKey)
                                  .bottom
                                  .toInt() > _getPositions().toInt()) {
                                int index = getVisibleTop();
                                if (state.topList != null && state.topList.length > 0 && index < state.topList.length) {
                                  DateTime dateTime = state.topList[state.topList.length - 2].eventsInDay != null
                                      ? state.topList[state.topList.length - 2].eventsInDay.dateTime
                                      : state.topList[state.topList.length - 2].listEvent[0].dateTime;

                                  DateTime date = getDateTimeFormIndex(index, state.topList, true);
                                  print('date   ${date.month}   ${dateTime.month}');
                                  if (date.month - 1 <= dateTime.month) {
                                    BlocProvider.of<EventsBloc>(context)
                                      ..add(Fetch(true, dateTime.month - 1, dateTime.year));
                                  }
                                }
                              } else {
                                int index = getVisibleBottom();
                                if (state.bottomList != null &&
                                    state.bottomList.length > 0 &&
                                    index != null &&
                                    index < state.bottomList.length) {
                                  DateTime dateTime = state.bottomList[state.bottomList.length - 1].eventsInDay != null
                                      ? state.bottomList[state.bottomList.length - 1].eventsInDay.dateTime
                                      : state.bottomList[state.bottomList.length - 1].listEvent[0].dateTime;
                                  DateTime date = getDateTimeFormIndex(index, state.bottomList, false);
                                  print('date   ${date}   ${dateTime.month}');
                                  if (date.month + 1 >= dateTime.month) {
                                    print('addd');
                                    BlocProvider.of<EventsBloc>(context)
                                      ..add(Fetch(false, dateTime.month + 1, dateTime.year));
                                  }
                                }
                              }
                            }

                            if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent) {
                              if (state.bottomList[state.bottomList.length - 1].eventsInDay != null) {
                                BlocProvider.of<EventsBloc>(context)
                                  ..add(Fetch(
                                      false,
                                      state.bottomList[state.bottomList.length - 1].eventsInDay.dateTime.month + 1,
                                      state.bottomList[state.bottomList.length - 1].eventsInDay.dateTime.year));
                              } else {
                                BlocProvider.of<EventsBloc>(context)
                                  ..add(Fetch(
                                      false,
                                      state.bottomList[state.bottomList.length - 1].listEvent[0].dateTime.month + 1,
                                      state.bottomList[state.bottomList.length - 1].listEvent[0].dateTime.year));
                              }
                            } else
                            if (scrollNotification.metrics.pixels == scrollNotification.metrics.minScrollExtent) {
                              if (state.topList != null && state.topList.length > 0) {
                                if (state.topList[state.topList.length - 2].eventsInDay != null) {
                                  BlocProvider.of<EventsBloc>(context)
                                    ..add(Fetch(
                                        true,
                                        state.topList[state.topList.length - 2].eventsInDay.dateTime.month - 1,
                                        state.topList[state.topList.length - 2].eventsInDay.dateTime.year));
                                } else {
                                  BlocProvider.of<EventsBloc>(context)
                                    ..add(Fetch(
                                        true,
                                        state.topList[state.topList.length - 2].listEvent[0].dateTime.month - 1,
                                        state.topList[state.topList.length - 2].listEvent[0].dateTime.year));
                                }
                              }
                            }
                            return;
                          },
                          child: CustomScrollView(

                            key: _keyRed,
                            controller: _scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            center: centerKey,
                            slivers: <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate((_, int index) {
                                  return RectGetter(
                                    key: listTopKey,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      reverse: true,
                                      shrinkWrap: true,
                                      itemCount: state.topList != null ? state.topList.length : 0,
                                      itemBuilder: (BuildContext context, int index) {
                                        keysOfTop[index] = RectGetter.createGlobalKey();
                                        return RectGetter(
                                          key: keysOfTop[index],
                                          child: new Items().itemEvent(state.topList[index]),
                                        );
                                      },
                                    ),
                                  );
                                }, childCount: 1),
                              ),
                              SliverList(
                                key: centerKey,
                                delegate: SliverChildBuilderDelegate((_, indexx) {
                                  return RectGetter(
                                    key: listBottomKey,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      // reverse: true,
                                      shrinkWrap: true,
                                      itemCount: state.bottomList.length + 1,
                                      itemBuilder: (BuildContext context, int index) {
                                        keysOfBottom[index] = RectGetter.createGlobalKey();
                                        return RectGetter(
                                          key: keysOfBottom[index],
                                          child: index >= state.bottomList.length
                                              ? BottomLoader()
                                              : new Items().itemEvent(state.bottomList[index]),
                                        );
                                      },
                                    ),
                                  );
                                }, childCount: 1),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            );
          }
          if (state is EventsError) {
            return Center(
              child: Text('error'),
            );
          }
          return Container();
        }),
      ),
    );
  }

  DateTime getDateTimeFormIndex(int index, List<EventOfMonth> list, bool isTop) {
    if (list[index].eventsInDay != null) {
      if (list[index].eventsInDay.title != null) {
        return list[index].eventsInDay.dateTime;
      } else {
        if (isTop)
          return getDateTimeFormIndex(index - 1, list, isTop);
        else
          return getDateTimeFormIndex(index + 1, list, isTop);
      }
    } else {
      return list[index].listEvent[0].dateTime;
    }
  }

  getItemInBottomList(int index, List<EventOfMonth> bottomList, BuildContext context) {
    EventOfMonth eventOfMonth = bottomList[index];
    if (eventOfMonth.eventsInDay != null) {
      setCalendar(context, eventOfMonth.eventsInDay.dateTime);
    } else
      setCalendar(context, eventOfMonth.listEvent[0].dateTime);
  }

  double getOffsetFromDateTime(DateTime dateTime, List<EventOfMonth> topList, var listKey,
      List<EventOfMonth> botttomList) {
    var itemRect = RectGetter
        .getRectFromKey(keysOfBottom[0])
        .top;

    EventOfMonth eventOfMonth = findItemWithDateTime(dateTime, botttomList + topList);
    int top = topList.indexOf(eventOfMonth);
    int bottom = botttomList.indexOf(eventOfMonth);
    var itemRect1;
    if (top >= 0) {
      itemRect1 = RectGetter
          .getRectFromKey(keysOfTop[top])
          .top;
    }
    if (bottom >= 0) {
      itemRect1 = RectGetter
          .getRectFromKey(keysOfBottom[bottom])
          .top;
    }
    return itemRect1 - itemRect + 40;
  }

  EventOfMonth findItemWithDateTime(DateTime dateTime, List<EventOfMonth> list) {
    EventOfMonth eventOfMonth;
    list.forEach((element) {
      if (element.eventsInDay != null && DataRespons.equalDate(element.eventsInDay.dateTime, dateTime)) {
        eventOfMonth = element;
      } else if (element.listEvent != null) {
        if (DataRespons.equalDate(element.listEvent[0].dateTime, dateTime)) {
          eventOfMonth = element;
        }
      }
    });
    if (eventOfMonth == null) {
      eventOfMonth = findItemWithDateTime(dateTime.subtract(Duration(days: 1)), list);
    }
    return eventOfMonth;
  }

  getItemInTopList(int index, List<EventOfMonth> topList, BuildContext context) {
    EventOfMonth eventOfMonth = topList[index];
    if (eventOfMonth.eventsInDay != null) {
      if (eventOfMonth.eventsInDay.content != null) {
        setCalendar(context, eventOfMonth.eventsInDay.dateTime);
      } else {
        getItemInTopList(index - 1, topList, context);
      }
    } else {
      setCalendar(context, eventOfMonth.listEvent[0].dateTime);
    }
  }

  setCalendar(BuildContext context, DateTime dateTime) {
//    setSelect = false;
//    setState(() {
//      calendarController.setSelectedDay(dateTime);
//    });

    BlocProvider.of<EventsBloc>(context).add(Scroll(dateTime));
    setSelect = true;
  }

  int getVisibleTop() {
    int indexxx;
    for (int i = keysOfTop.length - 1; i >= 0; i--) {
      var itemRect = RectGetter.getRectFromKey(keysOfTop[i]);
      if (itemRect != null && itemRect.bottom > _getPositions() && itemRect.top < MediaQuery
          .of(context)
          .size
          .height) {
        indexxx = i;
        return i;
      }
    }
    return indexxx;
  }

  int getVisibleBottom() {
    int indexxxx;
    for (int i = 0; i < keysOfBottom.length; i++) {
      var itemRect = RectGetter.getRectFromKey(keysOfBottom[i]);
      if (itemRect != null && itemRect.bottom > _getPositions() && itemRect.top < MediaQuery
          .of(context)
          .size
          .height) {
        indexxxx = i;
        return i;
      }
    }
    return indexxxx;
  }

  _getPositions() {
    final RenderBox renderBoxRed = _keyRed.currentContext.findRenderObject();
    final positionRed = renderBoxRed.localToGlobal(Offset.zero);
    return positionRed.dy;
  }
}
