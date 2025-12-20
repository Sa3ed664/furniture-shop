import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

  // Observables عشان نتابع حالة المستخدم واللودينج
  var isLoading = false.obs;
  var isAuthenticated = false.obs;
  var userEmail = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // شوف لو المستخدم مسجل دخوله أصلًا (مثلًا بعد ريستارت التطبيق)
    final currentUser = _client.auth.currentUser;
    if (currentUser != null) {
      isAuthenticated(true);
      userEmail(currentUser.email ?? '');
    }

    // استمع لتغييرات حالة الـ Auth (login, logout, signup...)
    _client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        isAuthenticated(true);
        userEmail(session.user.email ?? '');
      } else if (event == AuthChangeEvent.signedOut) {
        isAuthenticated(false);
        userEmail('');
      }
    });
  }

  // دالة تسجيل الدخول (Login)
  Future<String?> login(String email, String password) async {
    try {
      isLoading(true);

      final AuthResponse res = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (res.user != null) {
        isAuthenticated(true);
        userEmail(res.user!.email ?? '');
        Get.snackbar('نجاح', 'تم تسجيل الدخول بنجاح');
        Get.offAllNamed('/home'); // غير الـ route حسب اللي عندك
        return null; // no error
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'حدث خطأ غير متوقع';
    } finally {
      isLoading(false);
    }
    return 'بيانات غير صحيحة';
  }

  // دالة إنشاء حساب جديد (Register)
  Future<String?> register(String email, String password) async {
    try {
      isLoading(true);

      final AuthResponse res = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );

      if (res.user != null) {
        // Supabase بيبعت ايميل تأكيد تلقائي (افتراضيًا مفعل)
        Get.snackbar('نجاح', 'تم إنشاء الحساب، يرجى تأكيد الإيميل');
        Get.offAllNamed('/login'); // أو الشاشة اللي عايز ترجع لها
        return null;
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'حدث خطأ غير متوقع';
    } finally {
      isLoading(false);
    }
    return 'فشل في إنشاء الحساب';
  }

  // دالة تسجيل الخروج (Logout)
  Future<void> logout() async {
    try {
      isLoading(true);
      await _client.auth.signOut();
      isAuthenticated(false);
      userEmail('');
      Get.snackbar('تم', 'تم تسجيل الخروج');
      Get.offAllNamed('/login'); // أو splash أو الشاشة اللي عايزها
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تسجيل الخروج');
    } finally {
      isLoading(false);
    }
  }
}