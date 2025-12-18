import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/blog_post.dart';
import '../app_router.dart';
import '../utils/colors.dart';

class BlogCard extends StatelessWidget {
  final BlogPost post;

  const BlogCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.asset(
              post.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              // Placeholder for assets that might not exist yet
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(child: Text('Image: ${post.imageUrl}')),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Metadata (Date and Read Time)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.date,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      post.readTime,
                      style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Title
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle/Summary
                Text(
                  post.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 15),
                // Read More Link
                InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.blogDetail, arguments: post);
                  },
                  child: Text(
                    'Read More',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
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
