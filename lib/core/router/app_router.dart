import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/trip/presentation/screens/trip_list_screen.dart';
import '../../features/trip/presentation/screens/trip_detail_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/booking/presentation/screens/booking_list_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/about_screen.dart';
import '../widgets/main_shell.dart';

class AppRouter {
  final AuthProvider _authProvider;
  AppRouter(this._authProvider);

  late final router = GoRouter(
    initialLocation: '/home',
    refreshListenable: _authProvider,
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      ),
    ),
    redirect: (context, state) {
      final status = _authProvider.status;

      // Don't redirect while status is still being determined
      if (status == AuthStatus.initial || status == AuthStatus.loading) {
        return null;
      }

      final isAuthenticated = status == AuthStatus.authenticated;
      final isOnAuth = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register');

      if (!isAuthenticated && !isOnAuth) return '/login';
      if (isAuthenticated && isOnAuth) return '/home';
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterScreen(),
      ),

      // Shell with bottom nav
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/trips',
            builder: (_, __) => const TripListScreen(),
          ),
          GoRoute(
            path: '/bookings',
            builder: (_, __) => const BookingListScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),

      // Detail routes (outside shell = no bottom nav)
      GoRoute(
        path: '/trips/:id',
        builder: (_, state) =>
            TripDetailScreen(tripId: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/search',
        builder: (_, __) => const SearchScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/about',
        builder: (_, __) => const AboutScreen(),
      ),
    ],
  );
}
