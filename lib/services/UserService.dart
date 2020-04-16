import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/UserList.dart';

class UserService {

  Future<String> _loadRecordsAsset() async {
    return await rootBundle.loadString('assets/data/users.json');
  }

  Future<UserList> loadRecords() async {
    String jsonString = await _loadRecordsAsset();
    final jsonResponse = json.decode(jsonString);
    UserList services = new UserList.fromJson(jsonResponse);
    return services;
  }
}