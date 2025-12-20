// lib/widgets/user_stats.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/colors.dart';

class UserStats extends StatelessWidget {
  const UserStats({super.key});

  Future<int> _getCount(String table) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return 0;

    final response = await Supabase.instance.client
        .from(table)
        .select()
        .eq('user_id', user.id)
        .count(CountOption.exact);

    return response as int;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FutureBuilder<int>(
          future: _getCount('favorites'),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            return _buildStat('المفضلة', count);
          },
        ),
        FutureBuilder<int>(
          future: _getCount('cart_items'),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            return _buildStat('العربة', count);
          },
        ),
        FutureBuilder<int>(
          future: _getCount('orders'),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            return _buildStat('الطلبات', count);
          },
        ),
      ],
    );
  }

  Widget _buildStat(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}