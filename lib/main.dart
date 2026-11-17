import 'package:flutter/material.dart';

import 'core/core.dart';
import 'data/repositories/menu_repository_impl.dart';
import 'data/services/menu_service.dart';
import 'viewmodels/menu_viewmodel.dart';
import 'views/menu_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final menuService = MenuService();
  final menuRepository = MenuRepositoryImpl(menuService);
  final menuViewModel = MenuViewModel(menuRepository)..loadMenus();

  runApp(WarungCotoApp(viewModel: menuViewModel));
}

class WarungCotoApp extends StatelessWidget {
  final MenuViewModel viewModel;

  const WarungCotoApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MenuView(viewModel: viewModel),
    );
  }
}
