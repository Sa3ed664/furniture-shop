// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animations/animations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'controllers/orders_controller.dart';

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
import 'screens/checkout_screen.dart';
import 'screens/cart_screen.dart';

import 'app_router.dart';
import 'utils/colors.dart';
import 'models/product.dart';
import 'models/blog_post.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dgyfxtdlhygzsmjybaqj.supabase.co',
    anonKey: 'sb_publishable_hLTa02U2XjA08Q1srI7_fQ_xOH6mCc4',
  );

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
            final initialIndex = settings.arguments as int? ?? 0;
            page = MainScreen(initialIndex: initialIndex);
            break;

          case AppRoutes.productDetail:
          // مهم جدًا: الشاشة بتاخد الـ arguments من Get.arguments جواها
            page = const ProductDetailScreen();
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

          case AppRoutes.blogDetail:
            final post = settings.arguments as BlogPost;
            page = BlogDetailScreen(post: post);
            break;

          case AppRoutes.profile:
            page = const ProfileScreen();
            break;

          case AppRoutes.payment:
            page = const CheckoutScreen();
            break;

          case AppRoutes.login:
            page = const LoginScreen();
            break;

          case AppRoutes.cart:
            page = const CartScreenContent();
            break;

          default:
            page = const Scaffold(
              body: Center(child: Text('404 - Page Not Found')),
            );
        }

        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: settings.name == AppRoutes.productDetail
              ? Duration.zero
              : const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (settings.name == AppRoutes.productDetail) {
              return child;
            }

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