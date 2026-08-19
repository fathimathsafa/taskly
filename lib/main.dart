import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/core/constants/app_constants.dart';
import 'package:taskly/core/routes/app_router.dart';
import 'package:taskly/core/theme/app_theme.dart';
import 'package:taskly/features/auth/login_Screen/controller/login_screen_controller.dart';
import 'package:taskly/features/dashboard_screen/controller/dash_board_controller.dart';
import 'package:taskly/features/profile_screen/controller/profile_controller.dart';
import 'package:taskly/features/task_adding_screen/controller/task_adding_controller.dart';
import 'package:taskly/features/task_details_screen/controller/task_details_controller.dart';
import 'package:taskly/features/task_listing_screen/controller/task_listing_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginScreenController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => TaskListingController()),
        ChangeNotifierProvider(create: (_) => TaskAddingController()),
        ChangeNotifierProvider(create: (_) => TaskDetailsController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRouter.initialRoute,
        routes: AppRouter.routes,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}


