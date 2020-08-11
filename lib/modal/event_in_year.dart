import 'package:equatable/equatable.dart';

class EventsInDay extends Equatable {
  final int localId;
  final String title;
  int lunarDay, lunarMonth;
  DateTime dateTime;
  final int changeType;
  final int dateType;
  final String content;
  final String image_url;
  final int type_id;
  final int allDay;
  final String start_date;
  final String end_date;
  final String loop_info;
  final String tags;

  EventsInDay({
    this.localId,
    this.changeType,
    this.title,
    this.dateType,
    this.allDay,
    this.end_date,
    this.content,
    this.image_url,
    this.type_id,
    this.start_date,
    this.loop_info,
    this.tags,
    this.dateTime,
    this.lunarMonth,
    this.lunarDay,
  });

  // EventsOfYear(this.localId, this.title, this.content, this.image_url, this.start_date, this.loop_info, this.tags);
  EventsInDay.fromJsonMap(Map<String, dynamic> map)
      : localId = map["localId"],
        title = map["title"],
        content = map["content"],
        image_url = map["image_url"],
        start_date = map["start_date"],
        end_date = map['end_date'],
        loop_info = map["loop_info"],
        allDay = map['allDay'],
        tags = map["tags"],
        dateType = map["date_type"],
        changeType = map['changeType'],
        type_id = map['type_id'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['localId'] = localId;
    data['content'] = content;
    data['image_url'] = image_url;
    data['start_date'] = start_date;
    data['loop_info'] = loop_info;
    data['tags'] = tags;
    data['allDay'] = allDay;
    data['changeType'] = changeType;
    data['end_date'] = end_date;
    data["date_type"] = dateType;
    data['type_id'] = type_id;
    return data;
  }

  @override
  List<Object> get props => [
        this.dateTime,
        this.localId,
        this.title,
        this.content,
        this.end_date,
        this.image_url,
        this.start_date,
        this.allDay,
        this.changeType,
        this.loop_info,
        this.tags,
        this.dateType,
        this.lunarMonth,
        this.lunarDay
      ];
}
