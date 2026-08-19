import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../controller/task_listing_controller.dart';

class TaskListingHeader extends StatelessWidget {
  final TaskListingController controller;
  final TextEditingController searchController;

  const TaskListingHeader({
    super.key,
    required this.controller,
    required this.searchController,
  });

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final statusFilters = ['All', 'Pending', 'In Progress', 'On Hold', 'Completed'];
            final priorityFilters = ['All', 'High', 'Medium', 'Low'];

            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
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
                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Filter & Sort Tasks', style: AppTextStyles.h2),
                        if (controller.selectedStatus != 'All' || controller.selectedPriority != 'All')
                          TextButton(
                            onPressed: () {
                              controller.resetFilters();
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Reset All',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Status Section
                    Text('Status', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: statusFilters.map((status) {
                        final isSelected = controller.selectedStatus.toLowerCase() == status.toLowerCase();
                        return FilterChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (_) {
                            controller.setStatusFilter(status);
                            setModalState(() {});
                          },
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceSubtle,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Priority Section
                    Text('Priority', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: priorityFilters.map((priority) {
                        final isSelected = controller.selectedPriority.toLowerCase() == priority.toLowerCase();
                        return FilterChip(
                          label: Text(priority),
                          selected: isSelected,
                          onSelected: (_) {
                            controller.setPriorityFilter(priority);
                            setModalState(() {});
                          },
                          selectedColor: AppColors.primaryDark,
                          backgroundColor: AppColors.surfaceSubtle,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? AppColors.primaryDark : AppColors.border,
                            ),
                          ),
                          showCheckmark: false,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Apply Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Apply Filters', style: AppTextStyles.button.copyWith(color: Colors.white)),
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
    final hasActiveFilter = controller.selectedStatus != 'All' || controller.selectedPriority != 'All';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar + Filter Button (Compact, Space-Saving Layout)
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (val) => controller.setSearchQuery(val),
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, color: AppColors.textSecondary, size: 16),
                            onPressed: () {
                              searchController.clear();
                              controller.setSearchQuery('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // Compact Filter Button
            InkWell(
              onTap: () => _showFilterModal(context),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: hasActiveFilter ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: hasActiveFilter ? AppColors.primary : AppColors.primary.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      color: hasActiveFilter ? Colors.white : AppColors.textPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Filter',
                      style: AppTextStyles.subtitle.copyWith(
                        color: hasActiveFilter ? Colors.white : AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Active Filter Indicator Strip (Shown only if filter is active)
        if (hasActiveFilter) ...[
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (controller.selectedStatus != 'All') ...[
                  Chip(
                    label: Text('Status: ${controller.selectedStatus}'),
                    backgroundColor: AppColors.primaryLight,
                    labelStyle: TextStyle(color: AppColors.primarySoft, fontSize: 11, fontWeight: FontWeight.bold),
                    deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primarySoft),
                    onDeleted: () => controller.setStatusFilter('All'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
                  ),
                  const SizedBox(width: 8),
                ],
                if (controller.selectedPriority != 'All') ...[
                  Chip(
                    label: Text('Priority: ${controller.selectedPriority}'),
                    backgroundColor: AppColors.primaryLight,
                    labelStyle: TextStyle(color: AppColors.primarySoft, fontSize: 11, fontWeight: FontWeight.bold),
                    deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primarySoft),
                    onDeleted: () => controller.setPriorityFilter('All'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
                  ),
                  const SizedBox(width: 8),
                ],
                TextButton(
                  onPressed: () => controller.resetFilters(),
                  child: Text('Reset', style: AppTextStyles.caption.copyWith(color: AppColors.error)),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
