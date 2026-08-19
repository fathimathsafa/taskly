import 'package:flutter/material.dart';
import 'package:taskly/core/routes/app_routes.dart';
import '../../features/auth/login_Screen/view/login_screen.dart';
import '../../features/dashboard_screen/view/dash_board_screen.dart';
import '../../features/profile_screen/view/profile_screen.dart';
import '../../features/splash_screen/view/splash_screen.dart';
import '../../features/task_adding_screen/view/task_adding_screen.dart';
import '../../features/task_details_screen/view/task_details_screen.dart';
import '../../features/task_listing_screen/view/task_listing_screen.dart';

class AppRouter {
  static const String initialRoute = AppRoutes.splash;

  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.dashboard: (context) => const DashBoardScreen(),
        AppRoutes.taskList: (context) => const TaskListingScreen(),
        AppRoutes.addTask: (context) => const TaskAddingScreen(),
        AppRoutes.taskDetails: (context) => const TaskDetailsScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case AppRoutes.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashBoardScreen(),
          settings: settings,
        );
      case AppRoutes.taskList:
        return MaterialPageRoute(
          builder: (_) => const TaskListingScreen(),
          settings: settings,
        );
      case AppRoutes.addTask:
        return MaterialPageRoute(
          builder: (_) => const TaskAddingScreen(),
          settings: settings,
        );
      case AppRoutes.taskDetails:
        return MaterialPageRoute(
          builder: (_) => const TaskDetailsScreen(),
          settings: settings,
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
          settings: settings,
        );
    }
  }
}
