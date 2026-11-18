import 'package:flutter/material.dart';

import '../../domain/models/menu.dart';

class MenuFormDialog extends StatefulWidget {
  final Menu? existingMenu;
  final Future<void> Function({
    required String name,
    required int price,
    required String category,
    String? note,
  })
  onSubmit;

  const MenuFormDialog({super.key, this.existingMenu, required this.onSubmit});

  @override
  State<MenuFormDialog> createState() => _MenuFormDialogState();
}

class _MenuFormDialogState extends State<MenuFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _categoryController;
  late final TextEditingController _noteController;

  bool get _isEditing => widget.existingMenu != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingMenu?.name ?? '',
    );
    _priceController = TextEditingController(
      text: widget.existingMenu != null
          ? widget.existingMenu!.price.toString()
          : '',
    );
    _categoryController = TextEditingController(
      text: widget.existingMenu?.category ?? '',
    );
    _noteController = TextEditingController(
      text: widget.existingMenu?.note ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fields = <Widget>[
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(labelText: 'Nama menu'),
        validator: (value) => (value == null || value.trim().isEmpty)
            ? 'Nama menu diperlukan'
            : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _priceController,
        decoration: const InputDecoration(labelText: 'Harga (Rp)'),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Harga di perlukan';
          }
          final parsed = int.tryParse(value.trim());
          if (parsed == null || parsed <= 0) {
            return 'Masukan harga yang valid';
          }
          return null;
        },
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _categoryController,
        decoration: const InputDecoration(
          labelText: 'Kategori',
          hintText: 'Cth: makanan, minuman, sampingan',
        ),
        validator: (value) => (value == null || value.trim().isEmpty)
            ? 'Kategori wajib di isi!'
            : null,
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _noteController,
        maxLines: 2,
        decoration: const InputDecoration(labelText: 'Catatan (Opsional)'),
      ),
    ];

    return AlertDialog(
      title: Text(
        _isEditing ? 'Ubah Menu' : 'Tambah Menu',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: fields.length,
            itemBuilder: (_, index) => fields[index],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final noteText = _noteController.text.trim();
            await widget.onSubmit(
              name: _nameController.text.trim(),
              price: int.parse(_priceController.text.trim()),
              category: _categoryController.text.trim(),
              note: noteText.isNotEmpty ? noteText : null,
            );

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Text(_isEditing ? 'Simpan' : 'Tambahkan'),
        ),
      ],
    );
  }
}
