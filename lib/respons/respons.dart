import 'package:date_util/date_util.dart';
import 'package:calendar/convert_solar_lunar/lunar_solar_converter.dart';

import 'package:calendar/modal/event_in_year.dart';
import 'package:calendar/modal/events_in_month.dart';
import 'package:calendar/modal/goodDayInMonthCalendar.dart';
import 'package:calendar/modal/huong_xuat_hanh.dart';
import 'package:calendar/modal/item_xuat_hanh.dart';
import 'package:calendar/modal/lunar_days.dart';
import 'package:calendar/modal/thap_nhi_bat_tu_model.dart';
import 'package:calendar/modal/tiet_khi.dart';
import 'package:calendar/modal/tuoi_xung_model.dart';
import 'package:calendar/service/database.dart';
import 'package:calendar/utils/nhi_thap_bat_tu.dart';
import 'package:calendar/utils/tuoi_xung.dart';
import 'package:calendar/utils/utils_calendar.dart';
import 'package:intl/intl.dart';

class DataRespons {
  static List<EventsInDay> listEvent = [];

  static Future<List<EventsInDay>> getListEvent() async {
    if (listEvent != null && listEvent.length > 0) {
      return listEvent;
    } else {
      listEvent = await DBProvider.db.getEventOfYear(6, 14);

      return listEvent;
    }
  }

  static Future<bool> isEvents(DateTime dateTime) async {
    List<EventsInDay> listEv = await getListEvent();
    Solar solar = Solar(solarDay: dateTime.day, solarYear: dateTime.year, solarMonth: dateTime.month);
    Lunar lunar = LunarSolarConverter.solarToLunar(solar);
    if (lunar.lunarDay == 1 || lunar.lunarDay == 15) return true;
    for (int i = 0; i < listEv.length; i++) {
      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(listEv[i].start_date);
      // tag 82 is solarday
      if (listEv[i].dateType != null && listEv[i].dateType == 0) {
        if (dateTime.day == tempDate.day && dateTime.month == tempDate.month) {
          return true;
        }
      } else {
        Solar solar = Solar(solarDay: tempDate.day, solarYear: tempDate.year, solarMonth: tempDate.month);
        Lunar lunarTemp = LunarSolarConverter.solarToLunar(solar);
        if (lunarTemp.lunarDay == lunar.lunarDay && lunarTemp.lunarMonth == lunar.lunarMonth) {
          return true;
        }
      }
    }
    return false;
  }

  static String getDayInWeek(DateTime dateTime) {
    switch (dateTime.weekday) {
      case DateTime.monday:
        return 'Thứ Hai';
      case DateTime.tuesday:
        return 'Thứ Ba';
      case DateTime.sunday:
        return 'Chủ Nhật';
      case DateTime.saturday:
        return 'Thứ Bảy';
      case DateTime.friday:
        return 'Thứ Sáu';
      case DateTime.wednesday:
        return 'Thứ Tư';
      case DateTime.thursday:
        return 'Thứ Năm';
    }
  }

  static Future<List<EventsInDay>> getListEventOfDay(DateTime dateTime) async {
    List<EventsInDay> listEv = await getListEvent();
    Solar solar = Solar(solarDay: dateTime.day, solarYear: dateTime.year, solarMonth: dateTime.month);
    Lunar lunar = LunarSolarConverter.solarToLunar(solar);
    List<EventsInDay> list = [];
    for (int i = 0; i < listEv.length; i++) {
      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(listEv[i].start_date);
      if (listEv[i].dateType != null && listEv[i].dateType == 0) {
        if (dateTime.day == tempDate.day && dateTime.month == tempDate.month) {
          list.add(listEv[i]);
        }
      } else if (listEv[i].type_id == 14) {
        Solar solar = Solar(solarDay: tempDate.day, solarYear: tempDate.year, solarMonth: tempDate.month);
        Lunar lunarTemp = LunarSolarConverter.solarToLunar(solar);
        if (lunar.lunarDay == lunarTemp.lunarDay) list.add(listEv[i]);
      } else {
        Solar solar = Solar(solarDay: tempDate.day, solarYear: tempDate.year, solarMonth: tempDate.month);
        Lunar lunarTemp = LunarSolarConverter.solarToLunar(solar);
        if (lunarTemp.lunarDay == lunar.lunarDay && lunarTemp.lunarMonth == lunar.lunarMonth) {
          list.add(listEv[i]);
        }
      }
    }

    return list;
  }

