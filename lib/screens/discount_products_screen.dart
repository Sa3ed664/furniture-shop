// lib/screens/discount_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../app_router.dart';
import '../widgets/product_card.dart';
import '../data/dummy_data.dart';

class DiscountProductsScreen extends StatelessWidget {
  const DiscountProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final discounted = DummyData.allProducts.where((p) => p.oldPrice != null).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Discounted Products')),
      body: discounted.isEmpty
          ? const Center(child: Text('No discounted products'))
          : AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: discounted.length,
          itemBuilder: (_, i) {
            final p = discounted[i];
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