import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar/modal/lunar_days.dart';
import 'package:calendar/widget/timer_wigget.dart';

import '../items.dart';

class NgayGioTot extends StatelessWidget {
  final LunarDay lunarDay;
  final DateTime dateTime;

  const NgayGioTot({Key key, this.lunarDay, this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 338,
              margin: EdgeInsets.only(right: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 219,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Ngày ${lunarDay.day} Tháng ${lunarDay.month} (${lunarDay.isLunarLeap ? 'T' : 'Đ'}), Năm ${lunarDay.NameOfYear}',
                            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                        ),
                        lunarDay.ngayHoangDao != 0
                            ? Text(
                                lunarDay.ngayHoangDao == -1 ? 'Ngày Hắc Đạo' : 'Ngày Hoàng Đạo',
                                style: TextStyle(fontSize: 18),
                              )
                            : SizedBox(),
                        Text(
                          'Ngày: ${lunarDay.NameOfDay}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Container(
                          child: Text(
                            'Tháng: ${lunarDay.CanThang} ${lunarDay.ChiThang}',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 107,
                      child: Timers(
                        dateTime: dateTime,
                        listGoodHour: lunarDay.gioHoangDao,
                      ))
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            flex: 220,
          ),
          Expanded(
              flex: 125,
              child: Container(
                height: 338,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Giờ Hoàng Đạo',
                      style: TextStyle(fontSize: 14),
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(top: 0.0),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => new Items().goodHour(lunarDay.gioHoangDao[index], true),
                      itemCount: lunarDay.gioHoangDao.length,
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
