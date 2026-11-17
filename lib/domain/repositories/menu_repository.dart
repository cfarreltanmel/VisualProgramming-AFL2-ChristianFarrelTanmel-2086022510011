import '../models/menu.dart';

abstract interface class MenuRepository {
  Future<List<Menu>> getMenus();
  Future<void> addMenu(Menu menu);
  Future<void> updateMenu(Menu menu);
  Future<void> deleteMenu(String id);
}
