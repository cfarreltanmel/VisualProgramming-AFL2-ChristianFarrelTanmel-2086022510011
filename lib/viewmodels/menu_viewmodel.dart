import 'package:flutter/foundation.dart';

import '../../domain/models/menu.dart';
import '../../domain/repositories/menu_repository.dart';

class MenuViewModel extends ChangeNotifier {
  final MenuRepository _repository;

  MenuViewModel(this._repository);

  List<Menu> _menus = [];
  List<Menu> get menus => _menus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadMenus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _menus = await _repository.getMenus();
    } catch (e) {
      _errorMessage = 'Failed to load menus: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMenu({
    required String name,
    required int price,
    required String category,
    String? note,
  }) async {
    try {
      _errorMessage = null;
      final newMenu = Menu(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name.trim(),
        price: price,
        category: category.trim(),
        note: (note != null && note.trim().isNotEmpty) ? note.trim() : null,
      );

      await _repository.addMenu(newMenu);
      _menus = await _repository.getMenus();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add menu: $e';
      notifyListeners();
    }
  }

  Future<void> updateMenu(Menu updatedMenu) async {
    try {
      _errorMessage = null;
      await _repository.updateMenu(updatedMenu);
      _menus = await _repository.getMenus();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update menu: $e';
      notifyListeners();
    }
  }

  Future<void> deleteMenu(String id) async {
    try {
      _errorMessage = null;
      await _repository.deleteMenu(id);
      _menus = await _repository.getMenus();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete menu: $e';
      notifyListeners();
    }
  }
}
