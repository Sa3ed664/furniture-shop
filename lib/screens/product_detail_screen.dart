// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart'; // <-- 1. ضيف الـ import ده
import '../models/product.dart';
import '../utils/colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // 2. اعمل find للـ WishlistController مرة واحدة
  final WishlistController _wishlistController = Get.find<WishlistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== (بداية تعديل الصورة) ====================
            Hero(
              tag: 'product-${widget.product.id}',
              child: Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey.shade100, // <-- خلفية فاتحة للصورة
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.contain, // <-- الصورة كاملة
                  errorBuilder: (_, __, ___) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Icon(Icons.chair, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),
            // ==================== (نهاية تعديل الصورة) ====================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================== (بداية تعديل أيقونة القلب) ====================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(widget.product.name,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      Obx(() {
                        // 3. نراقب حالة الـ wishlist
                        final isWishlisted =
                        _wishlistController.isWishlisted(widget.product.id);
                        return IconButton(
                          icon: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isWishlisted ? Colors.red : Colors.grey,
                            size: 28, // حجم أكبر عشان تبقى واضحة
                          ),
                          onPressed: () {
                            _wishlistController.toggle(widget.product);
                          },
                        );
                      }),
                    ],
                  ),
                  // ==================== (نهاية تعديل أيقونة القلب) ====================
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (widget.product.oldPrice != null)
                        Text('\$${widget.product.oldPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey)),
                      const SizedBox(width: 8),
                      Text('\$${widget.product.effectivePrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('High-quality furniture with modern design. Perfect for any home.'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.find<CartController>().addItem(widget.product);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Add to Cart',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}