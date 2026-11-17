import '../../domain/models/menu.dart';
import '../../domain/repositories/menu_repository.dart';
import '../services/menu_service.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuService _service;

  final List<Menu> _menus = [];
  bool _isInitialized = false;

  MenuRepositoryImpl(this._service);

  @override
  Future<List<Menu>> getMenus() async {
    if (!_isInitialized) {
      final dtos = await _service.fetchMenus();
      _menus.addAll(dtos.map((dto) => dto.toEntity()));
      _isInitialized = true;
    }
    return List.unmodifiable(_menus);
  }

  @override
  Future<void> addMenu(Menu menu) async {
    _menus.add(menu);
  }

  @override
  Future<void> updateMenu(Menu menu) async {
    final index = _menus.indexWhere((item) => item.id == menu.id);
    if (index != -1) {
      _menus[index] = menu;
    }
  }

  @override
  Future<void> deleteMenu(String id) async {
    _menus.removeWhere((item) => item.id == id);
  }
}
