import 'package:flutter/material.dart';
import 'package:taskly/core/theme/app_textstyles.dart';
import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = isLoading || onPressed == null;

    final childContent = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined
                    ? (textColor ?? AppColors.primary)
                    : (textColor ?? AppColors.onPrimary),
              ),
            ),
          )
        else ...[
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: isOutlined
                  ? (textColor ?? AppColors.textPrimary)
                  : (textColor ?? AppColors.onPrimary),
            ),
            const SizedBox(width: 10),
          ],
          Text(
            label,
            style: AppTextStyles.button.copyWith(
              color: isOutlined
                  ? (textColor ?? AppColors.textPrimary)
                  : (textColor ?? AppColors.onPrimary),
            ),
          ),
        ],
      ],
    );

    if (isOutlined) {
      return Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
        ),
        child: OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            side: const BorderSide(color: AppColors.border, width: 1.2),
          ),
          child: childContent,
        ),
      );
    }

    // Filled Gradient / Custom Colored Primary Button
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: disabled
            ? null
            : (backgroundColor != null
                ? null
                : AppColors.primaryGradient),
        color: disabled
            ? AppColors.border
            : (backgroundColor ?? (backgroundColor == null ? null : AppColors.primary)),
        boxShadow: disabled ? null : AppColors.primaryShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: disabled ? null : onPressed,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: childContent,
            ),
          ),
        ),
      ),
    );
  }
}