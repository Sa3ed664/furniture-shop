import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/user_stats.dart';
import 'about_us_screen.dart';
import 'my_orders_screen.dart';
import 'help_center_screen.dart';
import 'notification_screen.dart'; // **تمت الإضافة لضمان وجودها**
import '../controllers/auth_controller.dart';
import 'settings_screen.dart'; // أضف هذا السطر


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Navigate to the SettingsScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Info Section
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 10),
            // الاسم أصبح ديناميكي ويراقب التغييرات
            Obx(() => Text(
              authController.userName.value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            // حالة تسجيل الدخول/الإيميل أصبحت ديناميكية
            Obx(() => Text(
              authController.isLoggedIn.value ? authController.userEmail.value : 'Not signed in',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            )),
            const SizedBox(height: 20),

            // User Stats Section
            const UserStats(),
            const SizedBox(height: 30),

            // Menu Items Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 3. My Orders
                  ProfileMenuItem(
                    title: 'My Orders',
                    subtitle: 'View your order history',
                    icon: Icons.shopping_bag_outlined,
                    onTap: () {
                      // 4. التنقل لصفحة My Orders الجديدة
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyOrdersScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // 5. Notifications
                  ProfileMenuItem(
                    title: 'Notifications',
                    subtitle: 'Customize notification settings',
                    icon: Icons.notifications_outlined,
                    onTap: () {
                      // **تم إضافة كود التنقل لشاشة الإشعارات**
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // 6. Help Center
                  ProfileMenuItem(
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    icon: Icons.help_outline,
                    onTap: () {
                      // 7. التنقل لصفحة Help Center الجديدة
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // 8. About Us
                  ProfileMenuItem(
                    title: 'About Us',
                    subtitle: 'Learn more about our company',
                    icon: Icons.info_outline,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  // 9. Sign Out / Sign In (ديناميكي)
                  Obx(() => ProfileMenuItem(
                    title: authController.isLoggedIn.value ? 'Sign Out' : 'Sign In',
                    subtitle: authController.isLoggedIn.value ? 'Sign out from your account' : 'Login or create an account',
                    icon: authController.isLoggedIn.value ? Icons.logout : Icons.login,
                    onTap: () {
                      if (authController.isLoggedIn.value) {
                        // 10. تنفيذ عملية تسجيل الخروج
                        authController.logout();
                      } else {
                        // التنقل لصفحة تسجيل الدخول
                        Get.toNamed('/login'); // استخدام المسار الثابت /login
                      }
                    },
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}