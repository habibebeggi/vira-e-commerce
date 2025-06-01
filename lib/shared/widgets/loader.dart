import 'package:flutter/material.dart';
import 'package:vira/shared/theme/app_colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
