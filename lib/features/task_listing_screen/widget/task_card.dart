import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../../../core/widgets/task_priority_badge.dart';
import '../../../../core/widgets/task_status_badge.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../../task_details_screen/view/task_details_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isSelected;
  final VoidCallback onSelectToggle;
  final Function(String newStatus) onStatusChange;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.isSelected,
    required this.onSelectToggle,
    required this.onStatusChange,
    required this.onDelete,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'No due date';
    final day = date.day.toString().padLeft(2, '0');
    final month = _getMonthAbbr(date.month);
    final year = date.year;
    return '$day $month $year';
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[(month - 1) % 12];
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status.toLowerCase() == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.border.withValues(alpha: 0.8),
          width: isSelected ? 1.5 : 1.0,
        ),
        boxShadow: isSelected ? AppColors.primaryShadow : AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(initialTask: task),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: Full-Width Title + Quick Options Menu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full-Width Title
                    Expanded(
                      child: Text(
                        task.title,
                        style: AppTextStyles.subtitle.copyWith(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: AppColors.textSecondary,
                          color: isCompleted
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Quick Action Menu
                    PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                      color: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      onSelected: (value) {
                        if (value == 'delete') {
                          onDelete();
                        } else if (value == 'detail') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailsScreen(initialTask: task),
                            ),
                          );
                        } else {
                          onStatusChange(value);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'detail',
                          child: Row(
                            children: [
                              const Icon(Icons.visibility_outlined, size: 18, color: AppColors.textPrimary),
                              const SizedBox(width: 10),
                              Text('View Details', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'completed',
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                              const SizedBox(width: 10),
                              Text('Mark Completed', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'in progress',
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 18, color: AppColors.info),
                              const SizedBox(width: 10),
                              Text('Mark In Progress', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'pending',
                          child: Row(
                            children: [
                              const Icon(Icons.hourglass_empty_rounded, size: 18, color: AppColors.warning),
                              const SizedBox(width: 10),
                              Text('Mark Pending', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                              const SizedBox(width: 10),
                              Text('Delete Task', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Row 2: Status & Priority Badges Side-by-side
                Row(
                  children: [
                    TaskStatusBadge(status: task.status),
                    const SizedBox(width: 8),
                    TaskPriorityBadge(priority: task.priority),
                  ],
                ),

                const SizedBox(height: 12),

                // Row 3: Assigned User Avatar & Name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        task.assignee.isNotEmpty ? task.assignee[0].toUpperCase() : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.assignee.isNotEmpty ? task.assignee : 'Unassigned',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 10),

                // Row 4: Created Date & Due Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: AppColors.textDisabled,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Created: ${_formatDate(task.createdAt)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textDisabled,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 13,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Due: ${_formatDate(task.dueDate)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
