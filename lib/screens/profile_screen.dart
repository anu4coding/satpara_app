import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/theme.dart';
import 'order_history_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              (auth.profile?.name ?? auth.firebaseUser?.email ?? '?').substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(auth.profile?.name ?? 'Satpara Customer',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Text(auth.firebaseUser?.email ?? '', style: const TextStyle(color: AppColors.textMuted)),
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: const Text('My Orders'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error)),
            onTap: () async {
              await auth.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
