import 'package:flutter/material.dart';
import '../utils/colors.dart'; // **تم إضافة هذا السطر**

// Main About Us Screen Widget
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // **تم التعديل**
      appBar: AppBar(
        backgroundColor: AppColors.background, // **تم التعديل**
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark), // **تم التعديل**
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold), // **تم التعديل**
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            _HeaderSection(),
            SizedBox(height: 30),
            _MissionSection(),
            SizedBox(height: 30),
            _ValuesSection(),
            SizedBox(height: 30),
            _TeamSection(),
            SizedBox(height: 30),
            _ConnectSection(),
            SizedBox(height: 40),
            _FooterSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// 1. Header Section
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          // Icon - Placeholder for a custom furniture icon
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1), // **تم التعديل**
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chair_outlined, // Using a standard icon as a placeholder
              size: 50,
              color: AppColors.primary, // **تم التعديل**
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Furniture Shop',
            style: TextStyle(
              color: AppColors.primary, // **تم التعديل**
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Your one-stop destination for premium furniture',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textLight, // **تم التعديل**
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Mission Section
class _MissionSection extends StatelessWidget {
  const _MissionSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
          'Our Mission',
          style: TextStyle(
            color: AppColors.textDark, // **تم التعديل**
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'To provide high-quality, stylish, and affordable furniture that transforms houses into homes. We believe everyone deserves to live in a space they love.',
          style: TextStyle(
            color: AppColors.textLight, // **تم التعديل**
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// 3. Values Section
class _ValuesSection extends StatelessWidget {
  const _ValuesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Our Values',
          style: TextStyle(
            color: AppColors.textDark, // **تم التعديل**
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 1.0, // Adjust this for card height
          children: const <Widget>[
            _ValueCard(
              icon: Icons.check_circle_outline,
              title: 'Quality',
              description: 'We never compromise on the quality of our products',
            ),
            _ValueCard(
              icon: Icons.design_services_outlined,
              title: 'Design',
              description: 'Every piece is crafted with attention to detail',
            ),
            _ValueCard(
              icon: Icons.eco_outlined,
              title: 'Sustainability',
              description: 'We care about the environment and use sustainable materials',
            ),
            _ValueCard(
              icon: Icons.support_agent_outlined,
              title: 'Service',
              description: 'Customer satisfaction is our top priority',
            ),
          ],
        ),
      ],
    );
  }
}

// Value Card Widget
class _ValueCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 30,
            color: AppColors.primary, // **تم التعديل**
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textDark, // **تم التعديل**
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textLight, // **تم التعديل**
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Team Section
class _TeamSection extends StatelessWidget {
  const _TeamSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
          'Our Team',
          style: TextStyle(
            color: AppColors.textDark, // **تم التعديل**
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'We are a team of passionate designers, craftsmen, and customer service professionals dedicated to bringing you the best furniture shopping experience.',
          style: TextStyle(
            color: AppColors.textLight, // **تم التعديل**
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// 5. Connect Section
class _ConnectSection extends StatelessWidget {
  const _ConnectSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Connect With Us',
          style: TextStyle(
            color: AppColors.textDark, // **تم التعديل**
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const <Widget>[
            _SocialIcon(icon: Icons.facebook, label: 'Facebook'),
            _SocialIcon(icon: Icons.camera_alt_outlined, label: 'Instagram'),
            _SocialIcon(icon: Icons.phone_outlined, label: 'Contact'),
            _SocialIcon(icon: Icons.mail_outline, label: 'Email'),
          ],
        ),
      ],
    );
  }
}

// Social Icon Widget
class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SocialIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon( // **تم إزالة const هنا**
            icon,
            size: 24,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


// 6. Footer Section
class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const Text(
            'Version 1.0.0',
            style: TextStyle(color: AppColors.textLight, fontSize: 12), // **تم التعديل**
          ),
          const SizedBox(height: 5),
          const Text(
            '© 2024 Furniture Shop. All rights reserved.',
            style: TextStyle(color: AppColors.textLight, fontSize: 12), // **تم التعديل**
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // Handle navigation to Privacy Policy
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: AppColors.primary, // **تم التعديل**
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text(
                ' • ',
                style: TextStyle(color: AppColors.textLight, fontSize: 12), // **تم التعديل**
              ),
              GestureDetector(
                onTap: () {
                  // Handle navigation to Terms of Service
                },
                child: const Text(
                  'Terms of Service',
                  style: TextStyle(
                    color: AppColors.primary, // **تم التعديل**
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
