import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skygoaltest/core/themes/app_theme.dart';
import 'package:skygoaltest/core/widgets/gap/gap_widget.dart';
import 'package:skygoaltest/features/onboarding/onboarding_model.dart';

import '../../core/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /* ------------------------------ Carousel Data ----------------------------- */
  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: "Gain total control\nof your money",
      subtitle: "Become your own money manager\nand make every cent count",
      imagePath: "assets/images/onboarding1.png",
    ),
    OnboardingData(
      title: "Know where your\nmoney goes",
      subtitle: "Track your transaction easily,\nwith categories and financial report",
      imagePath: "assets/images/onboarding2.png",
    ),
    OnboardingData(
      title: "Planning ahead",
      subtitle: "Setup your budget for each category\nso you in control",
      imagePath: "assets/images/onboarding3.png",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
    return Scaffold(
      backgroundColor: AppTheme.cardBackground(context),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            /* ------------------------------ Carousel View ----------------------------- */
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 312,
                          width: 312,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                          child: Center(child: Image.asset(_onboardingData[index].imagePath)),
                        ),

                        Gap(60),

                        Text(
                          _onboardingData[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppTheme.textColor(context), height: 1.2),
                        ),

                        Gap(20),

                        // Subtitle
                        Text(
                          _onboardingData[index].subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: AppTheme.subtitleColor(context), height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            /* ------------------------------- Indicators ------------------------------- */
            Row(mainAxisAlignment: MainAxisAlignment.center, children: _buildPageIndicators()),

            Gap(40),

            /* --------------------------------- Buttons -------------------------------- */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  // Sign Up button
                  CustomFilledButton(
                    onPressed: () {
                      context.push('/sign-up');
                    },
                    title: "Sign Up",
                  ),
                  Gap(16),
                  // Login button
                  CustomOutlineButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    title: "Login",
                  ),
                ],
              ),
            ),

            Gap(40),

            

            Gap(8),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < _onboardingData.length; i++) {
      indicators.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == i ? 12 : 8,
          height: _currentPage == i ? 12 : 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: _currentPage == i ? Color(0xFF7C3AED) : Colors.grey[300]),
        ),
      );
    }
    return indicators;
  }
}
