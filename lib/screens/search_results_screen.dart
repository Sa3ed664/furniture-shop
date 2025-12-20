// lib/screens/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  Future<List<Product>> _search() async {
    if (query.isEmpty) return [];

    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .ilike('name', '%$query%')
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
      appBar: AppBar(title: Text('نتائج البحث عن "$query"')),
      body: FutureBuilder<List<Product>>(
        future: _search(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final results = snapshot.data ?? [];

          if (results.isEmpty) {
            return const Center(child: Text('لم يتم العثور على منتجات'));
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
              itemCount: results.length,
              itemBuilder: (_, i) {
                final p = results[i];
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