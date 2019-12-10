///
///Author: YoungChan
///Date: 2019-07-07 23:42:08
///LastEditors: YoungChan
///LastEditTime: 2019-07-16 19:50:28
///Description: file content
///
import 'package:flutter/material.dart';
import 'date_utils.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback onDateSelected;
  final DateTime date;
  final String dayOfWeek;
  final bool isDayOfWeek;
  final bool isSelected;

  ///是否选择时间范围
  final bool isDateRangeMode;

  /// 选择时间范围模式tile 的类型，0：选中时间， 1： 开始时间， 2：范围内时间， 3：结束时间   4:今天的日期
  final int dateRangeTileType;
  final TextStyle dayOfWeekStyles;
  final TextStyle dateStyles;
  final Widget child;
  final bool isToday;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyles,
    this.isDayOfWeek: false,
    this.isSelected: false,
    this.isDateRangeMode = false,
    this.dateRangeTileType = 0,
    this.isToday = false,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek) {
      return Container(
        alignment: Alignment.center,
        child: new Text(
          dayOfWeek,
          style: dayOfWeekStyles,
        ),
      );
    } else {
      var decoration = BoxDecoration();
      if (isToday) {
        decoration = BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFEEEEEE),
        );
      }
      if (isSelected) {
        if (isDateRangeMode) {
          switch (dateRangeTileType) {
            case 0:
              decoration = BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              );
              break;
            case 1:
              decoration = BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50)),
                color: Theme.of(context).primaryColor,
                border:
                    Border.all(width: 0, color: Theme.of(context).primaryColor),
              );
              break;
            case 2:
              decoration = BoxDecoration(
                color: Theme.of(context).primaryColor,
                border:
                    Border.all(width: 0, color: Theme.of(context).primaryColor),
              );
              break;
            case 3:
              decoration = BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
                color: Theme.of(context).primaryColor,
                border:
                    Border.all(width: 0, color: Theme.of(context).primaryColor),
              );
              break;
          }
        } else {
          decoration = BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          );
        }
      }

      return Container(
        decoration: decoration,
        alignment: Alignment.center,
        child: Text(
          DateUtils.formatDay(date).toString(),
          style: isSelected
              ? new TextStyle(color: Colors.white)
              : isToday
                  ? TextStyle(color: Theme.of(context).primaryColor)
                  : dateStyles,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onDateSelected,
      child: child != null
          ? child
          : new Container(
              child: renderDateOrDayOfWeek(context),
            ),
    );
  }
}
