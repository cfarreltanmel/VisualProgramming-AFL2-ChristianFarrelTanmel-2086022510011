import '../../domain/models/menu.dart';

class MenuDto {
  final String id;
  final String name;
  final int price;
  final String category;
  final String? note;

  const MenuDto({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.note,
  });

  factory MenuDto.fromJson(Map<String, dynamic> json) {
    return MenuDto(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      category: json['category'] as String,
      note: json['note'] as String?,
    );
  }

  factory MenuDto.fromEntity(Menu entity) {
    return MenuDto(
      id: entity.id,
      name: entity.name,
      price: entity.price,
      category: entity.category,
      note: entity.note,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'note': note,
    };
  }

  Menu toEntity() {
    return Menu(
      id: id,
      name: name,
      price: price,
      category: category,
      note: note,
    );
  }
}
