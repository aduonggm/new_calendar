import 'package:flutter/cupertino.dart';
import 'package:calendar/modal/ngay_tot_xau_model.dart';
import 'package:calendar/modal/sao_model.dart';
import 'package:calendar/modal/thap_nhi_bat_tu_model.dart';
import 'package:calendar/utils/utils_calendar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class TuViHangNgay extends StatelessWidget {
  final String str;
  final NhiThapBatTuModel nhiThapBatTuModel;

  final int indexName;
  final List<SaoObject> listSao;
  final List<ItemNgayTotXau> listNgayTotXau;

  const TuViHangNgay({Key key, this.str, this.nhiThapBatTuModel, this.indexName, this.listSao, this.listNgayTotXau})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        HtmlWidget(
            ' $openTag $str > ${nhiThapBatTuModel.tenSao.substring(0, indexName)} $closeTag <font color=#333333> ${nhiThapBatTuModel.tenSao.substring(indexName)}$closeTag'),
        Text(nhiThapBatTuModel.binhSao),
        HtmlWidget('$openTag #1975d1 >Nên Làm: $closeTag ${nhiThapBatTuModel.nenLam}'),
        HtmlWidget('$openTag #ec260c >Kiêng cữ: $closeTag${nhiThapBatTuModel.kiengcu}'),
        HtmlWidget('$openTag #1975d1 >Ngoại lệ: $closeTag${nhiThapBatTuModel.ngoaile}'),
        Text(nhiThapBatTuModel.thoVinh),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Sao Tốt Xấu'),
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listSao.length,
            itemBuilder: (context, index) {
              return Text(listSao[index].tenSao + '  ' + listSao[index].mota);
            }),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Ngày Tốt Xấu'),
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: listNgayTotXau.length,
            itemBuilder: (context, index) {
              return Text(listNgayTotXau[index].tenNgay + '  ' + listNgayTotXau[index].mota);
            }),

//                        ListView.builder(
//                            physics: NeverScrollableScrollPhysics(),
//                            shrinkWrap: true,
//                            itemCount: lisEvent.length,
//                            itemBuilder: (context, index) {
//                              return HtmlWidget(lisEvent[index].title +
//                                  '  ' +
//                                  lisEvent[index].content);
//                            }),
      ],
    );
  }
}
