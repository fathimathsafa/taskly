import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';

class LoginHeader extends StatelessWidget {
  final bool isWide;

  const LoginHeader({
    super.key,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign In',
          style: AppTextStyles.display.copyWith(
            color: AppColors.textPrimary,
            fontSize: isWide ? 36 : 32,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your credentials to access your task workspace.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
