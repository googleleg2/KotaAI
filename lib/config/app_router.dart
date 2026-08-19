import 'package:go_router/go_router.dart';

import '../features/dashboard/screens/business_dashboard_screen.dart';
import '../features/checkout/screens/paypal_cancel_screen.dart';
import '../features/checkout/screens/paypal_success_screen.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/builder/builder_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/splash/splash_screen.dart';

import '../services/auth_service.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  static final AuthService _auth = AuthService.instance;

  static final GoRouter router = GoRouter(
    initialLocation: '/',

    refreshListenable: GoRouterRefreshStream(
      _auth.authStateChanges,
    ),

    redirect: (context, state) async {
      final loggedIn = _auth.isLoggedIn;

      final location = state.matchedLocation;

      // ============================================================
      // PAYPAL CALLBACKS
      // ============================================================

      // PayPal must be allowed to complete its callback flow.
      if (location == '/paypal-success' ||
          location == '/paypal-cancel') {
        return null;
      }

      // ============================================================
      // AUTH ROUTES
      // ============================================================

      final isAuthRoute =
          location == '/login' ||
          location == '/signup';

      // ============================================================
      // NOT LOGGED IN
      // ============================================================

      if (!loggedIn &&
          !isAuthRoute &&
          location != '/') {
        return '/login';
      }

      // ============================================================
      // LOGGED IN USER
      // ============================================================

      if (loggedIn) {
        final isAdmin = await _auth.isAdmin();

        // ----------------------------------------------------------
        // ADMIN
        // ----------------------------------------------------------

        if (isAdmin) {
          // Admin should not remain on login/signup.
          if (isAuthRoute) {
            return '/dashboard';
          }

          return null;
        }

        // ----------------------------------------------------------
        // CUSTOMER
        // ----------------------------------------------------------

        // Customers cannot access the business dashboard.
        if (location == '/dashboard') {
          return '/home';
        }

        // Customers should not remain on login/signup.
        if (isAuthRoute) {
          return '/home';
        }
      }

      return null;
    },

    routes: [
      // ============================================================
      // SPLASH
      // ============================================================

      GoRoute(
        path: '/',
        builder: (_, __) => const SplashScreen(),
      ),

      // ============================================================
      // AUTH
      // ============================================================

      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),

      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),

      // ============================================================
      // CUSTOMER HOME
      // ============================================================

      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),

      // ============================================================
      // CUSTOMER PROFILE
      // ============================================================

      GoRoute(
        path: '/profile',
        builder: (_, __) => const ProfileScreen(),
      ),

      // ============================================================
      // KOTA BUILDER
      // ============================================================

      GoRoute(
        path: '/builder',
        builder: (_, __) => const BuilderScreen(),
      ),

      // ============================================================
      // CART
      // ============================================================

      GoRoute(
        path: '/cart',
        builder: (_, __) => const CartScreen(),
      ),

      // ============================================================
      // CHECKOUT
      // ============================================================

      GoRoute(
        path: '/checkout',
        builder: (_, __) => const CheckoutScreen(),
      ),

      // ============================================================
      // ADMIN BUSINESS DASHBOARD
      // ============================================================

      GoRoute(
        path: '/dashboard',
        builder: (_, __) =>
            const BusinessDashboardScreen(),
      ),

      // ============================================================
      // PAYPAL SUCCESS
      // ============================================================

      GoRoute(
        path: '/paypal-success',
        builder: (_, __) =>
            const PayPalSuccessScreen(),
      ),

      // ============================================================
      // PAYPAL CANCEL
      // ============================================================

      GoRoute(
        path: '/paypal-cancel',
        builder: (_, __) =>
            const PayPalCancelScreen(),
      ),
    ],
  );
}