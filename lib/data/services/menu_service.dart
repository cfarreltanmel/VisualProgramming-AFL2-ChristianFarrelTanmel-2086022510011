import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/menu_dto.dart';

class MenuService {
  Future<List<MenuDto>> fetchMenus() async {
    final jsonString = await rootBundle.loadString('assets/menu.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => MenuDto.fromJson(json)).toList();
  }
}
