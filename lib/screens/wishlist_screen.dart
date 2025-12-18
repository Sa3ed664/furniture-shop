// lib/screens/wishlist_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // <-- ضيف Get
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../controllers/wishlist_controller.dart'; // <-- ضيف الكنترولر
import '../widgets/product_card.dart';
import '../app_router.dart';
// import 'package:provider/provider.dart'; // <-- امسح Provider
// import '../providers/wishlist_provider.dart'; // <-- امسح Provider

class WishlistScreenContent extends StatelessWidget {
  const WishlistScreenContent({super.key});

  // (ملحوظة: الخطأ اللي فات اتصلح)
  // مينفعش نعمل Get.find() هنا

  @override
  Widget build(BuildContext context) {
    // 1. هات الـ controller بتاعك جوه الـ build
    final WishlistController wishlist = Get.find<WishlistController>();

    // 2. استخدم Obx عشان تراقب القايمة
    return Obx(() {
      final items = wishlist.items;

      if (items.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text('Your wishlist is empty', style: TextStyle(fontSize: 18)),
            ],
          ),
        );
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
          itemCount: items.length,
          itemBuilder: (_, i) {
            final p = items[i];
            return AnimationConfiguration.staggeredGrid(
              position: i,
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.9,
                child: FadeInAnimation(
                  child: ProductCard(
                    product: p,
                    index: i,
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.productDetail,
                        arguments: p),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}