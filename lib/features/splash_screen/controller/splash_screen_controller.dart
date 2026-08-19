import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_storage_service.dart';

class SplashScreenController extends ChangeNotifier {
  bool _isNavigated = false;

  bool get isNavigated => _isNavigated;

  Future<void> handleSplashNavigation(BuildContext context) async {
    if (_isNavigated) return;

    await Future.delayed(const Duration(milliseconds: 2200));

    if (context.mounted) {
      _isNavigated = true;
      notifyListeners();

      final bool isLoggedIn = AuthStorageService.isLoggedIn();
      final String targetRoute =
          isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;

      Navigator.of(context).pushReplacementNamed(targetRoute);
    }
  }

  void resetNavigation() {
    _isNavigated = false;
    notifyListeners();
  }
}
