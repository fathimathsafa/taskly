import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';

class ProfileController extends ChangeNotifier {
  String _profileImagePath = 'assets/images/user_avatar.jpg';

  String get userName => 'Admin User';
  String get userEmail => AuthStorageService.getEmail() ?? 'admin@example.com';
  String get userRole => 'Task Administrator';
  String get memberSince => 'August 2026';
  String get profileImagePath => _profileImagePath;

  void updateProfileImage(String path) {
    _profileImagePath = path;
    notifyListeners();
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Logout Confirmation', style: AppTextStyles.h3),
        content: Text(
          'Are you sure you want to log out of your Taskly workspace?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await AuthStorageService.clearSession();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(90, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
