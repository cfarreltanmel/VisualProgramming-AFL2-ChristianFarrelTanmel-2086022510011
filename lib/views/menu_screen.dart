import 'package:flutter/material.dart';

import '../core/core.dart';
import '../domain/models/menu.dart';
import '../viewmodels/menu_viewmodel.dart';
import 'widgets/delete_confirmation_dialog.dart';
import 'widgets/menu_card.dart';
import 'widgets/menu_form_dialog.dart';

class MenuView extends StatelessWidget {
  final MenuViewModel viewModel;

  const MenuView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: viewModel.loadMenus,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (viewModel.menus.isEmpty) {
            return const Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Belum ada menu yang di tambahkan. Tekan + untuk menambahkan.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: viewModel.menus.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final menu = viewModel.menus[index];
              return MenuCard(
                menu: menu,
                onEdit: () => _openMenuForm(context, existingMenu: menu),
                onDelete: () => _confirmDelete(context, menu),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openMenuForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openMenuForm(BuildContext context, {Menu? existingMenu}) async {
    await showDialog<void>(
      context: context,
      builder: (_) => MenuFormDialog(
        existingMenu: existingMenu,
        onSubmit:
            ({
              required String name,
              required int price,
              required String category,
              String? note,
            }) async {
              if (existingMenu != null) {
                await viewModel.updateMenu(
                  existingMenu.copyWith(
                    name: name,
                    price: price,
                    category: category,
                    note: note,
                  ),
                );
              } else {
                await viewModel.addMenu(
                  name: name,
                  price: price,
                  category: category,
                  note: note,
                );
              }
            },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Menu menu) async {
    await showDialog<void>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        itemName: menu.name,
        onConfirm: () => viewModel.deleteMenu(menu.id),
      ),
    );
  }
}
