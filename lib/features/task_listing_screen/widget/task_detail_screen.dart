import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../dashboard_screen/model/task_model.dart';
import '../controller/task_listing_controller.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not Specified';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day-$month-$year';
  }

  String _formatFullDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$day-$month-$year at $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TaskListingController>();
    // Get updated instance of task if modified
    final updatedTask = controller.tasks.firstWhere(
      (t) => t.id == task.id,
      orElse: () => task,
    );

    final priorityColor = AppColors.priorityColor(updatedTask.priority);
    final priorityBgColor = AppColors.priorityBgColor(updatedTask.priority);
    final statusColor = AppColors.statusColor(updatedTask.status);
    final statusBgColor = AppColors.statusBgColor(updatedTask.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Task Details', style: AppTextStyles.h2),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () {
              controller.deleteTask(updatedTask.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Priority Badges Row
            Row(
              children: [
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 8, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        updatedTask.status.toUpperCase(),
                        style: AppTextStyles.badge.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Priority Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: priorityBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: priorityColor.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.flag_rounded, size: 14, color: priorityColor),
                      const SizedBox(width: 6),
                      Text(
                        '${updatedTask.priority.toUpperCase()} PRIORITY',
                        style: AppTextStyles.badge.copyWith(color: priorityColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Task Title
            Text(
              updatedTask.title,
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                height: 1.3,
              ),
            ),

            const SizedBox(height: 8),

            // Project tag
            Row(
              children: [
                const Icon(Icons.folder_open_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  updatedTask.project,
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.primarySoft),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 16),

            // Description Section
            Text('Description', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                updatedTask.description,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Task Metadata Overview (Grid cards displaying required attributes)
            Text('Task Overview', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),

            _buildDetailTile(
              icon: Icons.person_outline_rounded,
              iconColor: AppColors.primary,
              title: 'Assigned User',
              value: updatedTask.assignee,
            ),
            const SizedBox(height: 10),

            _buildDetailTile(
              icon: Icons.rate_review_outlined,
              iconColor: AppColors.info,
              title: 'Reviewer',
              value: updatedTask.reviewer,
            ),
            const SizedBox(height: 10),

            _buildDetailTile(
              icon: Icons.calendar_today_rounded,
              iconColor: AppColors.warning,
              title: 'Due Date',
              value: _formatDate(updatedTask.dueDate),
            ),
            const SizedBox(height: 10),

            _buildDetailTile(
              icon: Icons.access_time_rounded,
              iconColor: AppColors.textSecondary,
              title: 'Created Date',
              value: _formatFullDate(updatedTask.createdAt),
            ),

            const SizedBox(height: 28),

            // Status Update Quick Action Buttons
            Text('Change Task Status', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatusButton(
                  label: 'Pending',
                  icon: Icons.hourglass_empty_rounded,
                  color: AppColors.warning,
                  isSelected: updatedTask.status.toLowerCase() == 'pending',
                  onTap: () => controller.updateTaskStatus(updatedTask.id, 'pending'),
                ),
                _StatusButton(
                  label: 'In Progress',
                  icon: Icons.sync_rounded,
                  color: AppColors.info,
                  isSelected: updatedTask.status.toLowerCase() == 'in progress',
                  onTap: () => controller.updateTaskStatus(updatedTask.id, 'in progress'),
                ),
                _StatusButton(
                  label: 'Completed',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.success,
                  isSelected: updatedTask.status.toLowerCase() == 'completed',
                  onTap: () => controller.updateTaskStatus(updatedTask.id, 'completed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.subtitle.copyWith(color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.2) : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isSelected ? color : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.subtitle.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
