import 'package:flutter/material.dart';
import '../utils/colors.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy FAQs
    final List<Map<String, String>> dummyFAQs = [
      {
        'question': 'How do I track my order?',
        'answer': 'You can track your order in the My Orders section.',
      },
      {
        'question': 'What is the return policy?',
        'answer': 'We offer 30-day returns on all items.',
      },
      {
        'question': 'How to apply promo codes?',
        'answer': 'Enter the code at checkout.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for help...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyFAQs.length,
              itemBuilder: (_, i) {
                final faq = dummyFAQs[i];
                return ExpansionTile(
                  title: Text(faq['question']!),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(faq['answer']!),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}