import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AppLoader extends StatelessWidget {
  final String? message;
  final double size;

  const AppLoader({
    super.key,
    this.message,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              color: AppTheme.secondary,
            ),
          ),

          if (message != null) ...[
            const SizedBox(height: 14),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}