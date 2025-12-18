import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../app_router.dart';
import '../utils/colors.dart';

class OfferBanner extends StatelessWidget {
  const OfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (child, animation, secondaryAnimation) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      },
      child: GestureDetector(
        key: const ValueKey('offer_banner'),
        onTap: () => Navigator.pushNamed(context, AppRoutes.specialOffer),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Summer Sale', style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text('20% OFF', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const Text('Get 20% off on all summer collection items'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.specialOffer),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('Shop Now', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/chair.jpg',
                width: 100,
                errorBuilder: (_, __, ___) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.chair, size: 50, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}