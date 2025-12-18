import 'package:flutter/material.dart';
import '../utils/colors.dart';

class SearchBarWidget extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;

  const SearchBarWidget({super.key, required this.hint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 12),
              Text(hint, style: const TextStyle(color: Colors.grey)),
              const Spacer(),
              const Icon(Icons.tune, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}