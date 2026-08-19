import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';

class TaskAddingHeader extends StatelessWidget {
  const TaskAddingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Create New Task',
            style: AppTextStyles.h1.copyWith(
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ],
    );
  }
}
