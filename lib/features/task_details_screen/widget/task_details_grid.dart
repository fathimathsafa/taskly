import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../dashboard_screen/model/task_model.dart';

class TaskDetailsGrid extends StatelessWidget {
  final Task task;

  const TaskDetailsGrid({
    super.key,
    required this.task,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'No Due Date';
    final day = date.day.toString().padLeft(2, '0');
    final month = _getMonthAbbr(date.month);
    final year = date.year;
    return '$day $month $year';
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _getMonthAbbr(date.month);
    final year = date.year;
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$day $month $year, $hour:$minute $period';
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[(month - 1) % 12];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetaTile(
                icon: Icons.person_outline_rounded,
                iconColor: AppColors.primary,
                title: 'Assigned User',
                value: task.assignee.isNotEmpty ? task.assignee : 'Unassigned',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMetaTile(
                icon: Icons.calendar_today_rounded,
                iconColor: AppColors.secondary,
                title: 'Due Date',
                value: _formatDate(task.dueDate),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        _buildMetaTile(
          icon: Icons.access_time_rounded,
          iconColor: AppColors.textSecondary,
          title: 'Created Date',
          value: _formatDateTime(task.createdAt),
        ),
      ],
    );
  }

  Widget _buildMetaTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
