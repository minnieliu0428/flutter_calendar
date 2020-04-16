class User{
  String account;
  String password;
  String name;
  String phone;

  User({this.account, this.password, this.name, this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User(
        account: json['account'],
        password: json['password'],
        name: json['name'],
        phone: json['phone']);
  }
}