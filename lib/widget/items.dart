import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar/convert_solar_lunar/lunar_solar_converter.dart';
import 'package:calendar/lib_calendar/table_calendar.dart';
import 'package:calendar/modal/event_in_year.dart';
import 'package:calendar/modal/events_in_month.dart';
import 'package:calendar/modal/goodDayInMonthCalendar.dart';
import 'package:calendar/modal/item_xuat_hanh.dart';
import 'package:intl/intl.dart';

import 'package:calendar/modal/tiet_khi.dart';
import 'package:calendar/modal/tuoi_xung_model.dart';
import 'package:calendar/respons/respons.dart';
import 'package:calendar/utils/utils_calendar.dart';
import 'package:calendar/widget/dots.dart';

class Items {
  Widget itemXuatHanh(XuatHanhModel xuatHanhModel) {
    String name = '';
    String icon = '';
    if (xuatHanhModel.typeHuong == TYPE_HUONGXUATHANH.HUONGXUATHANH_HACTHAN) {
      name = 'Hắc Thần';
      icon = 'hacthan';
    } else if (xuatHanhModel.typeHuong == TYPE_HUONGXUATHANH.HUONGXUATHANH_HYTHAN) {
      name = 'Hỷ Thần';
      icon = 'hythan';
    } else if (xuatHanhModel.typeHuong == TYPE_HUONGXUATHANH.HUONGXUATHANH_TAITHAN) {
      name = 'Tài Thần';
      icon = 'taithan';
    }

    return Container(
      margin: EdgeInsets.only(top: 11, bottom: 23),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/icons/$icon.png',
            height: 30,
          ),
          Container(
            margin: EdgeInsets.only(top: 7, bottom: 3),
            child: Text(
              name,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Text(
            xuatHanhModel.tenHuong,
            style: TextStyle(fontSize: 12, color: Color(0xff5E9BEB)),
          )
        ],
      ),
    );
  }

  itemCalendar(DateTime dateTime, bool select,
      {List<EventsInDay> listEv, CalendarFormat calendarFormat, bool inMonth, bool isToday}) {
    Lunar lunar = LunarSolarConverter.solarToLunar(
        Solar(solarDay: dateTime.day, solarMonth: dateTime.month, solarYear: dateTime.year));
    Color personal = Colors.transparent, inYear = Colors.transparent;
    if (listEv != null) {
      listEv.forEach((element) {
        if (element.changeType == 0) {
          inYear = Color(0xffEB9AFF);
        } else {
          personal = Color(0xff30FF83);
        }
      });
    } else {
      int isgoodDay = getNgayHoangDao(lunar.lunarMonth, getChiNgay(dateTime.day, dateTime.month, dateTime.year));
      if (isgoodDay == 1) {
        inYear = Color(0xffF6DE00);
      } else if (isgoodDay == -1) {
        inYear = Color(0xffDCDCDC);
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
      alignment: Alignment.center,
      decoration:
          //dateTime != DateTime.now() ?
          BoxDecoration(
              border: select ? Border.all(color: Color.fromARGB(1, 255, 255, 255).withOpacity(0.8)) : null,
              color: select || inMonth != null
                  ? Color.fromARGB(0, 255, 255, 255).withOpacity(isToday != null ? 0.4 : 0.2)
                  : null,
              borderRadius: BorderRadius.circular(10.0))
//          : BoxDecoration(
//              border: select ? Border.all(color: Color.fromARGB(1, 255, 255, 255).withOpacity(0.8)) : null,
//              color: Color.fromARGB(0, 255, 255, 255).withOpacity(0.4)
//            )
      ,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: 3),
                    alignment: Alignment.centerRight,
                    child: Text(dateTime.day.toString(),
                        style: TextStyle(
                          color: dateTime.weekday != DateTime.sunday ? Colors.white : Color(0xffFFC1B4),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Container(
                    height: double.infinity,
                    margin: EdgeInsets.only(top: 4, right: 3),
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 4,
                      child: Column(
                        children: <Widget>[
                          listEv != null && inYear == Colors.transparent ? SizedBox() : DotGoodDay(color: inYear),
                          SizedBox(
                            height: listEv != null && inYear == Colors.transparent ? 1 : 0,
                          ),
                          DotGoodDay(
                            color: personal,
                          ),
                        ],
                      ),
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
            flex: 1,
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(),
                  flex: 1,
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      lunar.lunarDay == 1 ? '${lunar.lunarDay}/${lunar.lunarMonth}' : lunar.lunarDay.toString(),
                      style: TextStyle(
                          color: dateTime.weekday != DateTime.sunday ? Colors.white : Color(0xffFFC1B4), fontSize: 12),
                    ),
                  ),
                  flex: 1,
                )
              ],
            ),
            flex: 1,
          ),
          //  isgoodDay !=0 ? DotGoodDay(color: isgoodDay == -1 ? Colors.grey :Colors.yellowAccent ,): SizedBox()
        ],
      ),
    );
  }

  Widget tietKhi(TietKhiObject tietKhiObject) {
    List<int> list = DataRespons.getDateFromString(tietKhiObject.time);
    return Column(
      children: <Widget>[
        Image.asset(
          'assets/icons/${tietKhiObject.icon}.png',
          height: 25,
        ),
        Text(
          tietKhiObject.name,
          style: TextStyle(fontSize: 13),
        ),
        Text(
          '${list[0]} Tháng ${list[1]}',
          style: TextStyle(fontSize: 11),
        )
      ],
    );
  }

  Widget goodHour(dynamic index, bool isHours) {
    TuoiXungModel tuoiXungModel;
    if (!isHours) tuoiXungModel = index;

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Image.asset(
                isHours ? 'assets/icons/${IconCHI[index]}.png' : 'assets/icons/${IconCHI[tuoiXungModel.iDiachi]}.png',
                height: 40,
                width: 40,
                alignment: Alignment.centerLeft,
              )),
          Expanded(
            flex: 6,
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    isHours ? CHI[index] : tuoiXungModel.aNameCanChi,
                    style: TextStyle(color: Color(0xff505050), fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isHours ? gioHoangDaoInt(index) : tuoiXungModel.aNameNguHanh,
                    style: TextStyle(color: Color(0xff797979), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  //Container(height: 200, color: Colors.yellow,)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  itemEvent(EventOfMonth eventsOfYear) {
    final date =
        eventsOfYear.eventsInDay != null ? eventsOfYear.eventsInDay.dateTime : eventsOfYear.listEvent[0].dateTime;
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          height: 37,
          color: Color(0xfff2f2f2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(),
                flex: 4,
              ),
              Expanded(
                child: Text('${DataRespons.getDayInWeek(date)}, ngày ${date.day}'),
                flex: 86,
              )
            ],
          ),
        ),
        eventsOfYear.eventsInDay != null
            ? itemEventInDay(eventsOfYear.eventsInDay, 0)
            : ListView.builder(
                itemBuilder: (_, index) => itemEventInDay(eventsOfYear.listEvent[index], index),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventsOfYear.listEvent.length,
              )
      ],
    );

    //itemEventInDay(eventsOfYear.eventsInDay, 0);
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Text(eventsOfYear.eventsInDay.title),
    );
  }

  itemEventInDay(EventsInDay eventsOfYear, int index) {
    DateTime startDate;
    DateTime endDate;
    if (eventsOfYear.content != null) {
      startDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(eventsOfYear.start_date);
      endDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(eventsOfYear.end_date);
    }
    return InkWell(
      onTap: () {
        if (eventsOfYear.title != null) {
          //detail event in here

        } else {
          //add event in here
        }
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                child: eventsOfYear.content == null
                    ? SizedBox()
                    : DotGoodDay(
                        color: eventsOfYear.changeType != 1 ? Color(0xffEB9AFF) : Color(0xff30FF83),
                        size: 13,
                      ),
              ),
              flex: 1,
            ),
            Expanded(
              child: eventsOfYear.title == null
                  ? Container(
                      child: Text('Chưa thêm sự kiện nào. \nHãy nhấn để thêm sự kiện'),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    )
                  : Column(
                      children: <Widget>[
                        index != 0
                            ? Container(
                                height: 1,
                                color: Color(0xffECECEC),
                              )
                            : SizedBox(),
                        Container(
                          margin: EdgeInsets.only(top: 14, bottom: 14),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      eventsOfYear.title,
                                      style: TextStyle(
                                          color: Color(0xff636363), fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                    Container(
                                      child: eventsOfYear.allDay == 1
                                          ? Text(
                                              'Cả Ngày',
                                              style: TextStyle(
                                                  fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xff969696)),
                                            )
                                          : Text(
                                              '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')} - ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}'),
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(top: 7),
                                    )
                                  ],
                                ),
                                flex: 9,
                              ),
                              Expanded(
                                child: Image.asset(
                                  'assets/icons/ic_next.png',
                                  height: 13,
                                  width: 7,
                                ),
                                flex: 1,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
              flex: 8,
            )
          ],
        ),
      ),
    );
  }

  itemGoodDay(GoodDayModel goodDayModel) {
    String day = DataRespons.getDayInWeek(goodDayModel.dateTime);
    // Lunar lunar = LunarSolarConverter.solarToLunar(new Solar(solarYear: goodDayModel.dateTime.year , solarMonth: goodDayModel.dateTime.month , solarDay: goodDayModel.dateTime.day));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 37,
          color: Color(0xffF2F2F2),
          child: Row(
            children: <Widget>[
              Expanded(
                child: DotGoodDay(
                  color: Color(0xffF6DE00),
                  size: 13,
                ),
                flex: 1,
              ),
              Expanded(
                child: Text(
                    '$day, ngày ${goodDayModel.dateTime.day} (Ngày ${goodDayModel.lunar.lunarDay} tháng ${goodDayModel.lunar.lunarMonth} Âm Lịch)'),
                flex: 7,
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Ngày Hoàng Đạo',
                          style: TextStyle(color: Color(0xff636363), fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        margin: EdgeInsets.only(bottom: 12),
                      ),
                      Text(
                        'Nên làm:',
                        style: TextStyle(color: Color(0xff0460D9), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text('${goodDayModel.nhiThapBatTuModel.nenLam}'),
                      Container(
                        child: Text(
                          'Nên Tránh:',
                          style: TextStyle(color: Color(0xffE93800), fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        margin: EdgeInsets.only(top: 10),
                      ),
                      Text('${goodDayModel.nhiThapBatTuModel.kiengcu.trim()}'),
                    ],
                  ),
                ),
                flex: 9,
              ),
              Expanded(
                child: Image.asset(
                  'assets/icons/ic_next.png',
                  height: 13,
                  width: 7,
                ),
                flex: 1,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildHeader(DateTime thisdateTime, bool dayDetail) {
    return SafeArea(
        child: Container(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 4, top: 20),
          child: Row(
            children: <Widget>[
              dayDetail
                  ? Expanded(
                      child: Container(
                        child: Image.asset(
                          'assets/icons/ic_back.png',
                          height: 17,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      flex: 2,
                    )
                  : SizedBox(),
              Expanded(
                flex: 8,
                child: Container(
                  alignment: dayDetail ? Alignment.center : Alignment.centerLeft,
                  child: Text(
                    'Tháng ${thisdateTime.month} - ${thisdateTime.year}',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: !dayDetail
                    ? Image.asset(
                        'assets/icons/ic_add_event.png',
                        height: 25,
                      )
                    : SizedBox(),
              )
            ],
          ),
        ),
        Container(
          color: Color.fromARGB(1, 255, 255, 255).withOpacity(0.3),
          height: 1,
          margin: EdgeInsets.only(bottom: 14, top: 15, left: 4, right: 4),
        ),
        Container(
          height: 15,
          margin: EdgeInsets.only(bottom: 14),
          child: Table(
            children: [
              _buildDaysOfWeek(),
            ],
          ),
        ),
      ],
    )));
  }

  TableRow _buildDaysOfWeek() {
    return TableRow(
      children: ['HAI', 'BA', 'TƯ', 'NĂM', 'SÁU', 'BẢY', 'C.N'].map((e) {
        return Center(
          child: Text(
            e,
            style: TextStyle(
                color: e == 'C.N' ? Color(0xffFFC1B4) : Color(0xffCCDEF5), fontSize: 13, fontWeight: FontWeight.w800),
          ),
        );
      }).toList(),
    );
  }
}
