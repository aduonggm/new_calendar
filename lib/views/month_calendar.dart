import 'package:flutter/material.dart';
import 'package:calendar/lib_calendar/table_calendar.dart';
import 'package:calendar/respons/respons.dart';
import 'package:calendar/widget/items.dart';

class MonthCalendar extends StatefulWidget {
  @override
  MonthCalendarState createState() {
    return MonthCalendarState();
  }
}

class MonthCalendarState extends State<MonthCalendar> {
  CalendarController calendarController;
  var list = [];

  DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    list = DataRespons.getGoodDayInMonth(DateTime.now());
    calendarController = new CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabCalendarCustoms(
      //'   childWidget:  ListView.builder(itemBuilder: null,itemCount: ,) ,
      initialCalendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      childWidget: ListView.builder(
        padding: EdgeInsets.only(top: 0),
        itemBuilder: (context, index) => new Items().itemGoodDay(list[index]),
        itemCount: list.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
      calendarStatus: CalendarStatus.unpin,
      onDaySelected: (dateTime, list) {
        if (date.month != dateTime.month)
          setState(() {
            this.list = DataRespons.getGoodDayInMonth(dateTime);
          });
        // calendarController1.setSelectedDay(dateTime);
      },
      calendarController: calendarController,
      heightTable: 270,
      builders: CalendarBuilders(
        todayDayBuilder: (context, date, events) => new Items().itemCalendar(date, false, inMonth: true, isToday: true),
        selectedDayBuilder: (context, date, events) {
          return new Items().itemCalendar(
            date,
            true,
          );
        },
        outsideDayBuilder: (context, date, events) => new Items().itemCalendar(
          date,
          false,
        ),
        outsideWeekendDayBuilder: (context, date, events) => new Items().itemCalendar(date, false, listEv: events),
        dayBuilder: (context, date, events) {
          return new Items().itemCalendar(date, false, inMonth: true);
        },
      ),
    ));
  }
}
