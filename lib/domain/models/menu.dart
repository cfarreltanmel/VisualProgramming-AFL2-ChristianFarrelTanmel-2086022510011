class Menu {
  final String id;
  final String name;
  final int price;
  final String category;
  final String? note;

  const Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.note,
  });

  Menu copyWith({
    String? id,
    String? name,
    int? price,
    String? category,
    String? note,
  }) {
    return Menu(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }
}
