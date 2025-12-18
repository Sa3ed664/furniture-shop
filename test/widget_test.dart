// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:furniture_shop/main.dart';
import 'package:furniture_shop/screens/splash_screen.dart';
import 'package:furniture_shop/screens/home_screen.dart';
import 'package:furniture_shop/screens/onboarding_screen.dart';

// ==================
// 1. ضيف الـ imports دي هنا
import 'package:provider/provider.dart';
// غيّر المسارات دي للمكان الصحيح بتاع الـ providers عندك
import 'package:furniture_shop/providers/cart_provider.dart';
import 'package:furniture_shop/providers/wishlist_provider.dart';
// ==================


void main() {
  testWidgets('Furniture Shop App - Basic Smoke Test', (WidgetTester tester) async {

    // ==================
    // 2. التعديل الرئيسي هنا
    // السطر القديم اللي بيسبب المشكلة
    // await tester.pumpWidget(const FurnitureShopApp());

    // السطر الجديد: بنلف التطبيق بـ MultiProvider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => WishlistProvider()),
          // ضيف أي providers تانية التطبيق بيحتاجها هنا
        ],
        child: const FurnitureShopApp(),
      ),
    );
    // ==================


    // 1. التحقق من ظهور SplashScreen
    // (باقي الاختبار هيفضل زي ما هو بالظبط)
    expect(find.byType(SplashScreen), findsOneWidget);

    // انتظر الـ Splash يخلّص (نطول الوقت لـ 6 ثواني)
    await tester.pumpAndSettle(const Duration(seconds: 6));

    // 2. لو فيه Onboarding → اضغط "Skip"
    if (find.byType(OnboardingScreen).evaluate().isNotEmpty) {
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
    }

    // 3. التحقق من ظهور HomeScreen
    expect(find.byType(HomeScreenContent), findsOneWidget);

    // ... باقي الاختبار ...
    expect(find.descendant(
      of: find.byType(AppBar),
      matching: find.textContaining('Hello'),
    ), findsOneWidget);

    // ... (كمل باقي الاختبار عادي)
  });
}