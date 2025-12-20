// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/auth_controller.dart';
import '../utils/colors.dart';
import 'checkout_screen.dart';
import 'login_screen.dart';

class CartScreenContent extends StatelessWidget {
  const CartScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final AuthController auth = Get.find<AuthController>();

    return Obx(() {
      final items = cartController.items;

      if (items.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'عربة التسوق فارغة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'ابدأ التسوق وأضف منتجاتك المفضلة',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            item.product.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.product.effectivePrice.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => cartController.updateQuantity(item.product.id, -1),
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.grey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                              child: Obx(() => Text('${item.quantity.value}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                            ),
                            IconButton(
                              onPressed: () => cartController.updateQuantity(item.product.id, 1),
                              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => cartController.removeItem(item.product.id),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Checkout Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
            ),
            child: Column(
              children: [
                _buildPriceRow('الإجمالي الفرعي', cartController.subtotal),
                _buildPriceRow('الخصم (10%)', -cartController.discount, isDiscount: true),
                const Divider(height: 20, thickness: 1),
                _buildPriceRow('الإجمالي', cartController.total, isTotal: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!auth.isAuthenticated.value) {
                        // لو مش مسجل دخول → روح للوجين، وبعد الرجوع نشوف لو سجل دخول نروح Checkout
                        Get.to(() => const LoginScreen())?.then((_) {
                          if (auth.isAuthenticated.value) {
                            Get.to(() => const CheckoutScreen());
                          } else {
                            Get.snackbar('مطلوب تسجيل الدخول', 'يرجى تسجيل الدخول للمتابعة إلى الدفع');
                          }
                        });
                      } else {
                        // لو مسجل دخول → روح مباشرة للـ Checkout
                        Get.to(() => const CheckoutScreen());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text(
                      'المتابعة للدفع',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: isTotal ? 18 : 16, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            '${isDiscount ? '-' : ''}\$${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: isDiscount ? Colors.green[600] : (isTotal ? AppColors.primary : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}