///
///Author: YoungChan
///Date: 2019-07-07 23:42:08
///LastEditors: YoungChan
///LastEditTime: 2019-12-10 11:41:32
///Description: file content
///
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'calendar_tile.dart';
import 'date_utils.dart';

typedef DayBuilder(BuildContext context, DateTime day);

class Calendar extends StatefulWidget {
  ///单选时间回调
  final ValueChanged<DateTime> onDateSelected;

  ///多选时间回调
  final ValueChanged<Tuple2<DateTime, DateTime>> onDateRangeSelected;

  ///可选择日期范围变动通知
  final ValueChanged<Tuple2<DateTime, DateTime>> onRangeChange;

  /// 取消回调
  final VoidCallback onCancel;

  ///是否选择时间模范围式
  final bool isDateRangeMode;
  final bool isExpandable;
  final bool isExpanded;
  final DayBuilder dayBuilder;
  final bool showChevronsToChangeRange;
  final DateTime initialCalendarDateOverride;

  ///单选模式下默认选中的日期
  final DateTime selectedDate;

  ///范围模式下开始时间
  final DateTime startDate;

  ///范围模式下结束时间
  final DateTime endDate;
  Calendar(
      {this.onDateSelected,
      this.onDateRangeSelected,
      this.onRangeChange,
      this.onCancel,
      this.isDateRangeMode = false,
      this.isExpandable: false,
      this.isExpanded: false,
      this.dayBuilder,
      this.showChevronsToChangeRange: true,
      this.initialCalendarDateOverride,
      this.selectedDate,
      this.startDate,
      this.endDate});

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final calendarUtils = new DateUtils();
  DateTime today = new DateTime.now();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate;
  Tuple2<DateTime, DateTime> selectedRange;
  String currentMonth;
  bool isExpanded = false;
  DateTime displayMonth;

  DateTime get selectedDate => _selectedDate;

  ///时间范围选择，开始时间
  DateTime _startDate;

