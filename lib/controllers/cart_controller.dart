// lib/controllers/cart_controller.dart
import 'package:get/get.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  var quantity = 1.obs;

  CartItem({required this.product});

  double get total => product.effectivePrice * quantity.value;
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  // متغير للتحكم في العروض
  var hasActiveDiscount = false.obs;

  void activateDiscount() => hasActiveDiscount.value = true;
  void deactivateDiscount() => hasActiveDiscount.value = false;

  List<CartItem> get items => cartItems;
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity.value);
  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.total);

  // الخصم يظهر بس لما يكون العرض مفعّل
  double get discount => hasActiveDiscount.value ? subtotal * 0.10 : 0.0;

  double get total => subtotal - discount;

  void addItem(Product product) {
    final existingIndex = cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      cartItems[existingIndex].quantity.value++;
    } else {
      cartItems.add(CartItem(product: product));
    }

    Get.snackbar(
      "${product.name} added!",
      "You now have $itemCount items",
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 1),
    );
  }

  void removeItem(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int change) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final newQty = cartItems[index].quantity.value + change;
      if (newQty <= 0) {
        removeItem(productId);
      } else {
        cartItems[index].quantity.value = newQty;
      }
    }
  }

  void clear() {
    cartItems.clear();
    hasActiveDiscount.value = false; // إلغاء العرض بعد الشراء
  }
}