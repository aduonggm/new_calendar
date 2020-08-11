import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar/modal/event_in_year.dart';

import '../items.dart';

class ListEventDetailDay extends StatelessWidget {
  final List<EventsInDay> listEvInDay;

  const ListEventDetailDay({Key key, this.listEvInDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (listEvInDay == null || listEvInDay.length == 0) {
      EventsInDay eventsInDay = new EventsInDay();
      eventsInDay.dateTime = DateTime.now();
      listEvInDay.add(eventsInDay);
    }

    return Container(
      margin: EdgeInsets.only(top: 6),
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'SỰ KIỆN',
            style: TextStyle(fontSize: 16),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: ListView.builder(
                padding: EdgeInsets.only(top: 0.0),
                itemCount: listEvInDay.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final EventsInDay ev = listEvInDay[index];
                  return new Items().itemEventInDay(ev, index);
                }),
          )
        ],
      ),
    );
  }
}
