//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

part of table_calendar;

enum CalendarStatus { pinWeek, pinmonth, unpin }

/// Highly customizable, feature-packed Flutter Calendar with gestures, animations and multiple formats.
class TabCalendarCustoms extends StatefulWidget {
  final Widget childWidget;

  /// Controller required for `TableCalendar`.
  /// Use it to update `events`, `holidays`, etc.
  final CalendarController calendarController;

  /// Locale to format `TableCalendar` dates with, for example: `'en_US'`.
  ///
  /// If nothing is provided, a default locale will be used.
  final dynamic locale;

  final CalendarStatus calendarStatus;

  /// `Map` of events.
  /// Each `DateTime` inside this `Map` should get its own `List` of objects (i.e. events).
  final List<EventsInDay> events;

  /// `Map` of holidays.
  /// This property allows you to provide custom holiday rules.
  final Map<DateTime, List> holidays;

  /// Called whenever any day gets tapped.
  final OnDaySelected onDaySelected;

  /// Called whenever any day gets long pressed.
  final OnDaySelected onDayLongPressed;

  /// Called whenever any unavailable day gets tapped.
  /// Replaces `onDaySelected` for those days.
  final VoidCallback onUnavailableDaySelected;

  /// Called whenever any unavailable day gets long pressed.
  /// Replaces `onDaySelected` for those days.
  final VoidCallback onUnavailableDayLongPressed;

  /// Called whenever header gets tapped.
  final HeaderGestureCallback onHeaderTapped;

  /// Called whenever header gets long pressed.
  final HeaderGestureCallback onHeaderLongPressed;

  /// Called whenever the range of visible days changes.
  final OnVisibleDaysChanged onVisibleDaysChanged;

  /// Called once when the CalendarController gets initialized.
  final OnCalendarCreated onCalendarCreated;

  /// Initially selected DateTime. Usually it will be `DateTime.now()`.
  final DateTime initialSelectedDay;

  /// The first day of `TableCalendar`.
  /// Days before it will use `unavailableStyle` and run `onUnavailableDaySelected` callback.
  final DateTime startDay;

  /// The last day of `TableCalendar`.
  /// Days after it will use `unavailableStyle` and run `onUnavailableDaySelected` callback.
  final DateTime endDay;

  /// List of days treated as weekend days.
  /// Use built-in `DateTime` weekday constants (e.g. `DateTime.monday`) instead of `int` literals (e.q. `1`).
  final List<int> weekendDays;

  /// `CalendarFormat` which will be displayed first.
  final CalendarFormat initialCalendarFormat;

  /// `Map` of `CalendarFormat`s and `String` names associated with them.
  /// Those `CalendarFormat`s will be used by internal logic to manage displayed format.
  ///
  /// To ensure proper vertical Swipe behavior, `CalendarFormat`s should be in descending order (eg. from biggest to smallest).
  ///
  /// For example:
  /// ```dart
  /// availableCalendarFormats: const {
  ///   CalendarFormat.month: 'Month',
  ///   CalendarFormat.week: 'Week',
  /// }
  /// ```
  final Map<CalendarFormat, String> availableCalendarFormats;

  /// Used to show/hide Header.

  /// Function deciding whether given day should be enabled or not.
  /// If `false` is returned, this day will be unavailable.
  final EnabledDayPredicate enabledDayPredicate;

  /// Used for setting the height of `TableCalendar`'s rows.
  final double heightTable;

  /// Animation to run when `CalendarFormat` gets changed.
  final FormatAnimation formatAnimation;

  /// `TableCalendar` will start weeks with provided day.
  /// Use `StartingDayOfWeek.monday` for Monday - Sunday week format.
  /// Use `StartingDayOfWeek.sunday` for Sunday - Saturday week format.
  final StartingDayOfWeek startingDayOfWeek;

  /// `HitTestBehavior` for every day cell inside `TableCalendar`.
  final HitTestBehavior dayHitTestBehavior;

  /// Specify Gestures available to `TableCalendar`.
  /// If `AvailableGestures.none` is used, the Calendar will only be interactive via buttons.
  final AvailableGestures availableGestures;

  /// Configuration for vertical Swipe detector.
  final SimpleSwipeConfig simpleSwipeConfig;

  /// Style for `TableCalendar`'s content.
  final CalendarStyle calendarStyle;

