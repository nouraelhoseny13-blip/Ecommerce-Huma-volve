import 'package:flutter/material.dart';

import '../../../core/injection.dart';
import '../../../core/theme.dart';
import '../../auth/domain/usecases/get_token_usecase.dart';
import '../../auth/presentation/screens/login_screen.dart';
import '../../main_navigation/screens/main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  Future<void> _checkToken() async {
    await Future.delayed(const Duration(seconds: 2));
    final token = await sl<GetTokenUseCase>()();
    if (!mounted) return;

    final Widget next = (token != null && token.isNotEmpty)
        ? MainNavigationScreen()
        : const LoginScreen();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => next),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 100, color: AppTheme.primary),
            const SizedBox(height: 48),
            CircularProgressIndicator(color: AppTheme.primary),
          ],
        ),
      ),
    );
  }
}
