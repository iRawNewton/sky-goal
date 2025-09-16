import 'package:flutter/material.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(child: CircularProgressIndicator(color: AppTheme.violet100(context))),
    );
  }
}
