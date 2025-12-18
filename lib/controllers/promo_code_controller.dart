// lib/controllers/promo_code_controller.dart
class PromoCodeController {
  static const Map<String, double> promoCodes = {
    'SUMMER20': 0.20,
    'WELCOME10': 0.10,
    'SAVE50': 0.50,
  };

  static double applyDiscount(double price, String code) {
    final normalizedCode = code.trim().toUpperCase();
    final discount = promoCodes[normalizedCode] ?? 0.0;
    return price * (1 - discount);
  }

  static bool isValid(String code) {
    return promoCodes.containsKey(code.trim().toUpperCase());
  }
}