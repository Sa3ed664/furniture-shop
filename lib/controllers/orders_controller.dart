// lib/controllers/orders_controller.dart

// lib/controllers/orders_controller.dart
import 'package:get/get.dart';

class OrdersController extends GetxController {
  // تم تغيير القيمة المبدئية من 3 إلى 0
  final orderCount = 0.obs;

  void incrementOrderCount() {
    orderCount.value++;
  }

  // الدالة المستخدمة لإتمام الطلب
  void placeNewOrder() {
    // منطق إتمام الطلب...
    orderCount.value++; // زيادة العدد بعد إتمام الطلب بنجاح
  }

// يمكنك إضافة دالة لجلب العدد الحقيقي من الخادم عند بدء التطبيق
// @override
// void onInit() {
//   super.onInit();
//   // fetchOrderCountFromApi();
// }
}
