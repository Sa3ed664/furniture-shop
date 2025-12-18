// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../app_router.dart';
import '../utils/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _current = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/onboarding1.jpg',
      'title': 'Discover Unique Furniture',
      'desc': 'Find the perfect pieces to make your home truly yours',
    },
    {
      'image': 'assets/images/onboarding2.jpg',
      'title': 'Quality & Comfort',
      'desc': 'Experience comfort with our high-quality furniture selection',
    },
    {
      'image': 'assets/images/onboarding3.jpg',
      'title': 'Fast Delivery',
      'desc': 'Get your furniture delivered right to your doorstep',
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final page in pages) {
        precacheImage(AssetImage(page['image']!), context).catchError((e) {
          debugPrint('Failed to precache image: $e');
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            itemCount: pages.length,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      pages[i]['image']!,
                      height: 300,
                      errorBuilder: (_, __, ___) => Container(
                        height: 300,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
                        child: const Icon(Icons.image, size: 100, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(pages[i]['title']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text(pages[i]['desc']!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            },
          ),

          // Skip
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
              child: const Text('Skip', style: TextStyle(color: Colors.grey)),
            ),
          ),

          // Dots + Button
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                        (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _current == i ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _current == i ? AppColors.primary : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_current == pages.length - 1) {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    } else {
                      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    _current == pages.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}