// lib/models/product.dart
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String image;
  final double? discountedPrice;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.image,
    this.discountedPrice,
  });

  // نسخة معدلة
  Product copyWith({double? discountedPrice}) {
    return Product(
      id: id,
      name: name,
      category: category,
      price: price,
      oldPrice: oldPrice,
      image: image,
      discountedPrice: discountedPrice ?? this.discountedPrice,
    );
  }

  // السعر الفعلي
  double get effectivePrice => discountedPrice ?? price;

  // هل في خصم؟
  bool get hasDiscount => oldPrice != null || discountedPrice != null;
}