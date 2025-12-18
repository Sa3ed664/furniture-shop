// lib/screens/category_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../app_router.dart';
import '../widgets/product_card.dart';
import '../data/dummy_data.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;
  const CategoryProductsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final products = DummyData.allProducts.where((p) => p.category == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: products.isEmpty
          ? const Center(child: Text('No products in this category'))
          : AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) {
            final p = products[i];
            return AnimationConfiguration.staggeredGrid(
              position: i,
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.9,
                child: FadeInAnimation(
                  child: ProductCard(
                    product: p,
                    index: i,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: p),
                    // onFavorite: ... ← احذف السطر ده
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}