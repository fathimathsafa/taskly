import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../controller/task_adding_controller.dart';

class TaskFormFields extends StatelessWidget {
  final TaskAddingController controller;

  const TaskFormFields({
    super.key,
    required this.controller,
  });

  Future<void> _selectDueDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.dueDate ?? now.add(const Duration(days: 3)),
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setDueDate(picked);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Due Date *';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Task Title *'),
        const SizedBox(height: 6),
        TextField(
          onChanged: (val) => controller.setTitle(val),
          maxLength: 100,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: _inputDecoration(
            hint: 'Enter concise task title...',
            icon: Icons.title_rounded,
            errorText: controller.titleError,
            currentLength: controller.title.length,
            maxLength: 100,
          ),
        ),

        const SizedBox(height: 18),

        _buildFieldLabel('Description *'),
        const SizedBox(height: 6),
        TextField(
          onChanged: (val) => controller.setDescription(val),
          maxLines: 4,
          maxLength: 500,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: _inputDecoration(
            hint: 'Enter detailed task requirements and notes...',
            icon: Icons.description_outlined,
            errorText: controller.descriptionError,
            currentLength: controller.description.length,
            maxLength: 500,
          ),
        ),

        const SizedBox(height: 18),

        _buildFieldLabel('Priority Level *'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: controller.priorityError != null
                  ? AppColors.error
                  : AppColors.primary.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: Row(
            children: ['low', 'medium', 'high'].map((p) {
              final isSelected = controller.priority.toLowerCase() == p.toLowerCase();
              final color = AppColors.priorityColor(p);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: () => controller.setPriority(p),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color
                            : AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? color : Colors.transparent,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            size: 14,
                            color: isSelected ? Colors.white : color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            p.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: isSelected ? Colors.white : color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (controller.priorityError != null) ...[
          const SizedBox(height: 4),
          Text(controller.priorityError!, style: AppTextStyles.errorText),
        ],

        const SizedBox(height: 18),

        // 4. Initial Status Selector Field
        _buildFieldLabel('Initial Status *'),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: controller.statusError != null
                  ? AppColors.error
                  : AppColors.primary.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: controller.status,
              dropdownColor: AppColors.surface,
              isExpanded: true,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.primary,
                size: 22,
              ),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'in progress', child: Text('In Progress')),
                DropdownMenuItem(value: 'on hold', child: Text('On Hold')),
                DropdownMenuItem(value: 'completed', child: Text('Completed')),
              ],
              onChanged: (val) {
                if (val != null) controller.setStatus(val);
              },
            ),
          ),
        ),
        if (controller.statusError != null) ...[
          const SizedBox(height: 4),
          Text(controller.statusError!, style: AppTextStyles.errorText),
        ],

        const SizedBox(height: 18),

        // 5. Assigned User Field
        _buildFieldLabel('Assigned User *'),
        const SizedBox(height: 6),
        TextField(
          onChanged: (val) => controller.setAssignee(val),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          decoration: _inputDecoration(
            hint: 'Enter assignee full name...',
            icon: Icons.person_outline_rounded,
            errorText: controller.assigneeError,
          ),
        ),

        const SizedBox(height: 18),

        // 6. Due Date Selector Field
        _buildFieldLabel('Due Date *'),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _selectDueDate(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: controller.dueDateError != null
                    ? AppColors.error
                    : AppColors.primary.withValues(alpha: 0.4),
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _formatDate(controller.dueDate),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: controller.dueDate == null
                                ? AppColors.textDisabled
                                : AppColors.textPrimary,
                            fontWeight: controller.dueDate == null
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.edit_calendar_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
        if (controller.dueDateError != null) ...[
          const SizedBox(height: 4),
          Text(controller.dueDateError!, style: AppTextStyles.errorText),
        ],
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 13,
        letterSpacing: 0.2,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    String? errorText,
    int? currentLength,
    int? maxLength,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary.withValues(alpha: 0.6),
      ),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      errorText: errorText,
      errorStyle: AppTextStyles.errorText,
      counterText: (maxLength != null && currentLength != null)
          ? '$currentLength/$maxLength'
          : null,
      counterStyle: AppTextStyles.caption.copyWith(
        color: AppColors.textDisabled,
        fontSize: 11,
      ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.4), width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.4), width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}
