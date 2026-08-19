import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyles.dart';

class TaskPriorityBadge extends StatelessWidget {
  final String priority;
  final double fontSize;
  final double iconSize;

  const TaskPriorityBadge({
    super.key,
    required this.priority,
    this.fontSize = 10,
    this.iconSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.priorityColor(priority);
    final bgColor = AppColors.priorityBgColor(priority);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_rounded,
            size: iconSize,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            priority.toUpperCase(),
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
