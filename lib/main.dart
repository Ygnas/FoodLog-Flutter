import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/screens/home/home.dart';
import 'package:food_log/src/screens/listings/listings.dart';
import 'package:food_log/src/screens/login/login.dart';
import 'package:food_log/src/screens/register/register.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => ListingProvider())
  ], child: const MainApp()));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterScreen();
          },
        ),
        GoRoute(
          path: 'listings',
          builder: (BuildContext context, GoRouterState state) {
            return ListingScreen(listing: state.extra as Listing);
          },
        ),
      ],
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    userProvider.loadToken();
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}
