import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/service_locator.dart';
import 'core/themes/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/trip/presentation/providers/trip_provider.dart';
import 'features/home/presentation/providers/home_provider.dart';
import 'features/search/presentation/providers/search_provider.dart';
import 'features/booking/presentation/providers/booking_provider.dart';
import 'features/profile/presentation/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const HealingYukApp());
}

class HealingYukApp extends StatefulWidget {
  const HealingYukApp({super.key});

  @override
  State<HealingYukApp> createState() => _HealingYukAppState();
}

class _HealingYukAppState extends State<HealingYukApp> {
  late final AuthProvider _authProvider;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authProvider = sl<AuthProvider>();
    _appRouter = AppRouter(_authProvider);
    _authProvider.checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authProvider),
        ChangeNotifierProvider(create: (_) => sl<TripProvider>()),
        ChangeNotifierProvider(create: (_) => sl<HomeProvider>()),
        ChangeNotifierProvider(create: (_) => sl<SearchProvider>()),
        ChangeNotifierProvider(create: (_) => sl<BookingProvider>()),
        ChangeNotifierProvider(create: (_) => sl<ProfileProvider>()),
      ],
      child: MaterialApp.router(
        title: 'HealingYuk',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