  static Future<List<EventOfMonth>> getListEventOfMonth(int year, int month, bool sort) async {
    bool todayHasEvent = false;
    List<EventsInDay> listEv = await getListEvent();
    List<EventsInDay> list = [];
    for (int i = 0; i < listEv.length; i++) {
      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(listEv[i].start_date);
      if (listEv[i].dateType != null && listEv[i].dateType == 0) {
        if (month == tempDate.month && year >= tempDate.year) {
          EventsInDay eventsInDay = new EventsInDay.fromJsonMap(listEv[i].toJson());
          eventsInDay.dateTime = new DateTime(year, month, tempDate.day);
          if (equalDate(eventsInDay.dateTime, DateTime.now())) todayHasEvent = true;
          list.add(eventsInDay);
        }
      } else {
        Solar solar2 = Solar(solarDay: tempDate.day, solarYear: tempDate.year, solarMonth: tempDate.month);
        Lunar lunarTemp = LunarSolarConverter.solarToLunar(solar2);
        Solar solar = LunarSolarConverter.lunarToSolar(new Lunar(
            isLeap: lunarTemp.isLeap, lunarDay: lunarTemp.lunarDay, lunarYear: year, lunarMonth: lunarTemp.lunarMonth));
        if (solar.solarMonth == month && solar.solarYear <= year) {
          EventsInDay eventsOfYear = EventsInDay.fromJsonMap(listEv[i].toJson());
          eventsOfYear.dateTime = solar.dateTime;
          eventsOfYear.lunarDay = lunarTemp.lunarDay;
          eventsOfYear.lunarMonth = lunarTemp.lunarMonth;
          if (equalDate(eventsOfYear.dateTime, DateTime.now())) todayHasEvent = true;
          list.add(eventsOfYear);
        } else if (listEv[i].type_id == 14) {
          int numDay = new DateUtil().daysInMonth(month, year);
          for (int u = 1; u <= numDay; u++) {
            Solar solar = Solar(solarDay: u, solarYear: year, solarMonth: month);
            Lunar lunar = LunarSolarConverter.solarToLunar(solar);
            if (lunar.lunarDay == lunarTemp.lunarDay && lunar.lunarMonth != 1) {
              EventsInDay eventsOfYear = EventsInDay.fromJsonMap(listEv[i].toJson());
              eventsOfYear.dateTime = new DateTime(year, month, u);
              eventsOfYear.lunarDay = lunarTemp.lunarDay;
              eventsOfYear.lunarMonth = lunar.lunarMonth;
              if (equalDate(eventsOfYear.dateTime, DateTime.now())) todayHasEvent = true;
              list.add(eventsOfYear);
            }
          }
        }
      }
    }
    if (year == DateTime.now().year && month == DateTime.now().month && !todayHasEvent) {
      EventsInDay eventsInDay = new EventsInDay();
      eventsInDay.dateTime = DateTime.now();
      list.add(eventsInDay);
    }
    sort ? list.sort((a, b) => b.dateTime.day.compareTo(a.dateTime.day))
        : list.sort((a, b) => a.dateTime.day.compareTo(b.dateTime.day));

    List<EventOfMonth> listDynamic = [];
    List<EventsInDay> tempList = [];
    for (int i = 0; i < list.length; i++) {
      int index =
          list.lastIndexWhere((element) => element.dateTime.day == list[i].dateTime.day && list.indexOf(element) != i);
      if (index < 0) {
        if (tempList.length > 0) {
          List<EventsInDay> list11 = [];
          list11.addAll(tempList);
          listDynamic.add(new EventOfMonth(listEvent: list11));
          listDynamic.add(new EventOfMonth(eventsInDay: list[i]));
          tempList.clear();
        } else {
          listDynamic.add(new EventOfMonth(eventsInDay: list[i]));
        }
      } else {
        tempList.add(list[i]);
      }
    }

    return listDynamic;
  }

