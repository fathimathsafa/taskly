class AppStrings {
  static const String appName = 'Taskly';
  static const String defaultUser = 'Admin User';
  static const String defaultEmail = 'admin@example.com';
  static const String mockEmail = 'admin@example.com';
  static const String mockPassword = '123456';
}

class AppConstants {
  static const List<String> taskStatuses = [
    'pending',
    'in progress',
    'on hold',
    'completed',
  ];

  static const List<String> taskPriorities = [
    'low',
    'medium',
    'high',
  ];

  static const double defaultPadding = 18.0;
  static const double cardBorderRadius = 16.0;
}
