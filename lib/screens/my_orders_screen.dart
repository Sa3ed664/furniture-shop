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
    final AuthController auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('طلباتي', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        // لو مش مسجل دخول → ارجع واعرض رسالة
        if (!auth.isAuthenticated.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Get.currentRoute == '/my_orders') { // عشان ميتكررش
              Get.back();
              Get.snackbar(
                'غير مسموح',
                'برجاء تسجيل الدخول لرؤية طلباتك',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                duration: const Duration(seconds: 4),
              );
            }
          });

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // لو مسجل دخول → اعرض الطلبات
        if (dummyOrders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text('لا توجد طلبات بعد', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('عندما تقوم بطلب، ستظهر هنا', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
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
                title: Text('طلب رقم #${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('${order['date']} • ${order['items']} عناصر'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: order['status'] == 'Delivered'
                            ? Colors.green.withOpacity(0.2)
                            : order['status'] == 'Processing'
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order['status'] == 'Delivered'
                            ? 'تم التوصيل'
                            : order['status'] == 'Processing'
                            ? 'جاري المعالجة'
                            : 'تم الشحن',
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
                  Get.snackbar('تفاصيل الطلب', 'قريبًا إن شاء الله! 🚀');
                },
              ),
            );
          },
        );
      }),
    );
  }
}