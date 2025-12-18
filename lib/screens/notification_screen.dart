import 'package:flutter/material.dart';
import '../utils/colors.dart'; // Assuming AppColors is in this path

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isOrderNotificationsEnabled = true;
  bool _isPromoNotificationsEnabled = true;
  bool _isNewProductNotificationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Notification Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Order Notifications
          _buildNotificationTile(
            title: 'Order Updates',
            subtitle: 'Get notified about order status changes (e.g., shipped, delivered).',
            value: _isOrderNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _isOrderNotificationsEnabled = value;
              });
            },
          ),

          // Promo Notifications
          _buildNotificationTile(
            title: 'Promotions & Sales',
            subtitle: 'Receive alerts for special offers, discounts, and sales events.',
            value: _isPromoNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _isPromoNotificationsEnabled = value;
              });
            },
          ),

          // New Product Notifications
          _buildNotificationTile(
            title: 'New Product Alerts',
            subtitle: 'Be the first to know when new furniture collections arrive.',
            value: _isNewProductNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _isNewProductNotificationsEnabled = value;
              });
            },
          ),
          
          const Divider(height: 30),

          // General Settings
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'General',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Sound Toggle (Example)
          _buildNotificationTile(
            title: 'Notification Sound',
            subtitle: 'Play a sound when a notification is received.',
            value: true, // Example static value
            onChanged: (bool value) {
              // Handle sound toggle logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textLight)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        inactiveThumbColor: AppColors.textLight.withOpacity(0.5),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
