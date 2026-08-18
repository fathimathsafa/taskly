import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfiled.dart';
import '../controller/dash_board_controller.dart';

class QuickAddTaskDialog extends StatefulWidget {
  const QuickAddTaskDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const QuickAddTaskDialog(),
    );
  }

  @override
  State<QuickAddTaskDialog> createState() => _QuickAddTaskDialogState();
}

class _QuickAddTaskDialogState extends State<QuickAddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedPriority = 'medium';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<DashboardController>().addTask(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _selectedPriority,
        );

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Task added successfully!'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: SingleChildScrollView(
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Quick Add Task', style: AppTextStyles.h2),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Task Title',
                    hint: 'e.g. Design app onboarding screen',
                    controller: _titleController,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Task title is required.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  CustomTextField(
                    label: 'Description',
                    hint: 'Add details or context for this task...',
                    controller: _descriptionController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 18),

                  // Priority Selector
                  Text('Priority', style: AppTextStyles.subtitle),
                  const SizedBox(height: 8),
                  Row(
                    children: ['low', 'medium', 'high'].map((priority) {
                      final isSelected = _selectedPriority == priority;
                      final color = priority == 'high'
                          ? AppColors.priorityHigh
                          : priority == 'medium'
                              ? AppColors.priorityMedium
                              : AppColors.priorityLow;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(
                            priority.toUpperCase(),
                            style: AppTextStyles.caption.copyWith(
                              color: isSelected ? Colors.white : color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: color,
                          backgroundColor: color.withValues(alpha: 0.12),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onSelected: (val) {
                            if (val) {
                              setState(() => _selectedPriority = priority);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: 'Create Task',
                      onPressed: _handleSubmit,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}