  static LunarDay getLunarDay(DateTime dateTime) {
    //  List<int> list = convertSolar2Lunar(dateTime.day, dateTime.month, dateTime.year, 7);
    Solar solar2 = Solar(solarDay: dateTime.day, solarYear: dateTime.year, solarMonth: dateTime.month);
    Lunar lunar = LunarSolarConverter.solarToLunar(solar2);
    //Lunar lunar = LunarSolarConverter.solarToLunars(dateTime);
    var CanNgay = getCanNgay(dateTime.day, dateTime.month, dateTime.year);
    var ChiNgay = getChiNgay(dateTime.day, dateTime.month, dateTime.year);

    LunarDay lunarDay = new LunarDay(
        day: lunar.lunarDay,
        month: lunar.lunarMonth,
        year: lunar.lunarYear,
        ngayHoangDao: getNgayHoangDao(lunar.lunarMonth, getChiNgay(dateTime.day, dateTime.month, dateTime.year)),
        NameOfDay: CanNgay + ' ' + ChiNgay,
        CanNgay: CanNgay,
        ChiNgay: ChiNgay,
        CanThang: getCanThang(lunar.lunarMonth, lunar.lunarYear),
        ChiThang: getChiThang(lunar.lunarMonth),
        // NameOfMonth: getCanThang(lunar.lunarMonth, lunar.lunarYear) + ' ' + getChiThang(lunar.lunarMonth),
        NameOfYear: getCanNam(lunar.lunarYear) + ' ' + getChiNam(lunar.lunarYear),
        gioHoangDao: getGioHoangDao(getChiNgay(dateTime.day, dateTime.month, dateTime.year)),
        isLunarLeap: lunar.isLeap);
    return lunarDay;
  }

  static bool equalDate(DateTime date1, DateTime date2) {
    if (date1 == null || date2 == null) {
      return false;
    }
    if (date1.year == date2.year && date1.month == date2.month && date1.day == date2.day) {
      return true;
    }
    return false;
  }

  static List<TietKhiObject> getTietKhi(DateTime dateTime) {
    // int index = listTietKhi[1].time.indexOf('/');

    List<TietKhiObject> list = [];
    for (int i = 0; i < listTietKhi.length; i++) {
      // get time in String
      // 0 day
      //1 month
      List<int> listDay = getDateFromString(listTietKhi[i].time);
      //if == tietkhi
      if (dateTime.day == listDay[0] && dateTime.month == listDay[1]) {
        list.add(listTietKhi[i]);
        return list;
      }

      if (i == 0 || i == listTietKhi.length - 1) {
        //get index of char /
        //get day from string time
        // get month from string time
        List<int> listDaysss = getDateFromString(listTietKhi[listTietKhi.length - 1].time);
        if (dateTime.month == listDaysss[1] && dateTime.day > listDaysss[0] ||
            dateTime.month == listDay[1] && dateTime.day < listDay[0]) {
          list.add(listTietKhi[listTietKhi.length - 1]);
          list.add(listTietKhi[0]);
          return list;
        }
      } else {
        List<int> listDay1 = getDateFromString(listTietKhi[i - 1].time);
        // equal
        if (dateTime.month <= listDay[1] && dateTime.month >= listDay1[1]) {
          if (jdFromDate(listDay[0], listDay[1], dateTime.year) >
                  jdFromDate(dateTime.day, dateTime.month, dateTime.year) &&
              jdFromDate(dateTime.day, dateTime.month, dateTime.year) >
                  jdFromDate(listDay1[0], listDay1[1], dateTime.year)) {
            list.add(listTietKhi[i - 1]);
            list.add(listTietKhi[i]);
            return list;
          }
        }
      }
    }
    return list;
  }

  static double getPercentOfDay(List<TietKhiObject> list, DateTime dateTime) {
    double percent = 0.0;

    final List<int> Date1 = DataRespons.getDateFromString(list[0].time);
    final List<int> Date2 = DataRespons.getDateFromString(list[1].time);

    // do giữa tiết Đông chí và tiểu hàn nằm ở 2 năm khác nhau nên cần phải xác định ngày được chọn ở năm nào
    if (Date1[1] == 12 && Date2[1] == 1) {
      if (dateTime.day > Date1[0]) {
        percent = getPercent(Date1[0], Date1[1], dateTime.year, Date2[0], Date2[1], dateTime.year + 1, dateTime);
      } else if (dateTime.day < Date2[0]) {
        percent = getPercent(Date1[0], Date1[1], dateTime.year - 1, Date2[0], Date2[1], dateTime.year, dateTime);
      }
    } else {
      percent = getPercent(Date1[0], Date1[1], dateTime.year, Date2[0], Date2[1], dateTime.year, dateTime);
    }

    return percent;
  }

// get percent of tiet khi
  static double getPercent(
      int day, int month, int year, int dayAfter, int monthAfter, int yearAfter, DateTime dateTime) {
    return (jdFromDate(dateTime.day, dateTime.month, dateTime.year) - jdFromDate(day, month, year)) /
        (-jdFromDate(day, month, year) + jdFromDate(dayAfter, monthAfter, yearAfter));
  }

