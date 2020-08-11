import 'package:flutter/material.dart';
import 'package:calendar/convert_solar_lunar/lunar_solar_converter.dart';
import 'package:calendar/lib_calendar/table_calendar.dart';
import 'package:calendar/modal/event_in_year.dart';
import 'package:calendar/modal/item_xuat_hanh.dart';
import 'package:calendar/modal/lunar_days.dart';
import 'package:calendar/modal/ngay_tot_xau_model.dart';
import 'package:calendar/modal/sao_model.dart';
import 'package:calendar/modal/thap_nhi_bat_tu_model.dart';
import 'package:calendar/modal/tiet_khi.dart';
import 'package:calendar/modal/tuoi_xung_model.dart';
import 'package:calendar/respons/respons.dart';
import 'package:calendar/utils/gio_ly_thuan_phong.dart';
import 'package:calendar/utils/ngay_tot_xau.dart';
import 'package:calendar/utils/nhi_thap_bat_tu.dart';
import 'package:calendar/utils/sao_hun_cat_tinh.dart';
import 'package:calendar/utils/solar_lular_utils.dart';
import 'package:calendar/widget/detail_day/day_detail.dart';
import 'package:calendar/widget/items.dart';

class Calendars extends StatefulWidget {
  final DateTime dateTime;

  Calendars({Key key, this.dateTime}) : super(key: key);
  double offset;

  @override
  CalendarState createState() {
    // TODO: implement createState
    return CalendarState();
  }
}

class CalendarState extends State<Calendars> {
  DateTime date;

  List<EventsInDay> listEv;
  CalendarController calendarController;
  List<ItemNgayTotXau> listNgayTotXau;
  NhiThapBatTuModel nhiThapBatTuModel;
  List<SaoObject> listSao;
  List<GioLyThuanPhong> listGioLyThuanPhong;
  String str;
  LunarDay lunarDay;

  List<XuatHanhModel> listXuatHanh;

  List<TietKhiObject> listTK;

  List<TuoiXungModel> listNgay;

  List<TuoiXungModel> listThang;
  double percent = 0.0;
  int indexName;

  void getEvent() async {
    listEv = await DataRespons.getListEventOfDay(date);
  }

