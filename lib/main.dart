// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animations/animations.dart';

import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'controllers/orders_controller.dart';

// (باقي الـ imports بتاعة الشاشات)
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/main_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/search_results_screen.dart';
import 'screens/special_offer_screen.dart';
import 'screens/category_products_screen.dart';
import 'screens/all_products_screen.dart';
import 'screens/discount_products_screen.dart';
import 'screens/blog_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/blog_detail_screen.dart';
import 'screens/login_screen.dart';
import 'app_router.dart';
import 'utils/colors.dart';
import 'models/product.dart';
import 'models/blog_post.dart';
import 'screens/checkout_screen.dart';
import 'screens/cart_screen.dart'; // <-- تمت الإضافة


void main() {
  Get.put(CartController());
  Get.put(WishlistController());
  Get.put(OrdersController());
  Get.put(AuthController());
  runApp(const FurnitureShopApp());
}

class FurnitureShopApp extends StatelessWidget {
  const FurnitureShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Furniture Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case AppRoutes.onboarding:
            page = const OnboardingScreen();
            break;
          case AppRoutes.home:
            page = const MainScreen();
            final initialIndex = settings.arguments as int? ?? 0;
            page = MainScreen(initialIndex: initialIndex);
            break;
            break;
          case AppRoutes.productDetail:
            final product = settings.arguments as Product;
            page = ProductDetailScreen(product: product);
            break;
          case AppRoutes.search:
            page = const SearchScreen();
            break;
          case AppRoutes.searchResults:
            final query = settings.arguments as String;
            page = SearchResultsScreen(query: query);
            break;
          case AppRoutes.specialOffer:
            page = const SpecialOfferScreen();
            break;
          case AppRoutes.categoryProducts:
            final category = settings.arguments as String;
            page = CategoryProductsScreen(category: category);
            break;
          case AppRoutes.allProducts:
            page = const AllProductsScreen();
            break;
          case AppRoutes.discountProducts:
            page = const DiscountProductsScreen();
            break;
          case AppRoutes.blog:
            page = const BlogScreen();
            break;
          case AppRoutes.profile:
            page = const ProfileScreen();
            break;
          case AppRoutes.blogDetail:
        final post = settings.arguments as BlogPost;
        page = BlogDetailScreen(post: post);
        break;
        case AppRoutes.payment: // <-- تمت الإضافة هنا
        page = const CheckoutScreen(); // <-- تم التعديل هنا
        break;
        page = const Scaffold(body: Center(child: Text('404')));
          case AppRoutes.login: // <-- تمت الإضافة
            page = const LoginScreen();
            break;
          case AppRoutes.cart: // <-- تمت الإضافة
            page = const CartScreenContent();
            break;
          default:
            page = const Scaffold(body: Center(child: Text('404')));
        }

        return PageRouteBuilder(
          // ==================== (بداية التعديل) ====================

          // 1. مدة الأنيميشن العادية (300ms)
          // دي هتخلي الـ Hero يشتغل لما تروح لصفحة المنتج
          transitionDuration: const Duration(milliseconds: 500),

          // 2. مدة أنيميشن الرجوع (صفر)
          // ده هيخلي الرجوع فوري (زي ما طلبت)
          reverseTransitionDuration: settings.name == AppRoutes.productDetail
              ? Duration.zero // <-- رجوع فوري لصفحة المنتج
              : const Duration(milliseconds: 500), // رجوع عادي لباقي الصفحات

          // ==================== (نهاية التعديل) ====================

          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {

            // 3. لو هي شاشة المنتج، متعملش أنيميشن إضافي (سيب الـ Hero بس)
            if (settings.name == AppRoutes.productDetail) {
              return child;
            }

            // 4. باقي الشاشات تاخد الأنيميشن العادي
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
      },
      builder: (context, child) => AnimationLimiter(child: child!),
    );
  }
}