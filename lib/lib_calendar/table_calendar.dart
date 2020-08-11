//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

library table_calendar;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:calendar/modal/item_xuat_hanh.dart';
import 'package:calendar/modal/lunar_days.dart';
import 'package:calendar/modal/tiet_khi.dart';
import 'package:calendar/modal/tuoi_xung_model.dart';
import 'package:calendar/widget/items.dart';
import 'package:calendar/widget/week_widget.dart';
import 'package:intl/intl.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:calendar/modal/event_in_year.dart';
import 'package:calendar/convert_solar_lunar/lunar_solar_converter.dart';
import 'package:rect_getter/rect_getter.dart';

part 'src/calendar.dart';

part 'src/calendar_customs.dart';

part 'src/calendar_controller.dart';

part 'src/customization/calendar_builders.dart';

part 'src/customization/calendar_style.dart';

part 'src/customization/days_of_week_style.dart';

part 'src/customization/header_style.dart';

part 'src/widgets/cell_widget.dart';

part 'src/widgets/custom_icon_button.dart';
