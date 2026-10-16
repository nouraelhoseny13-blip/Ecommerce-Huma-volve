import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'core/dummy_data.dart';
import 'core/injection.dart';
import 'core/theme.dart';
import 'features/details/screens/product_details_screen.dart';
import 'features/splash/screens/splash_screen.dart';

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _listenForLinks();
  }

  Future<void> _listenForLinks() async {
    _linkSubscription = _appLinks.uriLinkStream.listen(
      _openProductFromUri,
      onError: (Object error) {
        debugPrint('Deep link error: $error');
      },
    );

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        await Future.delayed(const Duration(milliseconds: 2300));
        _openProductFromUri(initialUri);
      }
    } catch (error) {
      debugPrint('Could not get initial link: $error');
    }
  }

  void _openProductFromUri(Uri uri) {
    if (uri.scheme != 'humavolve' || uri.host != 'product') return;
    if (uri.pathSegments.isEmpty) return;

    final productId = uri.pathSegments.first;

    Product? selectedProduct;
    for (final product in dummyProducts) {
      if (product.id == productId) {
        selectedProduct = product;
        break;
      }
    }

    if (selectedProduct == null) {
      debugPrint('Product not found: $productId');
      return;
    }

    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;

    final product = selectedProduct;

    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}