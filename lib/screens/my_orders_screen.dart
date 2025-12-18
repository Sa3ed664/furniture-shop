// lib/screens/my_orders_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/colors.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  final List<Map<String, dynamic>> dummyOrders = const [
    {
      'id': 'ORD-1234',
      'date': '2025-11-28',
      'status': 'Delivered',
      'total': 899.99,
      'items': 3,
    },
    {
      'id': 'ORD-1235',
      'date': '2025-12-01',
      'status': 'Processing',
      'total': 159.20,
      'items': 1,
    },
    {
      'id': 'ORD-1236',
      'date': '2025-12-04',
      'status': 'Shipped',
      'total': 479.20,
      'items': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    // لو مش مسجل دخول → ارجع واعرض رسالة
    if (!auth.isLoggedIn.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back();
        Get.snackbar('غير مسموح', 'برجاء تسجيل الدخول لرؤية طلباتك',
            backgroundColor: Colors.orange, colorText: Colors.white);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: dummyOrders.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No orders yet', style: TextStyle(fontSize: 18)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyOrders.length,
        itemBuilder: (context, index) {
          final order = dummyOrders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text('Order #${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('${order['date']} • ${order['items']} items'),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: order['status'] == 'Delivered'
                          ? Colors.green.withOpacity(0.2)
                          : order['status'] == 'Processing'
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order['status'],
                      style: TextStyle(
                        color: order['status'] == 'Delivered'
                            ? Colors.green[700]
                            : order['status'] == 'Processing'
                            ? Colors.orange[700]
                            : Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Text(
                '\$${order['total'].toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              onTap: () {
                // تفاصيل الطلب (ممكن تضيف صفحة بعدين)
                Get.snackbar('Order Details', 'Coming soon!');
              },
            ),
          );
        },
      ),
    );
  }
}