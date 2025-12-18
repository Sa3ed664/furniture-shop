// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import '../controllers/auth_controller.dart'; // لا نحتاجها الآن
import 'onboarding_screen.dart';
// import 'main_screen.dart'; // لا نحتاجها الآن
// import '../app_router.dart'; // لا نحتاجها الآن
import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward().then((_) {
      // **تم تبسيط منطق الانتقال هنا**
      // بعد انتهاء الأنيميشن، انتقل إلى شاشة Onboarding
      Get.offAll(() => const OnboardingScreen());

      // ملاحظة: إذا كنت تريد استخدام منطق الـ Auth، يجب عليك:
      // 1. التأكد من تهيئة AuthController في main.dart
      // 2. التأكد من أن AuthController موجود في ملف controllers/auth_controller.dart

      /*
      // الكود الأصلي الذي كان يسبب المشكلة (قبل التأكد من تهيئة AuthController)
      final auth = Get.find<AuthController>();
      if (auth.isLoggedIn.value) {
        Get.offAll(() => const MainScreen());
      } else {
        Get.offAll(() => const OnboardingScreen());
      }
      */
    });
  }

  @override
  Widget build(BuildContext context) {
    // ... (الكود كما هو)
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chair_outlined, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              const Text('Furniture Shop', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('Make your home beautiful', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
