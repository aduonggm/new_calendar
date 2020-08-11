import 'package:calendar/convert_solar_lunar/lunar_solar_converter.dart';
import 'package:calendar/modal/thap_nhi_bat_tu_model.dart';

class GoodDayModel {
  final DateTime dateTime;
  final Lunar lunar;
  final NhiThapBatTuModel nhiThapBatTuModel;

  GoodDayModel(this.dateTime, this.lunar, this.nhiThapBatTuModel);
}
