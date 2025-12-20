// lib/controllers/wishlist_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class WishlistController extends GetxController {
  var wishlist = <String>{}.obs; // ids المنتجات المفضلة

  @override
  void onInit() {
    super.onInit();
    fetchWishlist();
  }

  // جلب المفضلة من Supabase
  Future<void> fetchWishlist() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await Supabase.instance.client
        .from('favorites')
        .select('product_id')
        .eq('user_id', user.id);

    wishlist.assignAll(response.map((e) => e['product_id'] as String));
  }

  // إضافة أو إزالة من المفضلة
  Future<void> toggle(Product product) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Get.snackbar('مطلوب تسجيل دخول', 'سجل دخول عشان تضيف للمفضلة');
      Get.toNamed('/login');
      return;
    }

    if (wishlist.contains(product.id)) {
      // إزالة
      await Supabase.instance.client
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', product.id);

      wishlist.remove(product.id);
      Get.snackbar('تم الإزالة', '${product.name} تم إزالته من المفضلة');
    } else {
      // إضافة
      await Supabase.instance.client
          .from('favorites')
          .insert({
        'user_id': user.id,
        'product_id': product.id,
      });

      wishlist.add(product.id);
      Get.snackbar('تم الإضافة', '${product.name} تم إضافته للمفضلة');
    }
  }

  bool isWishlisted(String productId) {
    return wishlist.contains(productId);
  }
}