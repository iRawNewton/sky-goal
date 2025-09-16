import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../themes/app_theme.dart';
import '../themes/theme_cubit.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;

  const ErrorPage({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Error',
          // style: context.bodyLarge.copyWith(color: context.onPrimary),
        ),
        backgroundColor: AppTheme.darkBackground,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                // color: context.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Page Not Found',
                // style: context.displayMedium.copyWith(
                //   fontSize: 24,
                //   fontWeight: FontWeight.bold,
                // ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                // style: context.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.go('/dashboard');
                },
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: context.secondary,
                //   foregroundColor: context.onSecondary,
                // ),
                child: Text(
                  'Go to Dashboard',
                  // style: context.labelLarge,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.read<ThemeCubit>().toggle();
                },
                child: Text(
                  'Toggle Theme',
                  // style: context.labelMedium.copyWith(color: context.secondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
