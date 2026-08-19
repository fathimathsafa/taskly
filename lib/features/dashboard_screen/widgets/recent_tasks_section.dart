import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../../../core/widgets/task_priority_badge.dart';
import '../../../../core/widgets/task_status_badge.dart';
import '../../task_details_screen/view/task_details_screen.dart';
import '../controller/dash_board_controller.dart';
import '../model/task_model.dart';

class RecentTasksSection extends StatelessWidget {
  final VoidCallback onViewAllTap;

  const RecentTasksSection({
    super.key,
    required this.onViewAllTap,
  });

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      case 'low':
        return AppColors.priorityLow;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'in progress':
        return AppColors.info;
      case 'on hold':
        return AppColors.warning;
      case 'pending':
      case 'not started':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.statusCompletedBg;
      case 'in progress':
        return AppColors.statusInProgressBg;
      case 'on hold':
      case 'pending':
      case 'not started':
        return AppColors.statusPendingBg;
      default:
        return AppColors.surfaceSubtle;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline_rounded;
      case 'in progress':
        return Icons.access_time_rounded;
      case 'on hold':
        return Icons.pause_circle_outline_rounded;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final allTasks = controller.filteredTasks;
    final tasks = allTasks.take(6).toList();

    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.assignment_outlined,
              color: AppColors.textSecondary,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              'No tasks in this category',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.textPrimary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try changing your filter or add a new task.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final statusColor = _getStatusColor(task.status);
        final statusBgColor = _getStatusBgColor(task.status);
        final statusIcon = _getStatusIcon(task.status);
        final priorityColor = _getPriorityColor(task.priority);
        final dateStr = _formatDate(task.dueDate);

        return _TaskCard(
          task: task,
          statusColor: statusColor,
          statusBgColor: statusBgColor,
          statusIcon: statusIcon,
          priorityColor: priorityColor,
          dateStr: dateStr,
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final Color statusColor;
  final Color statusBgColor;
  final IconData statusIcon;
  final Color priorityColor;
  final String dateStr;

  const _TaskCard({
    required this.task,
    required this.statusColor,
    required this.statusBgColor,
    required this.statusIcon,
    required this.priorityColor,
    required this.dateStr,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<DashboardController>();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(initialTask: task),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Full-Width Title + Quick Actions Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: AppTextStyles.subtitle.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.35,
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Quick Actions Menu
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  onSelected: (action) {
                    if (action == 'delete') {
                      controller.deleteTask(task.id);
                    } else {
                      controller.updateTaskStatus(task.id, action);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'pending',
                      child: Text('Mark as Pending'),
                    ),
                    const PopupMenuItem(
                      value: 'in progress',
                      child: Text('Mark as In Progress'),
                    ),
                    const PopupMenuItem(
                      value: 'on hold',
                      child: Text('Mark as On Hold'),
                    ),
                    const PopupMenuItem(
                      value: 'completed',
                      child: Text('Mark as Completed'),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete Task',
                        style: TextStyle(color: AppColors.error),
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
                TaskStatusBadge(status: task.status, fontSize: 11),
                const SizedBox(width: 8),
                TaskPriorityBadge(priority: task.priority, fontSize: 11),
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
            Divider(
              color: AppColors.border.withValues(alpha: 0.6),
              height: 1,
              thickness: 1,
            ),
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
                      'Due: $dateStr',
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
    );
}
}
