import 'package:flutter/cupertino.dart';
import 'package:calendar/modal/tuoi_xung_model.dart';

import '../items.dart';

class TuoiXungInDetailDay extends StatelessWidget {
  final List<TuoiXungModel> listTuoiXungTheoNgay, listTuoiXungTheoThang;

  const TuoiXungInDetailDay({Key key, this.listTuoiXungTheoNgay, this.listTuoiXungTheoThang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'TUỔI XUNG THEO NGÀY',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 0.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width / (100),
                  ),
                  itemBuilder: (_, index) => new Items().goodHour(listTuoiXungTheoNgay[index], false),
                  itemCount: listTuoiXungTheoNgay.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 4,
          color: Color(0xffF0F0F0),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'TUỔI XUNG THEO THÁNG',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 0.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width / (100),
                  ),
                  itemBuilder: (_, index) => new Items().goodHour(listTuoiXungTheoThang[index], false),
                  itemCount: listTuoiXungTheoThang.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
