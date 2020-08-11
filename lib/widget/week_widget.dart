import 'package:flutter/material.dart';
import 'package:calendar/lib_calendar/table_calendar.dart';
import 'package:rect_getter/rect_getter.dart';

class WeekHeader extends StatefulWidget {
  final ScrollController scrollController;
  final CalendarController calendarController;
  final List<DateTime> listVisibleDay;
  final Widget child;
  var topList;

  var listKey;

  WeekHeader(
      {Key key,
      this.scrollController,
      this.child,
      this.listKey,
      this.calendarController,
      this.listVisibleDay,
      this.topList})
      : super(key: key);

  @override
  PositionState createState() {
    // TODO: implement createState
    return PositionState();
  }
}

class PositionState extends State<WeekHeader> {
  bool isShow = true;
  int index = 0;
  double top = 134.36363636363637;

  void _scrollListener() {
    var top = RectGetter.getRectFromKey(widget.topList);
    this.top = top.bottom;
    var itemRect =
        RectGetter.getRectFromKey(widget.listKey[widget.listVisibleDay.indexOf(widget.calendarController.selectedDay)]);
    if (widget.calendarController.selectedDay.toString() !=
        '${widget.calendarController.selectedDay.year}-${widget.calendarController.selectedDay.month.toString().padLeft(2, '0')}-${widget.calendarController.selectedDay.day.toString().padLeft(2, '0')} 12:00:00.000Z') {
      itemRect = RectGetter.getRectFromKey(widget.listKey[index]);
    }
    if (widget.scrollController.position.pixels == widget.scrollController.position.minScrollExtent) {
      isShow = false;
    } else if (itemRect.top <= top.bottom + 1) {
      if (!isShow) isShow = true;
    } else if (widget.scrollController.position.pixels == -130) {
      isShow = true;
    } else {
      if (isShow) isShow = false;
    }
    setState(() {});
  }

  int getIndex() {
    DateTime dateTime;
    widget.listVisibleDay.forEach((element) {
      if (element.day == widget.calendarController.selectedDay.day &&
          element.month == widget.calendarController.selectedDay.month &&
          element.year == widget.calendarController.selectedDay.year) {
        dateTime = element;
      }
    });
    return widget.listVisibleDay.indexOf(dateTime);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    index = getIndex();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isShow
        ? Positioned(
            child: widget.child,
            top: top,
          )
        : Container();
  }
}
