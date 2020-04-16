import 'package:flutter/material.dart';
import 'package:flutter_calendar/common/Constants.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import '../common/ValueUtil.dart';
import '../models/Schedule.dart';

class CalendarPage extends StatefulWidget {
  final int money;
  final int hours;
  final int minutes;
  final String userName;

  CalendarPage({Key key, this.money, this.hours, this.minutes, this.userName})
      : super(key: key);

  @override
  _CalendarPageState createState() =>
      _CalendarPageState(money, hours, minutes, userName);
}

class _CalendarPageState extends State<CalendarPage> {
  final int money;
  final int hours;
  final int minutes;
  final String userName;

  _CalendarPageState(this.money, this.hours, this.minutes, this.userName);

  Widget _appBarTitle = new Text(calendarpageTitle);

  DateTime _selectedDate = DateTime.now();
  List<String> _times = [
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18'
  ];
  String _selectedTime;
  List<Schedule> _schedules = <Schedule>[];

  @override
  void initState() {
    super.initState();
    _getDataSource();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(
            _selectedDate.year, _selectedDate.month, _selectedDate.day),
        lastDate: DateTime(
            _selectedDate.year + 1, _selectedDate.month, _selectedDate.day));
    if (picked != null)
      setState(() {
        _selectedDate = picked;
        //_setTimePicker();
      });
  }

  void _addData() {
    int time = int.parse(_selectedTime);
    final DateTime startTime = DateTime(
        _selectedDate.year, _selectedDate.month, _selectedDate.day, time, 0, 0);
    DateTime endTime = startTime;
    if (!ValueUtil.intIsNullOrZero(hours)) {
      endTime = endTime.add(new Duration(hours: hours));
    }
    if (!ValueUtil.intIsNullOrZero(minutes)) {
      endTime = endTime.add(new Duration(minutes: minutes));
    }
    setState(() {
      _schedules
          .add(Schedule(userName, startTime, endTime, appYellowColor, false));
    });
  }

  void _getDataSource() {
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(new Duration(hours: 2));
    setState(() {
      _schedules
          .add(Schedule('Mickey', startTime, endTime, Colors.grey, false));
    });
  }

//  void _setTimePicker() {
//    var formatter = new DateFormat('yyyy-MM-dd');
//    var selectedDateStr = formatter.format(_selectedDate);
//    List<Schedule> scheduleList = _schedules
//        .where((schedule) => formatter.format(schedule.from) == selectedDateStr)
//        .toList();
//    List<String> isSelected = [];
//    for (int i = 0; i < scheduleList.length; i++) {
//      var schedule = scheduleList[i];
//      int from = schedule.from.hour;
//      int to = 0;
//      if (schedule.to.minute > 0) {
//        to = schedule.to.hour + 1;
//      } else {
//        to = schedule.to.hour;
//      }
//
//      for (int j = from; j <= to; j++) {
//        isSelected.add(j.toString());
//      }
//    }
//    setState(() {
//      _times.remove(isSelected);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    Widget _buildBar(BuildContext context) {
      return new AppBar(
          elevation: 0.1,
          backgroundColor: appYellowColor,
          centerTitle: true,
          title: _appBarTitle);
    }

    var totalCostAndTime = new Text(
      "總消費金額：$money元, 預估時長：$hours小時$minutes分鐘",
      style: TextStyle(color: appBlackGrayColor, fontSize: bodyTextSize),
    );

    final datePickerBtn = new IconButton(
      icon: Icon(Icons.event_note),
      color: appYellowColor,
      onPressed: () => _selectDate(context),
    );

    final datePickerGroup = new Row(
      children: <Widget>[
        new Text(
          "預約日期：${_selectedDate.toLocal()}".split(' ')[0],
          style:
              new TextStyle(fontSize: bodyTextSize, color: appBlackGrayColor),
        ),
        datePickerBtn
      ],
    );

    final timeDropDown = new DropdownButton(
      hint: Text('請選擇時間'),
      value: _selectedTime,
      onChanged: (newValue) {
        setState(() {
          _selectedTime = newValue;
        });
      },
      items: _times.map((time) {
        return DropdownMenuItem(
          child: new Text(
            time,
            style:
                new TextStyle(fontSize: bodyTextSize, color: appBlackGrayColor),
          ),
          value: time,
        );
      }).toList(),
    );

    final timePickerGroup = new Row(
      children: <Widget>[
        new Text(
          "預約開始時間：",
          style:
              new TextStyle(fontSize: bodyTextSize, color: appBlackGrayColor),
        ),
        timeDropDown
      ],
    );

    final saveButton = new RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () => _selectedTime == null ? null : _addData(),
        color: _selectedTime == null ? Colors.grey : appYellowColor,
        child: new Text(
          '新增預約',
          style:
              new TextStyle(fontSize: bodyTextSize, color: appBlackGrayColor),
        ));

    final saveButtonGroup = new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[saveButton],
    );

    final calendar = new Expanded(
        child: new SfCalendar(
      backgroundColor: Colors.white,
      view: CalendarView.workWeek,
      dataSource: ScheduleDataSource(_schedules),
      timeSlotViewSettings:
          TimeSlotViewSettings(startHour: 9, endHour: 18, nonWorkingDays: <int>[
        DateTime.saturday,
        DateTime.sunday,
      ]),
    ));

    return Scaffold(
        appBar: _buildBar(context),
        backgroundColor: appPinkGrayColor,
        body: Container(
          margin: new EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              totalCostAndTime,
              SizedBox(height: spaceHeight),
              datePickerGroup,
              timePickerGroup,
              saveButtonGroup,
              SizedBox(height: spaceHeight),
              calendar
            ],
          ),
        ));
  }
}

class ScheduleDataSource extends CalendarDataSource {
  ScheduleDataSource(this.source);

  List<Schedule> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }
}
