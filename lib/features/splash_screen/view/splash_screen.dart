import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_textstyles.dart';
import '../controller/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final controller = context.read<SplashScreenController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.handleSplashNavigation(context);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -size.width * 0.3,
            right: -size.width * 0.2,
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
            bottom: -size.width * 0.3,
            left: -size.width * 0.2,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.16),
                    AppColors.secondary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              'Taskly',
              style: AppTextStyles.display.copyWith(
                color: AppColors.textPrimary,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
