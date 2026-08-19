import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyles.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  const SharedAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
            )
          : null,
      title: Text(
        title,
        style: AppTextStyles.h1.copyWith(
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
