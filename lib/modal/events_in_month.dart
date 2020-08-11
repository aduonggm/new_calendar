import 'package:equatable/equatable.dart';
import 'package:calendar/modal/event_in_year.dart';

class EventOfMonth extends Equatable {
  final EventsInDay eventsInDay;
  final List<EventsInDay> listEvent;

  EventOfMonth({this.eventsInDay, this.listEvent});

  @override
  // TODO: implement props
  List<Object> get props => [this.eventsInDay, this.listEvent];
}
