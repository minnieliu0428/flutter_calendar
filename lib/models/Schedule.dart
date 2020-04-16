import 'dart:ui';

class Schedule {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Schedule(this.eventName, this.from, this.to, this.background, this.isAllDay);
}
