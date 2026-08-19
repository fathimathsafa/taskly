import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../task_listing_screen/controller/task_listing_controller.dart';
import '../controller/task_details_controller.dart';

class EditTaskDialog extends StatefulWidget {
  final TaskDetailsController controller;
  final TaskListingController taskListingController;

  const EditTaskDialog({
    super.key,
    required this.controller,
    required this.taskListingController,
  });

  static Future<void> show(
    BuildContext context,
    TaskDetailsController controller,
    TaskListingController taskListingController,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => EditTaskDialog(
        controller: controller,
        taskListingController: taskListingController,
      ),
    );
  }

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _assigneeController;

  late String _priority;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    final task = widget.controller.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(text: task?.description ?? '');
    _assigneeController = TextEditingController(text: task?.assignee ?? '');
    _priority = task?.priority ?? 'medium';
    _dueDate = task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assigneeController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
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
            dialogTheme: const DialogThemeData(
              backgroundColor: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.controller.updateTaskDetails(
        title: _titleController.text,
        description: _descriptionController.text,
        priority: _priority,
        assignee: _assigneeController.text,
        dueDate: _dueDate,
        taskListingController: widget.taskListingController,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Text('Task updated successfully!', style: AppTextStyles.subtitle.copyWith(color: Colors.white)),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomInset + 24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Task Details', style: AppTextStyles.h2),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Task Title
              Text('Task Title *', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                decoration: _inputDecoration('Title'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 14),

              // Description
              Text('Description *', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                decoration: _inputDecoration('Description'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 14),

              // Priority Selector
              Text('Priority', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              Row(
                children: ['low', 'medium', 'high'].map((p) {
                  final isSelected = _priority.toLowerCase() == p.toLowerCase();
                  final color = AppColors.priorityColor(p);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            p.toUpperCase(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: color,
                        backgroundColor: AppColors.surfaceSubtle,
                        onSelected: (_) => setState(() => _priority = p),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Assignee Field
              Text('Assigned User *', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              TextFormField(
                controller: _assigneeController,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                decoration: _inputDecoration('Assignee'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Assignee is required' : null,
              ),
              const SizedBox(height: 14),

              // Due Date Picker
              Text('Due Date', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDueDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dueDate == null
                            ? 'Select due date'
                            : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _dueDate == null ? AppColors.textDisabled : AppColors.textPrimary,
                        ),
                      ),
                      const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text('Save Changes', style: AppTextStyles.button.copyWith(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 6,
                    shadowColor: AppColors.primary.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDisabled),
      filled: true,
      fillColor: AppColors.surfaceSubtle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
