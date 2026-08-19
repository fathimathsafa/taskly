import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/core/theme/app_theme.dart';
import 'package:taskly/features/auth/login_Screen/view/login_screen.dart';
import 'package:taskly/features/dashboard_screen/controller/dash_board_controller.dart';
import 'package:taskly/features/dashboard_screen/view/dash_board_screen.dart';
import 'package:taskly/features/task_adding_screen/controller/task_adding_controller.dart';
import 'package:taskly/features/task_adding_screen/view/task_adding_screen.dart';
import 'package:taskly/features/task_listing_screen/controller/task_listing_controller.dart';
import 'package:taskly/features/task_listing_screen/view/task_listing%20screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => TaskListingController()),
        ChangeNotifierProvider(create: (_) => TaskAddingController()),
      ],
      child: MaterialApp(
        title: 'Taskly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/dashboard': (context) => const DashBoardScreen(),
          '/task-list': (context) => const TaskListingScreen(),
          '/add-task': (context) => const TaskAddingScreen(),
        },
      ),
    );
  }
}


