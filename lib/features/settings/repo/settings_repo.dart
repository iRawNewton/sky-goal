import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../model/settings_model.dart';

class SettingsRepo {
  Future<List<SettingsModel>> loadSettings() async {
    final jsonString = await rootBundle.loadString('assets/json/settings.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList.map((json) => SettingsModel.fromJson(json)).toList();
  }
}
