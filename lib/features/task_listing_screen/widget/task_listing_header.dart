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
            final statusFilters = ['All', 'Pending', 'In Progress', 'Completed'];
            final priorityFilters = ['All', 'Low', 'Medium', 'High'];

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
                        Text('Filter Tasks', style: AppTextStyles.h2),
                        if (controller.hasActiveFilter)
                          TextButton(
                            onPressed: () {
                              searchController.clear();
                              controller.resetFilters();
                              setModalState(() {});
                            },
                            child: Text(
                              'Clear All',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text('Status Filter', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
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

                    Text('Priority Filter', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
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
                    const SizedBox(height: 20),

                    Text('Due Date Filter', style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDueDate ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  surface: AppColors.surface,
                                  onSurface: AppColors.textPrimary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          controller.setDueDateFilter(picked);
                          setModalState(() {});
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: controller.selectedDueDate != null
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: controller.selectedDueDate != null
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_rounded,
                              size: 20,
                              color: controller.selectedDueDate != null
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                controller.selectedDueDate != null
                                    ? '${controller.selectedDueDate!.day.toString().padLeft(2, '0')}/${controller.selectedDueDate!.month.toString().padLeft(2, '0')}/${controller.selectedDueDate!.year}'
                                    : 'Select Due Date',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: controller.selectedDueDate != null
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: controller.selectedDueDate != null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (controller.selectedDueDate != null)
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.primary),
                                onPressed: () {
                                  controller.setDueDateFilter(null);
                                  setModalState(() {});
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 4,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          'Apply Filters',
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
    final hasActiveFilter = controller.hasActiveFilter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    hintText: 'Search title or description...',
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

                if (controller.selectedDueDate != null) ...[
                  Chip(
                    label: Text('Due: ${controller.selectedDueDate!.day}/${controller.selectedDueDate!.month}/${controller.selectedDueDate!.year}'),
                    backgroundColor: AppColors.primaryLight,
                    labelStyle: TextStyle(color: AppColors.primarySoft, fontSize: 11, fontWeight: FontWeight.bold),
                    deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primarySoft),
                    onDeleted: () => controller.setDueDateFilter(null),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
                  ),
                  const SizedBox(width: 8),
                ],

                if (controller.searchQuery.isNotEmpty) ...[
                  Chip(
                    label: Text('Search: "${controller.searchQuery}"'),
                    backgroundColor: AppColors.primaryLight,
                    labelStyle: TextStyle(color: AppColors.primarySoft, fontSize: 11, fontWeight: FontWeight.bold),
                    deleteIcon: const Icon(Icons.close_rounded, size: 14, color: AppColors.primarySoft),
                    onDeleted: () {
                      searchController.clear();
                      controller.setSearchQuery('');
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
                  ),
                  const SizedBox(width: 8),
                ],

                TextButton(
                  onPressed: () {
                    searchController.clear();
                    controller.resetFilters();
                  },
                  child: Text('Clear All', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
