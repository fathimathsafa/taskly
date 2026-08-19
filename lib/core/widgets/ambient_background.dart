import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Top Right Ambient Glow Orb
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

        // Main Screen Body Content
        child,
      ],
    );
  }
}
