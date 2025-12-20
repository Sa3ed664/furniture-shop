// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../app_router.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chip.dart';
import '../widgets/offer_banner.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import '../utils/colors.dart';
import '../controllers/wishlist_controller.dart';
import '../screens/product_detail_screen.dart';

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  bool showAllFeatured = false;
  bool showAllProducts = false;

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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AppBar و Categories و OfferBanner (زي ما كان)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, Guest', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const Text('Find your favorite furniture', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                CategoryChip(label: 'All', isSelected: showAllProducts, onTap: () => setState(() => showAllProducts = !showAllProducts)),
                CategoryChip(label: 'Bed', onTap: () => Get.toNamed(AppRoutes.categoryProducts, arguments: 'Bed')),
                CategoryChip(label: 'Chair', onTap: () => Get.toNamed(AppRoutes.categoryProducts, arguments: 'Chair')),
                CategoryChip(label: 'Sofa', onTap: () => Get.toNamed(AppRoutes.categoryProducts, arguments: 'Sofa')),
                CategoryChip(label: 'Storage', onTap: () => Get.toNamed(AppRoutes.categoryProducts, arguments: 'Storage')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const OfferBanner(),
          const SizedBox(height: 24),

          FutureBuilder<List<Product>>(
            future: _fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final products = snapshot.data ?? [];
              if (products.isEmpty) return const Center(child: Text('لا توجد منتجات'));
              final featured = products.take(showAllFeatured ? products.length : 4).toList();
              final otherProducts = products.skip(4).toList();

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Featured Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () => setState(() => showAllFeatured = !showAllFeatured),
                          child: Text(showAllFeatured ? 'Show Less' : 'View All'),
                        ),
                      ],
                    ),
                  ),
                  AnimationLimiter(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: featured.length,
                      itemBuilder: (_, i) {
                        final p = featured[i];
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
                  ),
                  if (showAllProducts)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('All Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        AnimationLimiter(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(12),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: otherProducts.length,
                            itemBuilder: (_, i) {
                              final p = otherProducts[i];
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
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}