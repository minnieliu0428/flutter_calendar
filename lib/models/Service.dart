class Service {
  int id;
  String title;
  int cost;
  int hour;
  int minute;
  bool isCheck;

  Service(
      {this.id, this.title, this.cost, this.hour, this.minute, this.isCheck});

  factory Service.fromJson(Map<String, dynamic> json) {
    return new Service(
        id: json['id'],
        title: json['title'],
        cost: json['cost'],
        hour: json['hour'],
        minute: json['minute'],
        isCheck: false);
  }
}
