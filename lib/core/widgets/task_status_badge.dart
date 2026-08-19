import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyles.dart';

class TaskStatusBadge extends StatelessWidget {
  final String status;
  final double fontSize;
  final double iconSize;

  const TaskStatusBadge({
    super.key,
    required this.status,
    this.fontSize = 10,
    this.iconSize = 6,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.statusColor(status);
    final bgColor = AppColors.statusBgColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status.toUpperCase(),
            style: AppTextStyles.badge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
