library nccalendar;

///
///Author: YoungChan
///Date: 2019-07-08 01:56:23
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 11:37:55
///Description: 选择日期，支持多项选择
///
import 'flutter_calendar.dart';
import 'package:flutter/material.dart';

class NCCalendar extends StatelessWidget {
  ///范围选择模式的回调
  final void Function(DateTime, DateTime) onDateRangeSelected;

  ///单选模式的回调
  final void Function(DateTime) onDateSelected;

  ///是否范围选择模式
  final bool isDateRangeMode;

  ///默认选择的日期
  final DateTime selectedDate;

  ///默认选择范围的开始时间
  final DateTime startDate;

  ///默认选择范围的结束时间
  final DateTime endDate;

  ///取消回调
  final VoidCallback onCancel;
  NCCalendar(
      {this.onDateRangeSelected,
      this.onDateSelected,
      this.onCancel,
      this.isDateRangeMode = false,
      this.selectedDate,
      this.startDate,
      this.endDate});

  @override
  Widget build(BuildContext context) {
    return Calendar(
      showChevronsToChangeRange: true,
      isExpandable: false,
      isExpanded: true,
      isDateRangeMode: isDateRangeMode,
      onCancel: onCancel,
      onDateRangeSelected: (range) {
        if (onDateRangeSelected != null) {
          onDateRangeSelected(range.item1, range.item2);
        }
      },
      onDateSelected: (selectDate) {
        if (onDateSelected != null) {
          onDateSelected(selectDate);
        }
      },
      onRangeChange: (range) {},
      selectedDate: selectedDate,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
