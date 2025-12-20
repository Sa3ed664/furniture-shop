// lib/screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late Future<List<Product>> _wishlistFuture;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  void _loadWishlist() {
    setState(() {
      _wishlistFuture = _fetchWishlistProducts();
    });
  }

  Future<List<Product>> _fetchWishlistProducts() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];

    try {
      final response = await Supabase.instance.client
          .from('favorites')
          .select('product_id')
          .eq('user_id', user.id);

      final List<String> productIds = response.map((e) => e['product_id'] as String).toList();

      if (productIds.isEmpty) return [];

      final productsResponse = await Supabase.instance.client
          .from('products')
          .select()
          .or(productIds.map((id) => 'id.eq.$id').join(','));

      return productsResponse.map<Product>((data) => Product(
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
      appBar: AppBar(
        title: const Text('المفضلة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWishlist,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadWishlist(),
        child: FutureBuilder<List<Product>>(
          future: _wishlistFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final products = snapshot.data ?? [];

            if (products.isEmpty) {
              return const Center(child: Text('المفضلة فارغة'));
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
      ),
    );
  }
}