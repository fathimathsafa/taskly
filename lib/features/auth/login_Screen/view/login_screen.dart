import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly/core/theme/app_textstyles.dart';
import 'package:taskly/core/widgets/custom_textfiled.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controller/login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _handleForgotPassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text('Reset Password', style: AppTextStyles.h3),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Password reset is unavailable in offline build. '
              'Please contact your system administrator.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                label: 'Got it',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<LoginScreenController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Ambient Glow Background Accents
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
                        AppColors.primary.withValues(alpha: 0.22),
                        AppColors.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -size.width * 0.35,
                left: -size.width * 0.25,
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.secondary.withValues(alpha: 0.12),
                        AppColors.secondary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),

              // Main View Content
              SafeArea(
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 500;
                      final horizontalPadding = isWide ? 32.0 : 24.0;

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: 24,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 440,
                              minHeight: constraints.maxHeight - 48,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),

                                  // Title & Subtitle
                                  Text(
                                    'Sign In',
                                    style: AppTextStyles.display.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: isWide ? 36 : 32,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Enter your credentials to access your task workspace.',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),

                                  const SizedBox(height: 36),

                                  // Login Form
                                  Form(
                                    key: controller.formKey,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // 1. Email Field
                                        CustomTextField(
                                          label: 'Email Address',
                                          hint: 'you@company.com',
                                          controller: controller.emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          validator: controller.validateEmail,
                                          prefixIcon: const Icon(
                                            Icons.email_outlined,
                                            color: AppColors.textSecondary,
                                            size: 20,
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        // 2. Password Field with Show/Hide Toggle
                                        CustomTextField(
                                          label: 'Password',
                                          hint: '••••••••',
                                          controller: controller.passwordController,
                                          obscureText: controller.obscurePassword,
                                          validator: controller.validatePassword,
                                          prefixIcon: const Icon(
                                            Icons.lock_outline_rounded,
                                            color: AppColors.textSecondary,
                                            size: 20,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              controller.obscurePassword
                                                  ? Icons.visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: AppColors.textSecondary,
                                              size: 20,
                                            ),
                                            onPressed: controller.togglePasswordVisibility,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        // 3. Forgot Password Option
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () => _handleForgotPassword(context),
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            child: Text(
                                              'Forgot Password?',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Error Banner
                                        if (controller.loginError != null) ...[
                                          const SizedBox(height: 16),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.priorityHighBg,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppColors.error.withValues(alpha: 0.3),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.error_outline_rounded,
                                                  color: AppColors.error,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    controller.loginError!,
                                                    style: AppTextStyles.bodySmall.copyWith(
                                                      color: AppColors.error,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],

                                        const SizedBox(height: 32),

                                        // 4. Login Button
                                        SizedBox(
                                          width: double.infinity,
                                          child: CustomButton(
                                            label: 'Log In',
                                            isLoading: controller.isLoading,
                                            onPressed: () async {
                                              final success = await controller.handleLogin();
                                              if (success && context.mounted) {
                                                Navigator.of(context).pushReplacementNamed('/dashboard');
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),
                                ],
                              ),
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
      },
    );
  }
}