// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart'; // <-- 1. ضيف الـ import ده
import '../app_router.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_chip.dart';
import '../widgets/offer_banner.dart';
import '../widgets/product_card.dart';
import '../data/dummy_data.dart';
import '../utils/colors.dart';
import '../controllers/wishlist_controller.dart'; // <-- 2. ضيف الـ import ده

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  bool isGuest = true;
  bool showAllFeatured = false;
  bool showAllProducts = false;

  @override
  Widget build(BuildContext context) {
    // ==================== (بداية التعديل 1) ====================
    // 3. فلترة المنتجات عشان نشيل التكرار
    final featuredIds = DummyData.featured.map((p) => p.id).toSet();
    final otherProducts = DummyData.allProducts
        .where((p) => !featuredIds.contains(p.id))
        .toList();
    // ==================== (نهاية التعديل 1) ====================

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, ${isGuest ? 'Guest User' : 'User'}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black)),
                const Text('Find your favorite furniture',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            actions: [
              // ==================== (بداية التعديل لـ PopupMenuButton) ====================
              PopupMenuButton<String>(
                onSelected: (String result) {
                  if (result == 'login') {
                    // استخدام Get.toNamed للتنقل إلى صفحة تسجيل الدخول
                    // نفترض وجود AppRoutes.login
                    Get.toNamed(AppRoutes.login);
                  } else if (result == 'signup') {
                    // يمكن إضافة منطق التنقل لصفحة التسجيل هنا
                    Get.snackbar('Sign Up', 'Sign Up functionality coming soon!',
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'login',
                    child: Text('Login'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'signup',
                    child: Text('Sign Up'),
                  ),
                ],
                // الأيقونة التي ستظهر في الـ AppBar
                icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    isGuest ? Icons.person_outline : Icons.person,
                    color: Colors.grey,
                  ),
                ),
              ),
              // ==================== (نهاية التعديل لـ PopupMenuButton) ====================
              const SizedBox(width: 16),
            ],
          ),


          // Categories
          SizedBox(
            height: 40,
            child: AnimationLimiter(
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CategoryChip(
                      label: 'All',
                      isSelected: showAllProducts,
                      onTap: () =>
                          setState(() => showAllProducts = !showAllProducts)),
                  // ... (باقي الـ Chips زي ما هي)
                  CategoryChip(
                      label: 'Bed',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.categoryProducts,
                          arguments: 'Bed')),
                  CategoryChip(
                      label: 'Chair',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.categoryProducts,
                          arguments: 'Chair')),
                  CategoryChip(
                      label: 'Sofa',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.categoryProducts,
                          arguments: 'Sofa')),
                  CategoryChip(
                      label: 'Storage',
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.categoryProducts,
                          arguments: 'Storage')),
                ].asMap().entries.map((e) {
                  return AnimationConfiguration.staggeredList(
                    position: e.key,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                        horizontalOffset: 50,
                        child: FadeInAnimation(child: e.value)),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          const OfferBanner(),
          const SizedBox(height: 24),

          // Featured Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Featured Items',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () =>
                      setState(() => showAllFeatured = !showAllFeatured),
                  child: Text(showAllFeatured ? 'Show Less' : 'View All',
                      style: const TextStyle(color: Colors.purple)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // (الـ GridView بتاع الـ Featured زي ما هو)
          AnimationLimiter(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: showAllFeatured
                  ? DummyData.featured.length
                  : (DummyData.featured.length > 2
                  ? 2
                  : DummyData.featured.length),
              itemBuilder: (_, i) {
                final p = DummyData.featured[i];
                return AnimationConfiguration.staggeredGrid(
                  position: i,
                  columnCount: 2,
                  duration: const Duration(milliseconds: 600),
                  child: ScaleAnimation(
                    scale: 0.9,
                    child: FadeInAnimation(
                      child: ProductCard(
                        product: p,
                        index: i,
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.productDetail,
                            arguments: p),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ==================== (بداية التعديل 2) ====================
          // 4. إضافة أنيميشن الظهور والاختفاء
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: showAllProducts
                ? Column(
              key: const ValueKey('all_products_list'), // مهم للأنيميشن
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('All Products',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                AnimationLimiter(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    // 5. استخدام القايمة الجديدة (المفلترة)
                    itemCount: otherProducts.length,
                    itemBuilder: (_, i) {
                      final p = otherProducts[i];
                      return AnimationConfiguration.staggeredGrid(
                        position: i,
                        columnCount: 2,
                        duration: const Duration(milliseconds: 600),
                        child: ScaleAnimation(
                          scale: 0.9,
                          child: FadeInAnimation(
                            child: ProductCard(
                              product: p,
                              index: i,
                              onTap: () => Navigator.pushNamed(
                                  context, AppRoutes.productDetail,
                                  arguments: p),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
                : const SizedBox.shrink(
              key: ValueKey('empty_placeholder'), // مهم للأنيميشن
            ),
          ),
          // ==================== (نهاية التعديل 2) ====================

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}