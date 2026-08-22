import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'backend/firestore_service.dart';
import 'backend/auth_service.dart';
import 'repository/product_repository.dart';
import 'repository/cart_repository.dart';
import 'repository/auth_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';
import 'screens/demo_storefront_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(const SatparaApp());
  } catch (_) {
    // Keep the storefront usable during development before Firebase is configured.
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DemoStorefrontScreen(),
      ),
    );
  }
}

class SatparaApp extends StatelessWidget {
  const SatparaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ---- Backend services (raw Firebase calls) ----
    final firestoreService = FirestoreService();
    final authService = AuthService();

    // ---- Repositories (app-level logic on top of services) ----
    final productRepo = ProductRepository(firestoreService);
    final cartRepo = CartRepository(firestoreService);
    final authRepo = AuthRepository(authService, firestoreService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepo)),
        ChangeNotifierProvider(create: (_) => ProductProvider(productRepo)),
        ChangeNotifierProvider(create: (_) => CartProvider(cartRepo)),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashScreen(),
      ),
    );
  }
}
