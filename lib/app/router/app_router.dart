import 'package:go_router/go_router.dart';
import 'package:konnectai/app/router/app_routes.dart';
import 'package:konnectai/features/auth/presentation/pages/auth_page.dart';
import 'package:konnectai/features/main/presentation/pages/main_navigation_page.dart';
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
        builder: (context, state) => const MainNavigationPage(initialIndex: 0),
      ),
      GoRoute(
        path: AppPaths.chats,
        name: AppRouteNames.chats,
        builder: (context, state) => const MainNavigationPage(initialIndex: 1),
      ),
      GoRoute(
        path: AppPaths.profile,
        name: AppRouteNames.profile,
        builder: (context, state) => const MainNavigationPage(initialIndex: 2),
      ),
    ],
  );
}
