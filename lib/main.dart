import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/screens/camera/take_picture.dart';
import 'package:food_log/src/screens/community/community.dart';
import 'package:food_log/src/screens/home/home.dart';
import 'package:food_log/src/screens/listings/add_listing.dart';
import 'package:food_log/src/screens/listings/listings.dart';
import 'package:food_log/src/screens/listings/update_listing.dart';
import 'package:food_log/src/screens/login/login.dart';
import 'package:food_log/src/screens/map/map.dart';
import 'package:food_log/src/screens/profile/profile.dart';
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
        return HomeScreen(refreshListings: state.extra == true ? true : false);
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
        GoRoute(
          path: 'addlisting',
          builder: (BuildContext context, GoRouterState state) {
            return const AddListingScreen();
          },
        ),
        GoRoute(
          path: 'updatelisting',
          builder: (BuildContext context, GoRouterState state) {
            return UpdateListingScreen(listing: state.extra as Listing);
          },
        ),
        GoRoute(
          path: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
        GoRoute(
          path: 'community',
          builder: (BuildContext context, GoRouterState state) {
            return const CommunityScreen();
          },
        ),
        GoRoute(
          path: 'takePicture',
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> extra =
                state.extra as Map<String, dynamic>;
            return TakePictureScreen(
              camera: extra['camera'] as CameraDescription,
              listingId: extra['listingId'] as String,
            );
          },
        ),
        GoRoute(
          path: 'map',
          builder: (BuildContext context, GoRouterState state) {
            return const MapScreen();
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
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