  static List<int> getDateFromString(String time) {
    final int index = time.indexOf('/');
    final int d = int.parse(time.substring(0, index));
    final int m = int.parse(time.substring(index + 1, time.length));
    List<int> list = [d, m];
    return list;
  }

  static List<XuatHanhModel> setUpInfoXuatHanh(String Can, String Chi) {
    int iCan = CAN.indexOf(Can);
    int iChi = CHI.indexOf(Chi);
    List<XuatHanhModel> thongtinXuatHanhVoiThienCanNgay =
        HuongXuatHanh.sharedInstance().thongtinXuatHanhVoiThienCanNgay(iCan, iChi);
    return thongtinXuatHanhVoiThienCanNgay;
//    for (int i = 0; i < thongtinXuatHanhVoiThienCanNgay.length; i++) {
//      ItemXuatHanh itemXuatHanh =  thongtinXuatHanhVoiThienCanNgay[i];
//      print('${itemXuatHanh.tenHuong}  hướng' );
//      print(itemXuatHanh.typeHuong);
//
//      if (itemXuatHanh.typeHuong == TYPE_HUONGXUATHANH.HUONGXUATHANH_HYTHAN) {
//
//
//      } else if (itemXuatHanh.typeHuong == TYPE_HUONGXUATHANH.HUONGXUATHANH_TAITHAN) {
//        print(itemXuatHanh.tenHuong );
//        print('Tài Thần');
////        if (this.layoutTaiThan != null) {
////          this.layoutTaiThan.setVisibility(0);
////        }
////        if (!TextUtils.isEmpty(itemXuatHanh.getTenHuong()) && this.taiThanHuong != null) {
////          this.taiThanHuong.setText(itemXuatHanh.getTenHuong());
////        }
//      } else if (itemXuatHanh.typeHuong == TYPE_HUONGXUATHANH.HUONGXUATHANH_HACTHAN) {
//        print(itemXuatHanh.tenHuong );
//        print('hắc thần');
////        if (this.layoutHacThan != null) {
////          this.layoutHacThan.setVisibility(0);
////        }
////        if (!TextUtils.isEmpty(itemXuatHanh.getTenHuong()) && this.hacThanHuong != null) {
////          this.hacThanHuong.setText(itemXuatHanh.getTenHuong());
////        }
//      }
//    }
  }

  static List<TuoiXungModel> getTuoiXung(String Can, String Chi) {
    int iCan = CAN.indexOf(Can);
    int iChi = CHI.indexOf(Chi);
    List<TuoiXungModel> danhsachTuoiXungVoiThienCan = TuoiXung.sharedInstance().danhsachTuoiXungVoiThienCan(iCan, iChi);
    return danhsachTuoiXungVoiThienCan;
  }

  static List<GoodDayModel> getGoodDayInMonth(DateTime month) {
    DateTime date = month.month == 12 ? DateTime(month.year + 1, 1, 0) : DateTime(month.year, month.month + 1, 0);
    List<GoodDayModel> list = [];
    for (int i = 1; i <= date.day; i++) {
      Solar solar = new Solar(solarYear: month.year, solarMonth: month.month, solarDay: i);
      Lunar lunar = LunarSolarConverter.solarToLunar(solar);
      if (getNgayHoangDao(lunar.lunarMonth, getChiNgay(i, month.month, month.year)) == 1) {
        NhiThapBatTuModel nhiThapBatTuModel = NhiThapBatTu.sharedInstance()
            .getObjectNhiThapBatTu(NhiThapBatTu.sharedInstance().getSaoNhiThapBatTu(solar.dateTime));
        GoodDayModel goodDayModel = new GoodDayModel(solar.dateTime, lunar, nhiThapBatTuModel);
        list.add(goodDayModel);
      }
    }

    return list;
  }

//  static TextToHtml(String string ,String color , bool isName){
//    int indexName = string.indexOf(':');
//    if(isName) {
//      String str = string.substring(indexName+1).trim() == "Xấu" ? "#ec260c" : "#1975d1";
//      return ' <font style =\"font-family: sans-serif; font-weight: 500;\" color= $str > ${string.substring(0,indexName)} </font> <font color=#333333> ${string.substring(indexName)}</font>';
//    }else{
//      return ' <font style =\"font-family: sans-serif; font-weight: 500;\" color= $color > ${string.substring(0,indexName)} </font> <font color=#333333> ${string.substring(indexName)}</font>';
//
//    }
//  }
}
