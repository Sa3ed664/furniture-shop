// lib/screens/special_offer_screen.dart
import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../data/dummy_data.dart';
import '../models/product.dart';
import '../utils/colors.dart';
import '../controllers/promo_code_controller.dart';
import '../app_router.dart';

class SpecialOfferScreen extends StatefulWidget {
  const SpecialOfferScreen({super.key});

  @override
  State<SpecialOfferScreen> createState() => _SpecialOfferScreenState();
}

class _SpecialOfferScreenState extends State<SpecialOfferScreen> {
  final TextEditingController _promoController = TextEditingController();
  String? _appliedCode;
  late List<Product> offerProducts;

  @override
  void initState() {
    super.initState();
    offerProducts = DummyData.offerProducts;
  }

  void _applyPromo() {
    final code = _promoController.text.trim();
    if (PromoCodeController.isValid(code)) {
      setState(() {
        _appliedCode = code;
        final discount = PromoCodeController.promoCodes[code.toUpperCase()]!;
        offerProducts = DummyData.offerProducts.map((p) {
          final discounted = p.price * (1 - discount);
          return p.copyWith(discountedPrice: discounted);
        }).toList();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Applied $code!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid promo code')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = offerProducts.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Special Offer'), backgroundColor: AppColors.background, elevation: 0),
      body: hasItems
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _promoController,
              decoration: InputDecoration(
                hintText: 'Enter promo code',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: TextButton(onPressed: _applyPromo, child: const Text('Apply')),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Summer Sale', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${(_appliedCode != null ? (PromoCodeController.promoCodes[_appliedCode]! * 100).toInt() : 20)}% OFF',
                          style: const TextStyle(fontSize: 24, color: AppColors.primary, fontWeight: FontWeight.bold)),
                      const Text('Get discount on all items'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: Text('${(_appliedCode != null ? (PromoCodeController.promoCodes[_appliedCode]! * 100).toInt() : 20)}%',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: offerProducts.length,
              itemBuilder: (_, i) {
                final p = offerProducts[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ProductCard(
                    product: p,
                    index: i,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: p),
                  ),
                );
              },
            ),
          ),
        ],
      )
          : const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('No Items available', style: TextStyle(fontSize: 16)),
            Text('Check back later', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}