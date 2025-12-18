// lib/controllers/wishlist_controller.dart
import 'package:get/get.dart';
import '../models/product.dart';

class WishlistController extends GetxController {
  var wishlistItems = <Product>[].obs;
  var _wishlistIds = <String>{}.obs;

  List<Product> get items => wishlistItems;
  int get itemCount => wishlistItems.length;
  bool isWishlisted(String productId) => _wishlistIds.contains(productId);

  void toggle(Product product) {
    if (_wishlistIds.contains(product.id)) {
      _wishlistIds.remove(product.id);
      wishlistItems.removeWhere((p) => p.id == product.id);

      // ==================== (بداية التعديل) ====================
      Get.snackbar(
        'Removed from Wishlist',
        '${product.name} is no longer in your wishlist.',
        snackPosition: SnackPosition.TOP, // <-- اتغيرت لـ TOP
        duration: const Duration(seconds: 1),
      );
      // ==================== (نهاية التعديل) ====================

    } else {
      _wishlistIds.add(product.id);
      wishlistItems.add(product);

      // ==================== (بداية التعديل) ====================
      Get.snackbar(
        'Added to Wishlist',
        '${product.name} is now in your wishlist.',
        snackPosition: SnackPosition.TOP, // <-- اتغيرت لـ TOP
        duration: const Duration(seconds: 1),
      );
      // ==================== (نهاية التعديل) ====================
    }
  }

  void remove(String productId) {
    _wishlistIds.remove(productId);
    wishlistItems.removeWhere((p) => p.id == productId);
  }

  void clear() {
    _wishlistIds.clear();
    wishlistItems.clear();
  }
}