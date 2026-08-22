import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn) {
      context.read<CartProvider>().bindUser(auth.firebaseUser!.uid);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, size: 72, color: Colors.white),
            SizedBox(height: 16),
            Text(
              AppConstants.appName,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Pure Care, Naturally',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 32),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
