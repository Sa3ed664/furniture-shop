// lib/screens/all_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../widgets/product_card.dart';
import '../data/dummy_data.dart';
import '../utils/colors.dart';
import '../app_router.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: DummyData.allProducts.length,
          itemBuilder: (_, i) {
            final p = DummyData.allProducts[i];
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