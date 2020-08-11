import 'package:flutter_bloc/flutter_bloc.dart';

import '../../convert_solar_lunar/lunar_solar_converter.dart';
import '../../modal/event_in_year.dart';
import '../../modal/item_xuat_hanh.dart';
import '../../modal/lunar_days.dart';
import '../../modal/thap_nhi_bat_tu_model.dart';
import '../../modal/tiet_khi.dart';
import '../../modal/tuoi_xung_model.dart';
import '../../respons/respons.dart';
import '../../utils/gio_ly_thuan_phong.dart';
import '../../utils/ngay_tot_xau.dart';
import '../../utils/nhi_thap_bat_tu.dart';
import '../../utils/sao_hun_cat_tinh.dart';
import '../../utils/utils_calendar.dart';
import 'blocs.dart';

class LunarDayBloc extends Bloc<LunarDayEvent, LunarDayState> {
  @override
  Stream<LunarDayState> mapEventToState(LunarDayEvent event) async* {
    if (event is LunarDayChange) {
      LunarDay lunarDay = DataRespons.getLunarDay(
        event.dateTime,
      );
      List<TuoiXungModel> listNgay = DataRespons.getTuoiXung(lunarDay.CanNgay, lunarDay.ChiNgay);
      List<TuoiXungModel> listThang = DataRespons.getTuoiXung(lunarDay.CanThang, lunarDay.ChiThang);
      List<XuatHanhModel> listXuatHanh = DataRespons.setUpInfoXuatHanh(lunarDay.CanNgay, lunarDay.ChiNgay);
      List<TietKhiObject> listTK = DataRespons.getTietKhi(event.dateTime);
      double percent = 0.0;
      if (listTK.length == 2) {
        percent = DataRespons.getPercentOfDay(listTK, event.dateTime);
      }

      NhiThapBatTuModel nhiThapBatTuModel = NhiThapBatTu.sharedInstance()
          .getObjectNhiThapBatTu(NhiThapBatTu.sharedInstance().getSaoNhiThapBatTu(event.dateTime));
      List saoTotXau = SaoHungTinhCatTinh.sharedInstance()
          .getSaoTotXau(lunarDay.month, CAN.indexOf(lunarDay.CanNgay), CHI.indexOf(lunarDay.ChiNgay));

      List<GioLyThuanPhong> listGioLyThuanPhong =
          GioXHLyThuanPhong.sharedInstance().getListGioLyThuanPhong(lunarDay.day, lunarDay.month);

      List danhsachNgayTotXau = NgayTotXau.sharedInstance().danhsachNgayTotXau(
          lunarDay.day,
          lunarDay.month,
          event.dateTime.day,
          event.dateTime.month,
          CAN.indexOf(getCanNam(lunarDay.year)),
          CHI.indexOf(getChiNam(lunarDay.year)),
          CAN.indexOf(lunarDay.CanNgay),
          CHI.indexOf(lunarDay.ChiNgay));
      yield LunarDayUpdate(
          listGioLyTuanPhong: listGioLyThuanPhong,
          listNgayTotXau: danhsachNgayTotXau,
          lunarDay: lunarDay,
          percent: percent,
          dateTime: event.dateTime,
          isLeap: !lunarDay.isLunarLeap ? 'Đ' : 'T',
          listTietKhi: listTK,
          nhiThapBatTuModel: nhiThapBatTuModel,
          listTuoiXungTheoNgay: listNgay,
          listTuoiXungTheoThang: listThang,
          listXuatHanh: listXuatHanh,
          listSao: saoTotXau);
    }
  }

  @override
  LunarDayState get initialState => LunarDayInit();
}
