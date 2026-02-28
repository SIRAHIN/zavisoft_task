import 'package:go_router/go_router.dart';
import 'package:zavisoft_task/views/auth_view/login_view/login_view.dart';
import 'package:zavisoft_task/views/bottom_nav_view/main_nav_view.dart';
import 'package:zavisoft_task/views/splash_view/splash_view.dart';

class RouteManager {
  static final GoRouter router = GoRouter(
    initialLocation: splashViewPath,
    routes: [
      GoRoute(
        name: splashViewName,
        path: splashViewPath,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        name: loginViewName,
        path: loginViewPath,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
      name: mainNavViewName,
      path: mainNavViewPath, 
      builder: (context, state) =>  MainNavView(),)
    ],
  );
}

// Routes Paths 
const String splashViewPath = '/';
const String loginViewPath = '/loginView';
const String mainNavViewPath = '/mainNavView';

// Routes Names 
const String splashViewName = 'splashView';
const String loginViewName = 'loginView';
const String mainNavViewName = 'mainNavView';
