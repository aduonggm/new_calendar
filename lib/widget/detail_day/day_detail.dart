import 'package:flutter/cupertino.dart';
import 'package:calendar/modal/event_in_year.dart';
import 'package:calendar/modal/item_xuat_hanh.dart';
import 'package:calendar/modal/lunar_days.dart';
import 'package:calendar/modal/ngay_tot_xau_model.dart';
import 'package:calendar/modal/sao_model.dart';
import 'package:calendar/modal/thap_nhi_bat_tu_model.dart';
import 'package:calendar/modal/tiet_khi.dart';
import 'package:calendar/modal/tuoi_xung_model.dart';
import 'package:calendar/utils/gio_ly_thuan_phong.dart';

import 'list_event.dart';
import 'ngay_gio_tot.dart';
import 'tu_vi_hang_ngay.dart';
import 'tuoi_xung.dart';
import 'xuat_hanh_tiet_khi.dart';

class DayDetail extends StatelessWidget {
  final DateTime thisdateTime;
  final LunarDay lunarDay;

  final List<XuatHanhModel> listXuatHanh;

  final int indexName;
  final List<TietKhiObject> listTK;

  final List<TuoiXungModel> listNgay;

  final List<TuoiXungModel> listThang;
  final List<SaoObject> listSao;

  final List<ItemNgayTotXau> listNgayTotXau;

  final NhiThapBatTuModel nhiThapBatTuModel;

  final String str;
  final double percent;
  final List<EventsInDay> listEv;

  final List<GioLyThuanPhong> listGioLyThuanPhong;

  const DayDetail(
      {Key key,
      this.thisdateTime,
      this.lunarDay,
      this.listXuatHanh,
      this.indexName,
      this.listTK,
      this.listNgay,
      this.listThang,
      this.listSao,
      this.listNgayTotXau,
      this.nhiThapBatTuModel,
      this.str,
      this.percent,
      this.listGioLyThuanPhong,
      this.listEv})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        NgayGioTot(
          dateTime: thisdateTime,
          lunarDay: lunarDay,
        ),
        ListEventDetailDay(
          listEvInDay: listEv,
        ),
        TuoiXungInDetailDay(
          listTuoiXungTheoNgay: listNgay,
          listTuoiXungTheoThang: listThang,
        ),
        XuatHanhInDetailDay(
          listXuatHanh: listXuatHanh,
          listTietKhi: listTK,
          percent: percent,
        ),
        TuViHangNgay(
          listNgayTotXau: listNgayTotXau,
          indexName: indexName,
          listSao: listSao,
          nhiThapBatTuModel: nhiThapBatTuModel,
          str: str,
        )
      ],
    );
  }
}
