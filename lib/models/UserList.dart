import 'User.dart';

class UserList {
  List<User> users = new List();

  UserList({
    this.users
  });

  factory UserList.fromJson(List<dynamic> parsedJson) {

    List<User> users = new List<User>();

    users = parsedJson.map((i) => User.fromJson(i)).toList();

    return new UserList(
      users: users,
    );
  }
}