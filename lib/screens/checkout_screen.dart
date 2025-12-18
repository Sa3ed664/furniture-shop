// lib/screens/checkout_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_router.dart'; // تمت الإضافة
import '../controllers/cart_controller.dart'; // تمت الإضافة
import '../controllers/orders_controller.dart'; // تمت الإضافة
import '../utils/colors.dart';

// تعريف أنواع الدفع
enum PaymentMethod { creditCard, mobileWallet }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.creditCard;
  final cartController = Get.find<CartController>();
  final ordersController = Get.find<OrdersController>();

  void _placeOrder() {
    // التحقق من وجود عناصر في السلة قبل إتمام الطلب
    if (cartController.itemCount == 0) {
      Get.snackbar(
        'Cart is Empty',
        'Cannot place an order without items in the cart.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // 1. زيادة عدد الطلبات في OrdersController
    ordersController.placeNewOrder();

    // 2. تفريغ سلة المشتريات
    cartController.clear();

    // 3. إظهار رسالة النجاح
    Get.snackbar(
      'Payment Successful!',
      'Your order has been placed. You can check your orders on the Profile page.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // 4. العودة إلى الشاشة الرئيسية (MainScreen) وفتح تبويب العربة (Index 1)
    Get.offNamedUntil(
      AppRoutes.home,
          (route) => route.isFirst,
      arguments: 1, // <-- تمرير مؤشر تبويب العربة (Cart Index)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: Colors.black)),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // خيار الدفع بالبطاقة الائتمانية
            _buildPaymentOption(
              title: 'Credit Card / Mada',
              icon: Icons.credit_card,
              method: PaymentMethod.creditCard,
            ),
            const SizedBox(height: 10),

            // خيار الدفع بالمحفظة الإلكترونية
            _buildPaymentOption(
              title: 'Mobile Wallet (Cash)',
              icon: Icons.wallet,
              method: PaymentMethod.mobileWallet,
            ),
            const SizedBox(height: 30),

            // عرض النموذج المناسب بناءً على الاختيار
            _buildPaymentForm(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _placeOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Pay Now', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required IconData icon,
    required PaymentMethod method,
  }) {
    final isSelected = _selectedMethod == method;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : Colors.grey.shade600),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
            const Spacer(),
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedMethod,
              onChanged: (PaymentMethod? value) {
                if (value != null) {
                  setState(() {
                    _selectedMethod = value;
                  });
                }
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    switch (_selectedMethod) {
      case PaymentMethod.creditCard:
        return const CreditCardForm();
      case PaymentMethod.mobileWallet:
        return const MobileWalletForm();
      default:
        return const SizedBox.shrink();
    }
  }
}

// =================================================================
// سيتم إنشاء هذه الـ Widgets في المراحل التالية
// =================================================================

class CreditCardForm extends StatelessWidget {
  const CreditCardForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Credit Card Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Card Number',
            hintText: 'xxxx xxxx xxxx xxxx',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Name on Card',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Expiry Date (MM/YY)',
                  hintText: '01/25',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.datetime,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'CVV Code',
                  hintText: '123',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum WalletType { vodafoneCash, wePay, orangeCash }

class MobileWalletForm extends StatefulWidget {
  const MobileWalletForm({super.key});

  @override
  State<MobileWalletForm> createState() => _MobileWalletFormState();
}

class _MobileWalletFormState extends State<MobileWalletForm> {
  WalletType _selectedWallet = WalletType.vodafoneCash;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Wallet Type',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildWalletOption(
          title: 'Vodafone Cash',
          type: WalletType.vodafoneCash,
        ),
        _buildWalletOption(
          title: 'WE Pay',
          type: WalletType.wePay,
        ),
        _buildWalletOption(
          title: 'Orange Cash',
          type: WalletType.orangeCash,
        ),
        const SizedBox(height: 20),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Mobile Phone Number',
            hintText: '01x xxxx xxxx',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildWalletOption({required String title, required WalletType type}) {
    return RadioListTile<WalletType>(
      title: Text(title),
      value: type,
      groupValue: _selectedWallet,
      onChanged: (WalletType? value) {
        if (value != null) {
          setState(() {
            _selectedWallet = value;
          });
        }
      },
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
