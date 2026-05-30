import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveList(
      String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
      key,
      data.map((e) => jsonEncode(e)).toList(),
    );
  }

  static Future<List<dynamic>> loadList(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(key);

    if (data == null) return [];

    return data.map((e) => jsonDecode(e)).toList();
  }
}