  /// Style for DaysOfWeek displayed between `TableCalendar`'s Header and content.
  final DaysOfWeekStyle daysOfWeekStyle;

  /// Style for `TableCalendar`'s Header.
  final HeaderStyle headerStyle;

  /// Set of Builders for `TableCalendar` to work with.
  final CalendarBuilders builders;

  TabCalendarCustoms({
    Key key,
    this.childWidget,
    @required this.calendarController,
    this.locale,
    @required this.calendarStatus,
    this.events = const [],
    this.holidays = const {},
    this.onDaySelected,
    this.onDayLongPressed,
    this.onUnavailableDaySelected,
    this.onUnavailableDayLongPressed,
    this.onHeaderTapped,
    this.onHeaderLongPressed,
    this.onVisibleDaysChanged,
    this.onCalendarCreated,
    this.initialSelectedDay,
    this.startDay,
    this.endDay,
    this.weekendDays = const [DateTime.saturday, DateTime.sunday],
    this.initialCalendarFormat = CalendarFormat.month,
    this.availableCalendarFormats = const {
      CalendarFormat.month: 'Month',
      CalendarFormat.week: 'Week',
    },
    this.enabledDayPredicate,
    this.heightTable,
    this.formatAnimation = FormatAnimation.slide,
    this.startingDayOfWeek = StartingDayOfWeek.sunday,
    this.dayHitTestBehavior = HitTestBehavior.deferToChild,
    this.availableGestures = AvailableGestures.all,
    this.simpleSwipeConfig = const SimpleSwipeConfig(
      verticalThreshold: 25.0,
      swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
    ),
    this.calendarStyle = const CalendarStyle(),
    this.daysOfWeekStyle = const DaysOfWeekStyle(),
    this.headerStyle = const HeaderStyle(),
    this.builders = const CalendarBuilders(),
  })  : assert(calendarController != null),
        assert(heightTable != null),
        assert(calendarStatus != null),
        assert(availableCalendarFormats.keys.contains(initialCalendarFormat)),
        assert(availableCalendarFormats.length <= CalendarFormat.values.length),
        assert(weekendDays != null),
        assert(weekendDays.isNotEmpty
            ? weekendDays.every((day) => day >= DateTime.monday && day <= DateTime.sunday)
            : true),
        super(key: key);

  @override
  _TabCalendarCustomsState createState() => _TabCalendarCustomsState();
}

