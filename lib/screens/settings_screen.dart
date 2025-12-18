// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // **هذا هو الـ AppBar**
      appBar: AppBar(
        title: const Text(
          'Settings',
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
      // نهاية الـ AppBar
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // =================================================
          // 1. App Preferences Section
          // =================================================
          _buildSectionTitle(context, 'App Preferences'),

          // Dark Mode Toggle
          _buildSwitchTile(
            title: 'Dark Mode',
            icon: Icons.dark_mode_outlined,
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
                // Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              });
            },
          ),

          // Language Selection
          _buildListTile(
            title: 'Language',
            subtitle: _selectedLanguage,
            icon: Icons.language_outlined,
            onTap: () {
              // Show language selection dialog
              _showLanguageDialog(context);
            },
          ),

          const Divider(height: 30),

          // =================================================
          // 2. Account Settings Section
          // =================================================
          _buildSectionTitle(context, 'Account Settings'),

          _buildListTile(
            title: 'Edit Profile',
            icon: Icons.person_outline,
            onTap: () {
              // Navigate to Edit Profile Screen
            },
          ),
          _buildListTile(
            title: 'Manage Addresses',
            icon: Icons.location_on_outlined,
            onTap: () {
              // Navigate to Address Management Screen
            },
          ),

          const Divider(height: 30),

          // =================================================
          // 3. Legal Section
          // =================================================
          _buildSectionTitle(context, 'Legal'),

          _buildListTile(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              // Navigate to Privacy Policy Screen
            },
          ),
          _buildListTile(
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {
              // Navigate to Terms of Service Screen
            },
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
        onTap: onTap,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    // Example Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                    Navigator.pop(context);
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('العربية'),
                value: 'العربية',
                groupValue: _selectedLanguage,
                onChanged: (String? value) {
                  setState(() {
                    _selectedLanguage = value!;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
