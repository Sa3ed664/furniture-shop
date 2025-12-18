// lib/screens/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../app_router.dart';
import '../widgets/product_card.dart';
import '../data/dummy_data.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final results = DummyData.allProducts
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Results for "$query"')),
      body: results.isEmpty
          ? const Center(child: Text('No products found'))
          : AnimationLimiter(
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