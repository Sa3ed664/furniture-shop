class BlogPost {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String content;
  final String category;
  final String readTime;
  final String date;

  BlogPost({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.content,
    required this.category,
    required this.readTime,
    required this.date,
  });
}

final List<BlogPost> dummyBlogPosts = [
  BlogPost(
    id: '1',
    title: '10 Tips for a Cozy Living Room',
    subtitle: 'Transform your space into a haven of comfort and style.',
    imageUrl: '../assets/images/3.jpg',
    content: 'Detailed content for the first blog post...',
    category: 'Interior Design',
    readTime: '5 min read',
    date: '2 days ago',
  ),
  BlogPost(
    id: '2',
    title: 'The Future of Sustainable Furniture',
    subtitle: 'Discover eco-friendly materials and designs for your home.',
    imageUrl: '../assets/images/2.webp',
    content: 'Detailed content for the second blog post...',
    category: 'Furniture',
    readTime: '8 min read',
    date: '1 week ago',
  ),
  BlogPost(
    id: '3',
    title: '2024 Color Trends for Home Decor',
    subtitle: 'A guide to the most popular and stylish colors this year.',
    imageUrl: '../assets/images/1.webp',
    content: 'Detailed content for the third blog post...',
    category: '2024 Trends',
    readTime: '4 min read',
    date: '3 weeks ago',
  ),
  BlogPost(
    id: '4',
    title: 'Maximizing Small Spaces with Smart Furniture',
    subtitle: 'Clever solutions to make the most of every square inch.',
    imageUrl: '../assets/images/4.jpg',
    content: 'Detailed content for the fourth blog post...',
    category: 'Interior Design',
    readTime: '6 min read',
    date: '1 month ago',
  ),
];
