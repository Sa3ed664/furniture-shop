// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // الحالة بتاعة تسجيل الدخول
  var isLoggedIn = false.obs;

  // بيانات المستخدم
  var userEmail = ''.obs;
  var userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  // جلب بيانات المستخدم الحالي لو مسجل دخول
  void _loadCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      isLoggedIn.value = true;
      userEmail.value = user.email ?? '';
      userName.value = user.email?.split('@')[0] ?? '';
    } else {
      isLoggedIn.value = false;
      userEmail.value = '';
      userName.value = '';
    }
  }

  // تسجيل مستخدم جديد
  Future<void> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        isLoggedIn.value = true;
        userEmail.value = response.user!.email ?? '';
        userName.value = response.user!.email?.split('@')[0] ?? '';
        Get.snackbar('Success', 'Account created successfully');
      } else {
        Get.snackbar('Error', 'Failed to sign up');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // تسجيل دخول
  Future<void> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        isLoggedIn.value = true;
        userEmail.value = response.user!.email ?? '';
        userName.value = response.user!.email?.split('@')[0] ?? '';
        Get.snackbar('Success', 'Logged in successfully');
        Get.offAllNamed('/home'); // ارجع للشاشة الرئيسية بعد تسجيل الدخول
      } else {
        Get.snackbar('Error', 'Invalid email or password');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // تسجيل خروج
  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      isLoggedIn.value = false;
      userEmail.value = '';
      userName.value = '';
      Get.snackbar('Success', 'Logged out successfully');
      Get.offAllNamed('/login'); // ارجع لشاشة تسجيل الدخول
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
