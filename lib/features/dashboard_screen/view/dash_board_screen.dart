import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../controller/dash_board_controller.dart';
import '../widgets/recent_tasks_section.dart';
import '../widgets/task_summary_card.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

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

  void _showAllTasksModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Consumer<DashboardController>(
          builder: (context, controller, child) {
            final tasks = controller.filteredTasks;
            final currentFilter = controller.selectedFilter ?? 'all';

            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Tasks (${controller.totalTasks})',
                          style: AppTextStyles.h2,
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Filter Chips inside Modal
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            isSelected: currentFilter == 'all',
                            onTap: () => controller.setFilter('all'),
                          ),
                          _FilterChip(
                            label: 'Not Started',
                            isSelected: currentFilter == 'pending' || currentFilter == 'not started',
                            onTap: () => controller.setFilter('pending'),
                          ),
                          _FilterChip(
                            label: 'In Progress',
                            isSelected: currentFilter == 'in progress',
                            onTap: () => controller.setFilter('in progress'),
                          ),
                          _FilterChip(
                            label: 'On Hold',
                            isSelected: currentFilter == 'on hold',
                            onTap: () => controller.setFilter('on hold'),
                          ),
                          _FilterChip(
                            label: 'Completed',
                            isSelected: currentFilter == 'completed',
                            onTap: () => controller.setFilter('completed'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Task List inside Modal
                    Expanded(
                      child: tasks.isEmpty
                          ? Center(
                              child: Text(
                                'No tasks in this category.',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: tasks.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceSubtle,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value:
                                            task.status.toLowerCase() ==
                                            'completed',
                                        activeColor: AppColors.success,
                                        onChanged: (val) {
                                          controller.updateTaskStatus(
                                            task.id,
                                            val == true
                                                ? 'completed'
                                                : 'pending',
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              task.title,
                                              style: AppTextStyles.subtitle
                                                  .copyWith(
                                                    color:
                                                        AppColors.textPrimary,
                                                    decoration:
                                                        task.status
                                                                .toLowerCase() ==
                                                            'completed'
                                                        ? TextDecoration
                                                              .lineThrough
                                                        : null,
                                                  ),
                                            ),
                                            Text(
                                              'Status: ${task.status.toUpperCase()}',
                                              style: AppTextStyles.caption
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppColors.error,
                                          size: 20,
                                        ),
                                        onPressed: () =>
                                            controller.deleteTask(task.id),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 64,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Tooltip(
              message: 'Profile',
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                borderRadius: BorderRadius.circular(22),
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
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tasks',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Manage your tasks efficiently',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          // Logout Button on the Right Side of AppBar
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: IconButton(
              tooltip: 'Logout',
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(
                Icons.power_settings_new_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),
        ],
      ),

      // Floating Action Button - Navigate to Task Adding Screen
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        backgroundColor: AppColors.primary,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),

      body: Stack(
        children: [
          // Ambient Glow Orbs
          Positioned(
            top: -size.width * 0.35,
            right: -size.width * 0.25,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.18),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Main Screen Layout
          SafeArea(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 768;
                  final isTablet =
                      constraints.maxWidth >= 600 && constraints.maxWidth < 768;
                  final horizontalPadding = isWide
                      ? 36.0
                      : (isTablet ? 28.0 : 18.0);

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 12,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),

                            // 2. Search Input Field (Matching Screenshot)
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: TextField(
                                controller: TextEditingController.fromValue(
                                  TextEditingValue(
                                    text: controller.searchQuery,
                                    selection: TextSelection.collapsed(
                                      offset: controller.searchQuery.length,
                                    ),
                                  ),
                                ),
                                onChanged: (val) => controller.setSearchQuery(val),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search tasks...',
                                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search_rounded,
                                    color: AppColors.textSecondary,
                                    size: 22,
                                  ),
                                  suffixIcon: controller.searchQuery.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear_rounded,
                                            color: AppColors.textSecondary,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            controller.setSearchQuery('');
                                          },
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // 4. Summary Statistics Cards in a Row
                            Row(
                              children: [
                                Expanded(
                                  child: TaskSummaryCard(
                                    title: 'Total Tasks',
                                    count: controller.totalTasks,
                                    totalCount: controller.totalTasks,
                                    icon: Icons.checklist_rounded,
                                    accentColor: AppColors.primary,
                                    backgroundColor: AppColors.primaryLight,
                                    onTap: () => _showAllTasksModal(context),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TaskSummaryCard(
                                    title: 'Pending',
                                    count: controller.pendingTasks,
                                    totalCount: controller.totalTasks,
                                    icon: Icons.hourglass_empty_rounded,
                                    accentColor: AppColors.warning,
                                    backgroundColor: AppColors.statusPendingBg,
                                    onTap: () => _showAllTasksModal(context),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TaskSummaryCard(
                                    title: 'In Progress',
                                    count: controller.inProgressTasks,
                                    totalCount: controller.totalTasks,
                                    icon: Icons.sync_rounded,
                                    accentColor: AppColors.info,
                                    backgroundColor:
                                        AppColors.statusInProgressBg,
                                    onTap: () => _showAllTasksModal(context),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TaskSummaryCard(
                                    title: 'Completed',
                                    count: controller.completedTasks,
                                    totalCount: controller.totalTasks,
                                    icon: Icons.task_alt_rounded,
                                    accentColor: AppColors.success,
                                    backgroundColor:
                                        AppColors.statusCompletedBg,
                                    onTap: () => _showAllTasksModal(context),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // 5. Section Header: Recent Tasks & View All Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Recent Tasks',
                                  style: AppTextStyles.h3.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushNamed(context, '/task-list'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  child: Text(
                                    'View All',
                                    style: AppTextStyles.button.copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // 6. Main Task Cards List View
                            RecentTasksSection(
                              onViewAllTap: () => Navigator.pushNamed(context, '/task-list'),
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surfaceSubtle,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onSelected: (_) => onTap(),
      ),
    );
  }
}
