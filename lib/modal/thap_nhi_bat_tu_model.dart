enum TYPE_SAONHITHAPBATTU {
  TYPE_SAONHITHAPBATTU_GIAC,
  TYPE_SAONHITHAPBATTU_CANG,
  TYPE_SAONHITHAPBATTU_DE,
  TYPE_SAONHITHAPBATTU_PHONG,
  TYPE_SAONHITHAPBATTU_TAM,
  TYPE_SAONHITHAPBATTU_VI,
  TYPE_SAONHITHAPBATTU_CO,
  TYPE_SAONHITHAPBATTU_DAU,
  TYPE_SAONHITHAPBATTU_NGUU,
  TYPE_SAONHITHAPBATTU_NU,
  TYPE_SAONHITHAPBATTU_HU,
  TYPE_SAONHITHAPBATTU_NGUY,
  TYPE_SAONHITHAPBATTU_THAT,
  TYPE_SAONHITHAPBATTU_BICH,
  TYPE_SAONHITHAPBATTU_KHUE,
  TYPE_SAONHITHAPBATTU_LAU,
  TYPE_SAONHITHAPBATTU_VIJ,
  TYPE_SAONHITHAPBATTU_MAO,
  TYPE_SAONHITHAPBATTU_TAT,
  TYPE_SAONHITHAPBATTU_CHUY,
  TYPE_SAONHITHAPBATTU_SAM,
  TYPE_SAONHITHAPBATTU_TINHR,
  TYPE_SAONHITHAPBATTU_QUY,
  TYPE_SAONHITHAPBATTU_LIEU,
  TYPE_SAONHITHAPBATTU_TINH,
  TYPE_SAONHITHAPBATTU_TRUONG,
  TYPE_SAONHITHAPBATTU_DUC,
  TYPE_SAONHITHAPBATTU_CHUAN
}

//private final int value;
//
//private TYPE_SAONHITHAPBATTU(int i) {
//  this.value = i;
//}
//
//int getValue() {
//  return this.value;
//}
//}

class NhiThapBatTuModel {
  String binhSao;
  int diemCuoiHoi;
  int diemDoTran;
  int diemDongTho;
  int diemKhaiTruong;
  int diemKhoiCong;
  int diemMuaNha;
  int diemMuaOtoXemay;
  int diemNhapTrach;
  int diemXuathanh;
  String kiengcu;
  String nenLam;
  String ngoaile;
  String tenSao;
  String thoVinh;
  TYPE_SAONHITHAPBATTU typeSaoNhiThapBatTu;
}
