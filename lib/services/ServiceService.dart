import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/ServiceList.dart';

class ServiceService {

  Future<String> _loadRecordsAsset() async {
    return await rootBundle.loadString('assets/data/services.json');
  }

  Future<ServiceList> loadRecords() async {
    String jsonString = await _loadRecordsAsset();
    final jsonResponse = json.decode(jsonString);
    ServiceList services = new ServiceList.fromJson(jsonResponse);
    return services;
  }
}