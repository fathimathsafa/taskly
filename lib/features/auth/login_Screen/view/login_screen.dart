import 'package:flutter/material.dart';
import 'package:taskly/core/theme/app_textstyles.dart';
import 'package:taskly/core/widgets/custom_textfiled.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

const String kMockEmail = 'admin@example.com';
const String kMockPassword = '123456';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _loginError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required.';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    setState(() => _loginError = null);

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network authentication call
    await Future.delayed(const Duration(milliseconds: 800));

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == kMockEmail && password == kMockPassword) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loginError = 'Invalid email or password. Please try again.';
      });
    }
  }

  void _handleForgotPassword() {
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ---------- Purple Violet Ambient Decorative Glow ----------
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

          // ---------- Main View Content ----------
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

                              // ---------- Title & Subtitle ----------
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

                              // ---------- Login Form ----------
                              Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 1. Email Field
                                    CustomTextField(
                                      label: 'Email Address',
                                      hint: 'you@company.com',
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: _validateEmail,
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
                                      controller: _passwordController,
                                      obscureText: _obscurePassword,
                                      validator: _validatePassword,
                                      prefixIcon: const Icon(
                                        Icons.lock_outline_rounded,
                                        color: AppColors.textSecondary,
                                        size: 20,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // 3. Forgot Password Option
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: _handleForgotPassword,
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

                                    // ---------- Error Banner ----------
                                    if (_loginError != null) ...[
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
                                                _loginError!,
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
                                        isLoading: _isLoading,
                                        onPressed: _handleLogin,
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
  }
}