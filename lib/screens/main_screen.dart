// lib/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import 'home_screen.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'blog_screen.dart';
import 'profile_screen.dart';

import '../controllers/cart_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../utils/colors.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex; // <-- تمت الإضافة
  const MainScreen({super.key, this.initialIndex = 0}); // <-- تم التعديل

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // <-- تمت الإضافة
  }

  static final List<Widget> _screenContent = <Widget>[
    const HomeScreenContent(),
    const CartScreenContent(),
    const WishlistScreenContent(),
    const BlogScreen(),
    const ProfileScreen(),
  ];

  PreferredSizeWidget? _buildAppBar(int index) {
    switch (index) {
      case 0:
        return null;
      case 1:
        return AppBar(
          title: const Text('My Cart'),
          backgroundColor: AppColors.background,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        );
      case 2:
        return AppBar(
          title: const Text('Wishlist'),
          backgroundColor: AppColors.background,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        );
      case 3:
        return null;
      case 4:
        return null;
      default:
        return null;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(_selectedIndex),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screenContent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Obx(() {
              final cart = Get.find<CartController>();
              return badges.Badge(
                showBadge: cart.itemCount > 0,
                badgeContent: Text(
                  '${cart.itemCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                child: const Icon(Icons.shopping_cart_outlined),
              );
            }),
            activeIcon: const Icon(Icons.shopping_cart),
            label: 'Cart',
          ),

          BottomNavigationBarItem(
            icon: Obx(() {
              final wish = Get.find<WishlistController>();
              return badges.Badge(
                showBadge: wish.itemCount > 0,
                badgeContent: Text(
                  '${wish.itemCount}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.red),
                child: const Icon(Icons.favorite_border),
              );
            }),
            activeIcon: const Icon(Icons.favorite),
            label: 'Wishlist',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Blog',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
