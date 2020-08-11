import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar/modal/item_xuat_hanh.dart';
import 'package:calendar/modal/tiet_khi.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../items.dart';

class XuatHanhInDetailDay extends StatelessWidget {
  final List<XuatHanhModel> listXuatHanh;
  final List<TietKhiObject> listTietKhi;
  final double percent;

  const XuatHanhInDetailDay({Key key, this.listXuatHanh, this.listTietKhi, this.percent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('list ${listXuatHanh.length} ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 6,
          color: Color(0xffF0F0F0),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'XUẤT HÀNH',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Items().itemXuatHanh(listXuatHanh[0]),
              flex: 1,
            ),
            listXuatHanh.length >= 2
                ? Expanded(
                    child: Items().itemXuatHanh(listXuatHanh[1]),
                    flex: 1,
                  )
                : Container(),
            listXuatHanh.length >= 3
                ? Expanded(
                    child: Items().itemXuatHanh(listXuatHanh[2]),
                    flex: 1,
                  )
                : Container(),
          ],
        ),
        Container(
          color: Color(0xffF0F0F0),
          height: 6,
        ),
        Container(
          child: listTietKhi.length == 2
              ? LinearPercentIndicator(
                  alignment: MainAxisAlignment.center,
                  animation: true,
                  lineHeight: 2,
                  animationDuration: 200,
                  percent: percent,
                  //center: Text((percent *100).toString() +'%'),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: Colors.greenAccent,
                  leading: new Items().tietKhi(listTietKhi[0]),
                  trailing: new Items().tietKhi(
                    listTietKhi[1],
                  ),
                )
              : Center(
                  child: new Items().tietKhi(
                    listTietKhi[0],
                  ),
                ),
          padding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
        ),
        Container(
          color: Color(0xffF0F0F0),
          height: 6,
        ),
      ],
    );
  }
}
