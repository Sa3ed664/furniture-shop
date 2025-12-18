import 'package:flutter/material.dart';
import '../models/blog_post.dart';
import '../utils/colors.dart';

class BlogDetailScreen extends StatelessWidget {
  final BlogPost post;

  const BlogDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(post.title, style: const TextStyle(fontSize: 16)),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image
            Image.asset(
              post.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Center(child: Text('Image Not Found')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Metadata
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 5),
                      Text(
                        '${post.date} • ${post.readTime}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  // Content
                  Text(
                    post.content,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  // Placeholder for more detailed content
                  const SizedBox(height: 20),
                  Text(
                    'This is a placeholder for the full, detailed blog post content. The actual content would be much longer and formatted with paragraphs, lists, and images.',
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
