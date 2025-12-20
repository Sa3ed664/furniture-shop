// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../models/product.dart';
import '../utils/colors.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? product;
  bool isLoading = true;
  String? errorMessage;
  final WishlistController _wishlistController = Get.find<WishlistController>();

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    // دايمًا نفترض إن الـ arguments هو Product كامل (لأن كل الشاشات بتبعته كده)
    if (Get.arguments is Product) {
      product = Get.arguments as Product;
    } else {
      // fallback لو جاء ID أو أي حاجة تانية
      errorMessage = 'المنتج غير موجود';
    }

    if (mounted) {
      setState(() => isLoading = false);

      if (errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.snackbar('خطأ', errorMessage!);
          Get.back();
        });
      }
    }
  }

  Future<void>fetchProductFromSupabase(String id) async {
    final response = await Supabase.instance.client
        .from('products')
        .select()
        .eq('id', id)
        .single();

    product = Product(
      id: response['id'],
      name: response['name'],
      category: response['category'],
      price: (response['price'] as num).toDouble(),
      oldPrice: response['old_price'] != null ? (response['old_price'] as num).toDouble() : null,
      image: response['image'],
      discountedPrice: response['discounted_price'] != null ? (response['discounted_price'] as num).toDouble() : null,
    );
  }

  double get effectivePrice {
    return product!.discountedPrice ?? product!.price;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: AppColors.background, elevation: 0),
        body: const Center(child: Text('المنتج غير موجود')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-${product!.id}',
              child: Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Image.asset(
                  product!.image,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 300,
                    color: Colors.grey[200],
                    child: const Icon(Icons.chair, size: 80, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product!.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Obx(() {
                        final isWishlisted = _wishlistController.isWishlisted(product!.id);
                        return IconButton(
                          icon: Icon(
                            isWishlisted ? Icons.favorite : Icons.favorite_border,
                            color: isWishlisted ? Colors.red : Colors.grey,
                            size: 28,
                          ),
                          onPressed: () {
                            _wishlistController.toggle(product!);
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (product!.oldPrice != null)
                        Text(
                          '\$${product!.oldPrice!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      if (product!.oldPrice != null) const SizedBox(width: 8),
                      Text(
                        '\$${effectivePrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('High-quality furniture with modern design. Perfect for any home.'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.find<CartController>().addItem(product!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(color: Colors.white),
                      ),
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