  @override
  void initState() {
    super.initState();
    calendarController = new CalendarController();
    date = widget.dateTime ?? DateTime.now();
    getEvent();
    lunarDay = DataRespons.getLunarDay(date);

    listNgay = DataRespons.getTuoiXung(lunarDay.CanNgay, lunarDay.ChiNgay);
    listThang = DataRespons.getTuoiXung(lunarDay.CanThang, lunarDay.ChiThang);
    listXuatHanh = DataRespons.setUpInfoXuatHanh(lunarDay.CanNgay, lunarDay.ChiNgay);

    listTK = DataRespons.getTietKhi(date);
    percent = 0.0;
    if (listTK.length == 2) {
      percent = DataRespons.getPercentOfDay(listTK, date);
    }
    listSao = SaoHungTinhCatTinh.sharedInstance()
        .getSaoTotXau(lunarDay.month, CAN.indexOf(lunarDay.CanNgay), CHI.indexOf(lunarDay.ChiNgay));
    ;
    listNgayTotXau = NgayTotXau.sharedInstance().danhsachNgayTotXau(
        lunarDay.day,
        lunarDay.month,
        date.day,
        date.month,
        CAN.indexOf(getCanNam(lunarDay.year)),
        CHI.indexOf(getChiNam(lunarDay.year)),
        CAN.indexOf(lunarDay.CanNgay),
        CHI.indexOf(lunarDay.ChiNgay));
    nhiThapBatTuModel =
        NhiThapBatTu.sharedInstance().getObjectNhiThapBatTu(NhiThapBatTu.sharedInstance().getSaoNhiThapBatTu(date));
    indexName = nhiThapBatTuModel.tenSao.indexOf(':');
    str = nhiThapBatTuModel.tenSao.substring(indexName + 1).trim() == "Xấu" ? "#ec260c" : "#1975d1";
    listGioLyThuanPhong = GioXHLyThuanPhong.sharedInstance().getListGioLyThuanPhong(lunarDay.day, lunarDay.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: DataRespons.getListEvent(),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return TabCalendarCustoms(
                initialSelectedDay: date,
                calendarStatus: CalendarStatus.pinWeek,
                childWidget: DayDetail(
                  str: str,
                  nhiThapBatTuModel: nhiThapBatTuModel,
                  listSao: listSao,
                  indexName: indexName,
                  listNgayTotXau: listNgayTotXau,
                  percent: percent,
                  listXuatHanh: listXuatHanh,
                  lunarDay: lunarDay,
                  listEv: listEv,
                  listGioLyThuanPhong: listGioLyThuanPhong,
                  listNgay: listNgay,
                  listThang: listThang,
                  listTK: listTK,
                  thisdateTime: date,
                ),
                initialCalendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerVisible: true,
                events: snapshot.data,
                onDaySelected: (dateTime, list) {
                  setState(() {
                    listEv = list;
                    lunarDay = DataRespons.getLunarDay(dateTime);
                    listNgay = DataRespons.getTuoiXung(lunarDay.CanNgay, lunarDay.ChiNgay);
                    listThang = DataRespons.getTuoiXung(lunarDay.CanThang, lunarDay.ChiThang);
                    listXuatHanh = DataRespons.setUpInfoXuatHanh(lunarDay.CanNgay, lunarDay.ChiNgay);
                    listTK = DataRespons.getTietKhi(dateTime);
                    percent = 0.0;
                    if (listTK.length == 2) {
                      percent = DataRespons.getPercentOfDay(listTK, dateTime);
                    }
                    listSao = SaoHungTinhCatTinh.sharedInstance()
                        .getSaoTotXau(lunarDay.month, CAN.indexOf(lunarDay.CanNgay), CHI.indexOf(lunarDay.ChiNgay));
                    listNgayTotXau = NgayTotXau.sharedInstance().danhsachNgayTotXau(
                        lunarDay.day,
                        lunarDay.month,
                        dateTime.day,
                        dateTime.month,
                        CAN.indexOf(getCanNam(lunarDay.year)),
                        CHI.indexOf(getChiNam(lunarDay.year)),
                        CAN.indexOf(lunarDay.CanNgay),
                        CHI.indexOf(lunarDay.ChiNgay));
                    nhiThapBatTuModel = NhiThapBatTu.sharedInstance()
                        .getObjectNhiThapBatTu(NhiThapBatTu.sharedInstance().getSaoNhiThapBatTu(dateTime));
                    indexName = nhiThapBatTuModel.tenSao.indexOf(':');
                    str = nhiThapBatTuModel.tenSao.substring(indexName + 1).trim() == "Xấu" ? "#ec260c" : "#1975d1";
                    listGioLyThuanPhong =
                        GioXHLyThuanPhong.sharedInstance().getListGioLyThuanPhong(lunarDay.day, lunarDay.month);
                    date = dateTime;
                  });
                  // calendarController1.setSelectedDay(dateTime);
                },
                calendarController: calendarController,
                heightTable: 270,
                builders: CalendarBuilders(
                  todayDayBuilder: (context, date, events) =>
                      new Items().itemCalendar(date, false, inMonth: true, listEv: events, isToday: true),
                  selectedDayBuilder: (context, date, events) {
                    return new Items().itemCalendar(date, true, listEv: events);
                  },
                  outsideDayBuilder: (context, date, events) => new Items().itemCalendar(date, false, listEv: events),
                  outsideWeekendDayBuilder: (context, date, events) =>
                      new Items().itemCalendar(date, false, listEv: events),
                  dayBuilder: (context, date, events) {
                    return new Items().itemCalendar(date, false, listEv: events, inMonth: true);
                  },
                ),
              );
            else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }
}
