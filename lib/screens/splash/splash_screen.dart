import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      final uri = Uri.base;
      final path = uri.path;

      // Preserve PayPal callback URLs.
      if (path == '/paypal-success') {
        context.go(
          '/paypal-success${uri.hasQuery ? '?${uri.query}' : ''}',
        );
        return;
      }

      if (path == '/paypal-cancel') {
        context.go(
          '/paypal-cancel${uri.hasQuery ? '?${uri.query}' : ''}',
        );
        return;
      }

      // Normal startup.
      if (AuthService.instance.isLoggedIn) {
        context.go('/home');
      } else {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fastfood,
              size: 90,
              color: AppColors.primary,
            ),
            SizedBox(height: 20),
            Text(
              "Kota AI",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}