class _TabCalendarCustomsState extends State<TabCalendarCustoms> //  with SingleTickerProviderStateMixin
    with
        TickerProviderStateMixin {
  var keysOfItemCalendar = {};
  bool isPin = true;
  List<DateTime> listVisibleDay;
  CalendarController calendarController1;
  ScrollController scrollController;
  bool endScroll = false;
  double topOfList;
  LunarDay lunarDay;
  var keyTopOfList;

  double topList;

  List<XuatHanhModel> listXuatHanh;
  List<TietKhiObject> listTK;
  List<TuoiXungModel> listNgay;
  List<TuoiXungModel> listThang;
  double percent = 0.0;
  DateTime thisdateTime;
  final Key centerKey = ValueKey('second-sliver-list');
  int count = 0;

  @override
  void initState() {
    super.initState();
    calendarController1 = CalendarController();
    scrollController =
        ScrollController(initialScrollOffset: widget.calendarStatus == CalendarStatus.unpin ? -400 : -190);
    thisdateTime = widget.initialSelectedDay ?? DateTime.now();
    keyTopOfList = RectGetter.createGlobalKey();
    widget.calendarController._init(
      events: widget.events,
      holidays: widget.holidays,
      initialDay: thisdateTime,
      initialFormat: widget.initialCalendarFormat,
      availableCalendarFormats: widget.availableCalendarFormats,
      useNextCalendarFormat: widget.headerStyle.formatButtonShowsNext,
      startingDayOfWeek: widget.startingDayOfWeek,
      selectedDayCallback: (date) => _selectedDayCallback(date, false),
      onVisibleDaysChanged: widget.onVisibleDaysChanged,
      onCalendarCreated: widget.onCalendarCreated,
      includeInvisibleDays: widget.calendarStyle.outsideDaysVisible,
    );
    calendarController1._init(
      events: widget.events,
      holidays: widget.holidays,
      initialDay: thisdateTime,
      initialFormat: CalendarFormat.week,
      availableCalendarFormats: widget.availableCalendarFormats,
      useNextCalendarFormat: widget.headerStyle.formatButtonShowsNext,
      startingDayOfWeek: widget.startingDayOfWeek,
      selectedDayCallback: (date) => _selectedDayCallback(date, false),
      onVisibleDaysChanged: widget.onVisibleDaysChanged,
      onCalendarCreated: widget.onCalendarCreated,
      includeInvisibleDays: widget.calendarStyle.outsideDaysVisible,
    );
  }

  @override
  void didUpdateWidget(TabCalendarCustoms oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) {
      widget.calendarController._events = widget.events;
    }
    if (oldWidget.holidays != widget.holidays) {
      widget.calendarController._holidays = widget.holidays;
    }
  }

  void _selectedDayCallback(DateTime day, bool click) {
    if (!click) {
      widget.calendarController.setSelectedDay(day, isProgrammatic: false);
      calendarController1.setSelectedDay(day, isProgrammatic: true);
    }
    if (widget.onDaySelected != null) {
      widget.onDaySelected(day, widget.calendarController.visibleEvents(day) ?? []);
    }
    thisdateTime = day;
  }

  void _selectPrevious(CalendarController calendarController) {
    calendarController._selectPrevious();
  }

  void _selectNext(CalendarController calendarController) {
    calendarController._selectNext();
  }

  void _selectDay(DateTime day) {
    widget.calendarController.setSelectedDay(day, isProgrammatic: false);
    calendarController1.setSelectedDay(day, isProgrammatic: true);
    _selectedDayCallback(day, true);
  }

  void _onDayLongPressed(DateTime day) {
    if (widget.onDayLongPressed != null) {
      widget.onDayLongPressed(day, widget.calendarController.visibleEvents(day) ?? []);
    }
  }

  void _onHorizontalSwipe(DismissDirection direction, CalendarController calendarController) {
    if (direction == DismissDirection.startToEnd) {
      // Swipe right
      _selectPrevious(calendarController);
    } else {
      // Swipe left
      _selectNext(calendarController);
    }
  }

  void _onUnavailableDaySelected() {
    if (widget.onUnavailableDaySelected != null) {
      widget.onUnavailableDaySelected();
    }
  }

  void _onUnavailableDayLongPressed() {
    if (widget.onUnavailableDayLongPressed != null) {
      widget.onUnavailableDayLongPressed();
    }
  }

  bool _isDayUnavailable(DateTime day) {
    return (widget.startDay != null && day.isBefore(widget.calendarController._normalizeDate(widget.startDay))) ||
        (widget.endDay != null && day.isAfter(widget.calendarController._normalizeDate(widget.endDay))) ||
        (!_isDayEnabled(day));
  }

  bool _isDayEnabled(DateTime day) {
    return widget.enabledDayPredicate == null ? true : widget.enabledDayPredicate(day);
  }

  double getTopOfList() {
    var items = RectGetter.getRectFromKey(keyTopOfList);
    return items.bottom;
  }

  @override
  Widget build(BuildContext context) {
    listVisibleDay = widget.calendarController._getVisibleDays();
    return ClipRect(
      child: Stack(
        children: <Widget>[
          NotificationListener<ScrollNotification>(
            child: CustomScrollView(
              controller: scrollController,
              center: centerKey,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((_, __) {
                    return Container(
                      padding: widget.calendarStyle.contentPadding,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xff034AA6), Color(0xff0460D9)],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.3, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                      ),
                      child: Column(
                        children: <Widget>[
                          new Items().buildHeader(thisdateTime, true),
                          SizedBox(
                            height: 1,
                          ),
                          _buildCalendarContent(widget.calendarController, true)
                        ],
                      ),
                    );
                  }, childCount: 1),
                ),
                SliverList(
                  key: centerKey,
                  delegate: SliverChildBuilderDelegate((_, __) {
                    return widget.childWidget;
                  }, childCount: 1),
                ),
              ],
            ),
            onNotification: (ScrollNotification scrollInfo) {
              //count = 0;
              if (scrollInfo is ScrollEndNotification) {
                if (scrollController.position.pixels < -190 &&
                    scrollController.position.pixels > scrollController.position.minScrollExtent) {
                  count++;
                  if (count == 1) {
                    if (scrollController.position.pixels + getTopOfList() >
                        (scrollController.position.minScrollExtent + getTopOfList()) / 2) {
                      scrollController.jumpTo(-190);
                    } else
                      scrollController.jumpTo(scrollController.position.minScrollExtent);
                  }
                } else
                  count = 0;
              }
              return;
            },
          ),
          widget.calendarStatus != CalendarStatus.unpin
              ? Positioned(
                  child: Container(
                  padding: widget.calendarStyle.contentPadding,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xff034AA6), Color(0xff0460D9)],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.3, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RectGetter(
                        child: new Items().buildHeader(thisdateTime, true),
                        key: keyTopOfList,
                      ),
                      widget.calendarStatus == CalendarStatus.pinmonth
                          ? Container(
                              child: _buildCalendarContent(widget.calendarController, false),
                            )
                          : SizedBox()
                    ],
                  ),
                ))
              : Container(),
          widget.calendarStatus == CalendarStatus.pinWeek
              ? WeekHeader(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff034AA6), Color(0xff0460D9)],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(0.3, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: _buildWrapper(calendarController1, false, list: listVisibleDay),
                    padding: widget.calendarStyle.contentPadding,
                  ),
                  topList: keyTopOfList,
                  listKey: keysOfItemCalendar,
                  calendarController: widget.calendarController,
                  scrollController: scrollController,
                  listVisibleDay: listVisibleDay,
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget _buildCalendarContent(CalendarController calendarController, bool hasKey) {
    if (widget.formatAnimation == FormatAnimation.slide) {
      return AnimatedSize(
        duration: Duration(milliseconds: calendarController.calendarFormat == CalendarFormat.month ? 330 : 220),
        curve: Curves.fastOutSlowIn,
        alignment: Alignment(0, -1),
        vsync: this,
        child: _buildWrapper(calendarController, hasKey),
      );
    } else {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: _buildWrapper(
          calendarController,
          hasKey,
          key: ValueKey(calendarController.calendarFormat),
        ),
      );
    }
  }

  Widget _buildWrapper(
    CalendarController calendarController,
    bool hasKey, {
    Key key,
    List<DateTime> list,
  }) {
    Widget wrappedChild = _buildTable(calendarController, hasKey, list: list);

    switch (widget.availableGestures) {
      case AvailableGestures.all:
        wrappedChild = _buildHorizontalSwipeWrapper(
          calendarController,
          child: wrappedChild,
        );
        break;

      case AvailableGestures.horizontalSwipe:
        wrappedChild = _buildHorizontalSwipeWrapper(
          calendarController,
          child: wrappedChild,
        );
        break;
      case AvailableGestures.none:
        break;
    }

    return Container(
      key: key,
      child: wrappedChild,
    );
  }

  Widget _buildHorizontalSwipeWrapper(CalendarController calendarController, {Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.decelerate,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(calendarController._dx, 0), end: Offset(0, 0)).animate(animation),
          child: child,
        );
      },
      layoutBuilder: (currentChild, _) => currentChild,
      child: Dismissible(
        //secondaryBackground: Center(child: CircularProgressIndicator(),),
        key: ValueKey(calendarController._pageId),
        resizeDuration: null,
        onDismissed: (derec) => _onHorizontalSwipe(derec, calendarController),
        direction: DismissDirection.horizontal,
        child: child,
      ),
    );
  }

  Widget _buildTable(
    CalendarController calendarController,
    bool hasKey, {
    List<DateTime> list,
  }) {
    final daysInWeek = 7;
    final children = <TableRow>[
      // if (widget.calendarStyle.renderDaysOfWeek && list == null) _buildDaysOfWeek(),
    ];
    if (list == null) {
      int x = 0;
      while (x < calendarController._visibleDays.value.length) {
        children.add(_buildTableRow(
            calendarController._visibleDays.value.skip(x).take(daysInWeek).toList(), calendarController, hasKey));
        x += daysInWeek;
      }
    } else {
      children.add(
          _buildTableRow(calendarController._daysInWeek(calendarController.selectedDay), calendarController, hasKey));
    }
    return Table(
      // Makes this Table fill its parent horizontally
      defaultColumnWidth: FractionColumnWidth(1.0 / daysInWeek),
      children: children,
    );
  }

  TableRow _buildTableRow(List<DateTime> days, CalendarController calendarController, bool hasKey) {
    return TableRow(children: days.map((date) => _buildTableCell(date, calendarController, hasKey)).toList());
  }

  // TableCell will have equal width and height
  Widget _buildTableCell(DateTime date, CalendarController calendarController, bool hasKey) {
    if (calendarController != calendarController1) {
      if (hasKey) keysOfItemCalendar[listVisibleDay.indexOf(date)] = RectGetter.createGlobalKey();
      return Container(
          margin: widget.calendarController._getVisibleDays().length / 7 == 6
              ? EdgeInsets.symmetric(vertical: 0)
              : EdgeInsets.symmetric(
                  vertical: widget.calendarController._getVisibleDays().length / 7 == 5
                      ? widget.heightTable / 60
                      : widget.heightTable / 24),
          height: 45,
          child: RectGetter(
            child: _buildCell(date, calendarController),
            key: hasKey ? keysOfItemCalendar[listVisibleDay.indexOf(date)] : null,
          ));
    } else
      return Container(
        height: 45,
        child: _buildCell(date, calendarController),
      );
  }

  Widget _buildCell(DateTime date, CalendarController calendarController) {
    if (!widget.calendarStyle.outsideDaysVisible &&
        widget.calendarController._isExtraDay(date) &&
        widget.calendarController.calendarFormat == CalendarFormat.month) {
      return Container();
    }
    Widget content = _buildCellContent(date, calendarController);
    return GestureDetector(
      behavior: widget.dayHitTestBehavior,
      onTap: () => _isDayUnavailable(date) ? _onUnavailableDaySelected() : _selectDay(date),
      onLongPress: () => _isDayUnavailable(date) ? _onUnavailableDayLongPressed() : _onDayLongPressed(date),
      child: content,
    );
  }

  Widget _buildCellContent(DateTime date, CalendarController calendarController) {
    //  final eventKey = _getEventKey(date);

    final tIsUnavailable = _isDayUnavailable(date);
    final tIsSelected = calendarController.isSelected(date);
    final tIsToday = calendarController.isToday(date);
    final tIsOutside = calendarController._isExtraDay(date);
    final tIsHoliday = false;
    final tIsWeekend = calendarController._isWeekend(date, widget.weekendDays);

    final isUnavailable = widget.builders.unavailableDayBuilder != null && tIsUnavailable;
    final isSelected = widget.builders.selectedDayBuilder != null && tIsSelected;
    final isToday = widget.builders.todayDayBuilder != null && tIsToday;
    final isOutsideHoliday = widget.builders.outsideHolidayDayBuilder != null && tIsOutside && tIsHoliday;
    final isHoliday = widget.builders.holidayDayBuilder != null && !tIsOutside && tIsHoliday;
    final isOutsideWeekend =
        widget.builders.outsideWeekendDayBuilder != null && tIsOutside && tIsWeekend && !tIsHoliday;
    final isOutside = widget.builders.outsideDayBuilder != null && tIsOutside && !tIsWeekend && !tIsHoliday;
    final isWeekend = widget.builders.weekendDayBuilder != null && !tIsOutside && tIsWeekend && !tIsHoliday;

    if (isUnavailable) {
      return widget.builders.unavailableDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (isSelected && widget.calendarStyle.renderSelectedFirst) {
      return widget.builders.selectedDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (isToday) {
      return widget.builders.todayDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (isSelected) {
      return widget.builders.selectedDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (isOutsideHoliday) {
      return widget.builders.outsideHolidayDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (isHoliday) {
      return widget.builders.holidayDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (isOutsideWeekend) {
      return widget.builders.outsideWeekendDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (isOutside) {
      return widget.builders.outsideDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (isWeekend) {
      return widget.builders.weekendDayBuilder(context, date, calendarController.visibleEvents(date));
    } else if (widget.builders.dayBuilder != null) {
      return widget.builders.dayBuilder(context, date, calendarController.visibleEvents(date));
    } else {
      return _CellWidget(
        text: '${date.day}',
        isUnavailable: tIsUnavailable,
        isSelected: tIsSelected,
        isToday: tIsToday,
        isWeekend: tIsWeekend,
        isOutsideMonth: tIsOutside,
        isHoliday: tIsHoliday,
        calendarStyle: widget.calendarStyle,
      );
    }
  }
}
