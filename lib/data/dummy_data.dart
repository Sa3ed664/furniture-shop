// lib/data/dummy_data.dart
import '../models/product.dart';

class DummyData {
  static final List<Product> featured = [
    Product(
      id: '1',
      name: 'Wing Chair',
      category: 'Chair',
      price: 159.20,
      oldPrice: 199.00,
      image: 'assets/images/wing_chair.jpg',
    ),
    Product(
      id: '2',
      name: 'Modern Sofa',
      category: 'Sofa',
      price: 479.20,
      image: 'assets/images/modern_sofa.jpg',
    ),
  ];

  static final List<Product> allProducts = [
    ...featured,
    Product(
      id: '3',
      name: 'Natuzze Chair',
      category: 'Chair',
      price: 120.00,
      image: 'assets/images/natuzze.jpg',
    ),
    Product(
      id: '4',
      name: 'Arm Chair',
      category: 'Chair',
      price: 200.00,
      image: 'assets/images/arm_chair.jpg',
    ),
    Product(
      id: '5',
      name: 'Wooden Table',
      category: 'Table',
      price: 89.99,
      oldPrice: 129.99,
      image: 'assets/images/table.jpg',
    ),
    Product(
      id: '6',
      name: 'Queen Bed',
      category: 'Bed',
      price: 639.20,
      oldPrice: 699.00,
      image: 'assets/images/queen_bed.jpg',
    ),
  ];

  static final List<Product> offerProducts = [
    Product(
      id: '7',
      name: 'Luxury Sofa Set',
      category: 'Sofa',
      price: 1200.00,
      oldPrice: 1500.00,
      image: 'assets/images/luxury_sofa.jpg',
    ),
  ];
}