import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';

class ProfileController extends ChangeNotifier {
  String userName = 'Admin User';
  String userEmail = 'admin@example.com';
  String userRole = 'Task Administrator';
  String memberSince = 'August 2026';

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
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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
