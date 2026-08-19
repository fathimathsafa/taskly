import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../controller/dash_board_controller.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  void _showLogoutDialog(BuildContext context) {
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
              context.read<DashboardController>().logout(context);
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Clean Title and Subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tasks',
              style: AppTextStyles.h1.copyWith(
                //fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Manage your tasks efficiently',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        // Right: Profile Avatar Icon & Logout Shutdown Button
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Icon / Avatar
            Tooltip(
              message: 'Profile',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Logout Shutdown Button
            Tooltip(
              message: 'Logout',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showLogoutDialog(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.power_settings_new_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
