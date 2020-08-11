import 'package:calendar/modal/event_in_year.dart';
import 'package:calendar/modal/lunar_days.dart';
import 'package:equatable/equatable.dart';
import 'package:calendar/modal/item_xuat_hanh.dart';
import 'package:calendar/modal/ngay_tot_xau_model.dart';
import 'package:calendar/modal/sao_model.dart';
import 'package:calendar/modal/thap_nhi_bat_tu_model.dart';
import 'package:calendar/modal/tiet_khi.dart';
import 'package:calendar/modal/tuoi_xung_model.dart';
import 'package:calendar/utils/gio_ly_thuan_phong.dart';

class LunarDayState extends Equatable {
  @override
  List<Object> get props => [];
}

class LunarDayInit extends LunarDayState {
  final LunarDay lunarDay;
  final DateTime dateTime;
  final String isLeap;
  final List<TuoiXungModel> listTuoiXungTheoNgay, listTuoiXungTheoThang;
  final List<XuatHanhModel> listXuatHanh;
  final List<SaoObject> listSao;
  final List<ItemNgayTotXau> listNgayTotXau;
  final List<GioLyThuanPhong> listGioLyTuanPhong;
  final List<TietKhiObject> listTietKhi;
  final double percent;
  final NhiThapBatTuModel nhiThapBatTuModel;
  final List<EventsInDay> lisEvent;

  LunarDayInit(
      {this.listGioLyTuanPhong,
      this.lisEvent,
      this.listNgayTotXau,
      this.listSao,
      this.lunarDay,
      this.dateTime,
      this.isLeap,
      this.listTuoiXungTheoNgay,
      this.listTuoiXungTheoThang,
      this.listXuatHanh,
      this.listTietKhi,
      this.percent,
      this.nhiThapBatTuModel});

  @override
  List<Object> get props => [
        this.listNgayTotXau,
        this.lisEvent,
        this.listSao,
        this.listGioLyTuanPhong,
        this.lunarDay,
        this.dateTime,
        this.isLeap,
        this.listTuoiXungTheoNgay,
        this.listTuoiXungTheoThang,
        this.listXuatHanh,
        this.listTietKhi,
        this.percent,
        this.nhiThapBatTuModel
      ];
}

class LunarDayUpdate extends LunarDayState {
  final LunarDay lunarDay;
  final DateTime dateTime;
  final String isLeap;
  final List<TuoiXungModel> listTuoiXungTheoNgay, listTuoiXungTheoThang;
  final List<XuatHanhModel> listXuatHanh;
  final List<SaoObject> listSao;
  final List<ItemNgayTotXau> listNgayTotXau;
  final List<GioLyThuanPhong> listGioLyTuanPhong;
  final List<TietKhiObject> listTietKhi;
  final double percent;
  final NhiThapBatTuModel nhiThapBatTuModel;

  LunarDayUpdate(
      {this.listGioLyTuanPhong,
      this.listNgayTotXau,
      this.listSao,
      this.lunarDay,
      this.dateTime,
      this.isLeap,
      this.listTuoiXungTheoNgay,
      this.listTuoiXungTheoThang,
      this.listXuatHanh,
      this.listTietKhi,
      this.percent,
      this.nhiThapBatTuModel});

  @override
  List<Object> get props => [
        this.listNgayTotXau,
        this.listSao,
        this.listGioLyTuanPhong,
        this.lunarDay,
        this.dateTime,
        this.isLeap,
        this.listTuoiXungTheoNgay,
        this.listTuoiXungTheoThang,
        this.listXuatHanh,
        this.listTietKhi,
        this.percent,
        this.nhiThapBatTuModel
      ];
}
