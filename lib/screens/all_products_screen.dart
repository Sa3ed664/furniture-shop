// lib/screens/all_products_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import '../utils/colors.dart';
import '../screens/product_detail_screen.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  Future<List<Product>> _fetchProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .order('name');

      return response.map<Product>((data) => Product(
        id: data['id'] as String,
        name: data['name'] as String,
        category: data['category'] as String,
        price: (data['price'] as num).toDouble(),
        oldPrice: data['old_price'] != null ? (data['old_price'] as num).toDouble() : null,
        image: data['image'] as String,
        discountedPrice: data['discounted_price'] != null ? (data['discounted_price'] as num).toDouble() : null,
      )).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('كل المنتجات'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('لا توجد منتجات'));
          }

          return AnimationLimiter(
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
                        onTap: () => Get.to(() => const ProductDetailScreen(), arguments: p),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}