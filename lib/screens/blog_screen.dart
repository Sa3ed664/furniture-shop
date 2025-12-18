import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../models/blog_post.dart';
import '../widgets/blog_card.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Furniture',
    'Interior Design',
    '2024 Trends',
    'DIY',
    'Tips & Tricks'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
            floating: true,
            pinned: true,
            elevation: 0,
            title: const Text('Blog', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Get inspired with furniture tips & trends.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Popular Topics/Filter Chips
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            label: Text(category),
                            backgroundColor: isSelected ? AppColors.primary : Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                ],
              ),
            ),
          ),
          // Blog Post List
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final filteredPosts = dummyBlogPosts.where((post) {
                    return _selectedCategory == 'All' || post.category == _selectedCategory;
                  }).toList();

                  if (filteredPosts.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.0),
                        child: Text('No posts found for this category.'),
                      ),
                    );
                  }

                  return BlogCard(post: filteredPosts[index]);
                },
                childCount: dummyBlogPosts.where((post) {
                  return _selectedCategory == 'All' || post.category == _selectedCategory;
                }).length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
