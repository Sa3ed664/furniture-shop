// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../utils/colors.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final int index;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 600),
      columnCount: 2,
      child: ScaleAnimation(
        scale: 0.9,
        child: FadeInAnimation(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // ==================== (بداية التعديل) ====================
                      Hero(
                        tag: 'product-${product.id}',
                        child: ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                          // 1. ضيف Container عشان الخلفية
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            color: Colors.grey.shade100, // <-- خلفية شيك
                            child: Image.asset(
                              product.image,
                              // 2. غيّر دي لـ contain
                              fit: BoxFit.contain, // <-- الحل لمشكلة القص
                              errorBuilder: (_, __, ___) => Container(
                                height: 100,
                                color: Colors.grey[200],
                                child: const Icon(Icons.chair,
                                    size: 40, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // ==================== (نهاية التعديل) ====================
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Obx(() {
                          final wishlist = Get.find<WishlistController>();
                          final isWishlisted =
                          wishlist.isWishlisted(product.id);

                          return IconButton(
                            icon: Icon(
                              isWishlisted
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isWishlisted ? Colors.red : Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              wishlist.toggle(product);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          );
                        }),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(product.category,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.textLight)),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (product.oldPrice != null)
                                  Text(
                                      '\$${product.oldPrice!.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                          decoration:
                                          TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 9)),
                                Text(
                                    '\$${product.effectivePrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.find<CartController>().addItem(product);
                              },
                              child: const Icon(Icons.shopping_cart_outlined,
                                  color: AppColors.primary, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}