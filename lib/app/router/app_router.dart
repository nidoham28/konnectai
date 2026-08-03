import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';
import 'package:konnectai/features/about/presentation/pages/about_page.dart';
import 'package:konnectai/features/auth/presentation/pages/auth_page.dart';
import 'package:konnectai/features/home/presentation/pages/home_page.dart';
import 'package:konnectai/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: AppPaths.splash,
    routes: [
      GoRoute(
        path: AppPaths.splash,
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppPaths.auth,
        name: AppRouteNames.auth,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppPaths.home,
        name: AppRouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppPaths.about,
        name: AppRouteNames.about,
        builder: (context, state) => const AboutPage(),
      ),
    ],
  );
}
