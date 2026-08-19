import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/core/theme/app_textstyles.dart';
import '../../../../core/theme/app_colors.dart';
import '../controller/task_adding_controller.dart';
import '../widget/task_form_fields.dart';
import '../widget/task_submit_button.dart';

class TaskAddingScreen extends StatelessWidget {
  const TaskAddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<TaskAddingController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
            ),
            title: Text(
              'Create New Task',
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            centerTitle: false,
          ),
          body: Stack(
            children: [
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
                        AppColors.primary.withValues(alpha: 0.16),
                        AppColors.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 12.0,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),

                          TaskFormFields(controller: controller),

                          const SizedBox(height: 28),

                          const TaskSubmitButton(),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
