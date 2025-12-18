import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../controllers/orders_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';

class UserStats extends StatelessWidget {
  const UserStats({super.key});

  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // جلب جميع الـ Controllers
    final ordersController = Get.find<OrdersController>();
    final cartController = Get.find<CartController>();
    final wishlistController = Get.find<WishlistController>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // ربط عدد الطلبات
            _buildStatItem(ordersController.orderCount.value.toString(), 'Orders'),

            // ربط عدد عناصر العربة
            // تم التعديل: استخدام itemCount بدلاً من cartItemCount.value
            _buildStatItem(cartController.itemCount.toString(), 'Cart'), // **تم الإصلاح**

            // ربط عدد عناصر المفضلة
            // تم التعديل: استخدام itemCount بدلاً من wishlistCount.value
            _buildStatItem(wishlistController.itemCount.toString(), 'Wishlist'), // **تم الإصلاح**
          ],
        ),
      ),
    );
  }
}
