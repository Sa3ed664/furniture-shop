// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/colors.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/user_stats.dart';

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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
              authController.isLoggedIn.value ? authController.userName.value : 'Not signed in',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            Obx(() => Text(
              authController.isLoggedIn.value ? authController.userEmail.value : '',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            )),
            const SizedBox(height: 20),
            const UserStats(),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0,3))],
              ),
              child: Column(
                children: [
                  Obx(() => ProfileMenuItem(
                    title: authController.isLoggedIn.value ? 'Sign Out' : 'Sign In',
                    subtitle: authController.isLoggedIn.value ? 'Sign out from your account' : 'Login or create an account',
                    icon: authController.isLoggedIn.value ? Icons.logout : Icons.login,
                    onTap: () {
                      if (authController.isLoggedIn.value) {
                        authController.logout();
                      } else {
                        Get.toNamed('/login');
                      }
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