  ///时间范围选择，结束时间
  DateTime _endDate;

  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
    if (widget.initialCalendarDateOverride != null)
      today = widget.initialCalendarDateOverride;
    selectedMonthsDays = DateUtils.daysInMonth(today);
    var firstDayOfCurrentWeek = DateUtils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = DateUtils.lastDayOfWeek(today);
    selectedWeeksDays =
        DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
            .toList()
            .sublist(0, 7);
    _selectedDate = widget.selectedDate;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
    displayMonth = DateUtils.firstDayOfWeek(today);
  }

  Widget get nameAndIconRow {
    var leftOuterIcon;
    var rightOuterIcon;

    if (widget.showChevronsToChangeRange) {
      leftOuterIcon = new IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: RotatedBox(
          quarterTurns: 2,
          child: Icon(
            Icons.arrow_right,
            color: Colors.grey,
          ),
        ),
      );
      rightOuterIcon = new IconButton(
        onPressed: isExpanded ? nextMonth : nextWeek,
        icon: Icon(
          Icons.arrow_right,
          color: Colors.grey,
        ),
      );
    } else {
      leftOuterIcon = new Container();
      rightOuterIcon = new Container();
    }

    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox.fromSize(
          size: Size(70, 45),
          child: FlatButton(
            child: Text(
              '取消',
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              if (widget.onCancel != null) {
                widget.onCancel();
              }
            },
          ),
        ),
        Spacer(
          flex: 1,
        ),
        leftOuterIcon ?? new Container(),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            DateUtils.formatMonth(context, displayMonth),
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        rightOuterIcon ?? new Container(),
        Spacer(
          flex: 1,
        ),
        SizedBox.fromSize(
          size: Size(70, 45),
          child: FlatButton(
            child: Text(
              '完成',
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              _launchDateSelectionCallback();
            },
          ),
        ),
      ],
    );
  }

  Widget get calendarGridView {
    return new Container(
      child: new GestureDetector(
        onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
        onHorizontalDragUpdate: (gestureDetails) =>
            getDirection(gestureDetails),
        onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
        child: new GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          childAspectRatio: 1.5,
          addRepaintBoundaries: false,
          children: calendarBuilder(),
        ),
      ),
    );
  }

  bool _isToday(DateTime day) {
    var now = DateTime.now();
    return now.year == day.year && now.month == day.month && now.day == day.day;
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays =
        isExpanded ? selectedMonthsDays : selectedWeeksDays;

    DateUtils.weekdays(context).forEach(
      (day) {
        dayWidgets.add(
          new CalendarTile(
            isDayOfWeek: true,
            dayOfWeek: day,
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
      (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (DateUtils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }
        int tileType = 0;
        bool isSelected = false;
        if (widget.isDateRangeMode) {
          if (_startDate != null && _endDate != null) {
            isSelected =
                day.compareTo(_startDate) >= 0 && day.compareTo(_endDate) <= 0;
            if (day.compareTo(_startDate) == 0) {
              tileType = 1;
            } else if (day.compareTo(_endDate) == 0) {
              tileType = 3;
            } else {
              tileType = 2;
            }
          } else if (_startDate != null) {
            isSelected = day.compareTo(_startDate) == 0;
          } else {
            isSelected = false;
          }
        } else if (selectedDate != null) {
          isSelected = DateUtils.isSameDay(selectedDate, day);
        }
        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            CalendarTile(
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              isDateRangeMode: widget.isDateRangeMode,
              isSelected: isSelected,
              dateRangeTileType: tileType,
              child: this.widget.dayBuilder(context, day),
              isToday: _isToday(day),
            ),
          );
        } else {
          dayWidgets.add(
            CalendarTile(
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              date: day,
              dateStyles: configureDateStyle(monthStarted, monthEnded),
              isSelected: isSelected,
              dateRangeTileType: tileType,
              isDateRangeMode: widget.isDateRangeMode,
              isToday: _isToday(day),
            ),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    if (isExpanded) {
      dateStyles = monthStarted && !monthEnded
          ? new TextStyle(color: Colors.black)
          : new TextStyle(color: Colors.black38);
    } else {
      dateStyles = new TextStyle(color: Colors.black);
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(DateUtils.fullDayFormat(selectedDate)),
          new IconButton(
            iconSize: 20.0,
            padding: new EdgeInsets.all(0.0),
            onPressed: toggleExpanded,
            icon: isExpanded
                ? new Icon(Icons.arrow_drop_up)
                : new Icon(Icons.arrow_drop_down),
          ),
        ],
      );
    } else {
      return new Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          new ExpansionCrossFade(
            collapsed: calendarGridView,
            expanded: calendarGridView,
            isExpanded: isExpanded,
          ),
          expansionButtonRow
        ],
      ),
    );
  }

  void resetToToday() {
    today = new DateTime.now();
    var firstDayOfCurrentWeek = DateUtils.firstDayOfWeek(today);
    var lastDayOfCurrentWeek = DateUtils.lastDayOfWeek(today);

    setState(() {
      _selectedDate = today;
      selectedWeeksDays =
          DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = DateUtils.daysInMonth(today);
      displayMonth = DateUtils.firstDayOfMonth(today);
    });
  }

  void nextMonth() {
    setState(() {
      today = DateUtils.nextMonth(today);
      var firstDateOfNewMonth = DateUtils.firstDayOfMonth(today);
      var lastDateOfNewMonth = DateUtils.lastDayOfMonth(today);
      _onUpdateRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = DateUtils.daysInMonth(today);
      displayMonth = DateUtils.firstDayOfMonth(today);
    });
  }

  void previousMonth() {
    setState(() {
      today = DateUtils.previousMonth(today);
      var firstDateOfNewMonth = DateUtils.firstDayOfMonth(today);
      var lastDateOfNewMonth = DateUtils.lastDayOfMonth(today);
      _onUpdateRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = DateUtils.daysInMonth(today);
      displayMonth = DateUtils.firstDayOfMonth(today);
    });
  }

  void nextWeek() {
    setState(() {
      today = DateUtils.nextWeek(today);
      var firstDayOfCurrentWeek = DateUtils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = DateUtils.lastDayOfWeek(today);
      _onUpdateRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = DateUtils.firstDayOfWeek(today);
    });
  }

  void previousWeek() {
    setState(() {
      today = DateUtils.previousWeek(today);
      var firstDayOfCurrentWeek = DateUtils.firstDayOfWeek(today);
      var lastDayOfCurrentWeek = DateUtils.lastDayOfWeek(today);
      _onUpdateRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays =
          DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList()
              .sublist(0, 7);
      displayMonth = DateUtils.firstDayOfWeek(today);
    });
  }

  ///可选择日期的范围变动
  void _onUpdateRange(DateTime start, DateTime end) {
    selectedRange = new Tuple2<DateTime, DateTime>(start, end);
    if (widget.onRangeChange != null) {
      widget.onRangeChange(selectedRange);
    }
  }

  var gestureStart;
  var gestureDirection;
  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      if (isExpanded) {
        nextMonth();
      } else {
        nextWeek();
      }
    } else {
      if (isExpanded) {
        previousMonth();
      } else {
        previousWeek();
      }
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = DateUtils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = DateUtils.lastDayOfWeek(day);

    setState(() {
      if (widget.isDateRangeMode) {
        if (_startDate != null && _endDate == null) {
          if (day.isAfter(_startDate)) {
            _endDate = day;
          } else {
            _startDate = day;
          }
        } else {
          _startDate = day;
          _endDate = null;
        }
      } else {
        _selectedDate = day;
        selectedWeeksDays =
            DateUtils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
                .toList();
        selectedMonthsDays = DateUtils.daysInMonth(day);
      }
    });
  }

  void _launchDateSelectionCallback() {
    if (widget.isDateRangeMode) {
      if (widget.onDateRangeSelected != null) {
        widget.onDateRangeSelected(Tuple2(_startDate, _endDate ?? _startDate));
      }
    } else {
      if (widget.onDateSelected != null) {
        widget.onDateSelected(_selectedDate);
      }
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return new Flexible(
      flex: 1,
      child: new AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState:
            isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
