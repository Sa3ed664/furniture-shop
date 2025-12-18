// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'dart:convert'; // تمت الإضافة
import 'package:flutter/material.dart'; // تمت الإضافة
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  var isLoggedIn = false.obs;
  var userName = 'Guest User'.obs;
  var userEmail = ''.obs;

  // تم حذف مفتاح _registeredUsersKey

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('user_name');
    if (savedName != null) {
      isLoggedIn(true);
      userName(savedName);
      userEmail(prefs.getString('user_email') ?? '');
    }
  }

  // دالة مساعدة لحفظ بيانات المستخدم الحالي في الذاكرة المؤقتة
  Future<void> _saveCurrentUser(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setBool('is_logged_in', true);

    isLoggedIn(true);
    userName(name);
    userEmail(email);

    Get.snackbar(
      'Welcome back!',
      'Logged in as $name',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );

    Get.offAllNamed('/home'); // أو Get.offAll(() => const MainScreen());
  }

  // دالة تسجيل الدخول (منطق المستخدم الثابت)
  Future<void> login(String email, String password) async {
    // هذا هو منطق التحقق الثابت
    const String correctEmail = "abdo@gmail.com";
    const String correctPassword = "12345678";

    if (email == correctEmail && password == correctPassword) {
      await _saveCurrentUser("Abdo Mohamed", email);
    } else {
      Get.snackbar(
        "خطأ في تسجيل الدخول",
        "الإيميل أو كلمة المرور غير صحيحة",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // تم حذف دالة register

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('is_logged_in');

    isLoggedIn(false);
    userName('Guest User');
    userEmail('');

    Get.snackbar(
      'See you soon!',
      'You have been signed out',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );

    Get.offAllNamed('/home');
  }
}
