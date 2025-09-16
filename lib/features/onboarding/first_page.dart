import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(height: double.infinity, width: double.infinity, color: AppTheme.primary, child: AppLogoWidget()),
    );
  }
}

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 197,
        height: 90,
        // color: Colors.red,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /* Positioned(
              left: 35,
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                  child: Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFCAC12).withValues(alpha: 0.7),
                      backgroundBlendMode: BlendMode.overlay,
                    ),
                  ),
                ),
              ),
            ), */

            GestureDetector(
              onTap: () {
                context.push('/carousel-first-page');
              },
              child: Text(
                'montra',
                style: TextStyle(fontSize: 56, fontFamily: 'Inter', fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
