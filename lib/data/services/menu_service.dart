import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/menu_dto.dart';

class MenuService {
  static const _storageKey = 'warung_coto_menus';

  Future<List<MenuDto>> fetchMenus() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      jsonString = await rootBundle.loadString('assets/menu.json');
      await prefs.setString(_storageKey, jsonString);
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => MenuDto.fromJson(json)).toList();
  }

  Future<void> saveMenus(List<MenuDto> menus) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(menus.map((dto) => dto.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }
}
